SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_CRUD_PackingJob_Complete]
	@User varchar(5)
,	@PackingJobNumber varchar(50)
,	@ShelfInventoryFlag bit
,	@JobDoneFlag bit
,	@TranDT datetime = null out
,	@Result integer = null out
,	@Debug int = 0
,	@DebugMsg varchar(max) = null out
as
begin

	--set xact_abort on
	set nocount on

	--- <TIC>
	declare
		@cDebug int = @Debug + 2 -- Proc level

	if	@Debug & 0x01 = 0x01 begin
		declare
			@TicDT datetime = getdate()
		,	@TocDT datetime
		,	@TimeDiff varchar(max)
		,	@TocMsg varchar(max)
		,	@cDebugMsg varchar(max)

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	end
	--- </TIC>

	--- <SP Begin Logging>
	declare
		@LogID int

	insert
		FXSYS.USP_Calls
	(	USP_Name
	,	BeginDT
	,	InArguments
	)
	select
		USP_Name = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@User] = @User
					,	[@PackingJobNumber] = @PackingJobNumber
					,	[@ShelfInventoryFlag] = @ShelfInventoryFlag
					,	[@JobDoneFlag] = @JobDoneFlag
					,	[@TranDT] = @TranDT
					,	[@Result] = @Result
					,	[@Debug] = @Debug
					,	[@DebugMsg] = @DebugMsg
					for xml raw			
				)
			)

	set	@LogID = scope_identity()
	--- </SP Begin Logging>

	set	@Result = 999999

	--- <Error Handling>
	declare
		@CallProcName sysname
	,	@TableName sysname
	,	@ProcName sysname
	,	@ProcReturn integer
	,	@ProcResult integer
	,	@Error integer
	,	@RowCount integer

	set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. FXPL.usp_Test
	--- </Error Handling>

	/*	Record initial transaction count. */
	declare
		@TranCount smallint

	set	@TranCount = @@TranCount

	begin try

		---	<ArgumentValidation>
		/*	Must have inventory to complete */
		if	not exists
			(	select
					*
				from
					FXPL.PackingJobObjects pjo
				where
					pjo.PackingJobNumber = @PackingJobNumber
					and pjo.Status = 0
			) begin
			raiserror ('Validation Failed: Packing job has no inventory to complete', 16, 1)
			return
		end

		/*	Partial combines must have the from object label re-printed */
		---	</ArgumentValidation>

		--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
		if	@TranCount = 0 begin
			begin tran @ProcName
		end
		else begin
			save tran @ProcName
		end
		set	@TranDT = coalesce(@TranDT, GetDate())
		--- </Tran>

		--- <Body>
		/*	Job complete pre-objects. */
		set @TocMsg = 'Job complete pre-objects'
		begin
			declare
				preObjects
			cursor local for
				select
					pjo.Serial
				from
					FXPL.PackingJobObjects pjo
				where
					pjo.PackingJobNumber = @PackingJobNumber
					and pjo.Status = 0

			open
				preObjects

			while
				1 = 1 begin

				declare
					@SerialToComplete int

				fetch
					preObjects
				into
					@SerialToComplete

				if	@@FETCH_STATUS != 0 begin
					break
				end

				--- <Call>
				set	@CallProcName = 'dbo.usp_MES_JCPreObject'
			
				exec dbo.usp_MES_JCPreObject
					@Operator = @User
				,	@PreObjectSerial = @SerialToComplete
				,	@TranDT = @TranDT out
				,	@Result = @Result out

				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
					rollback tran @ProcName
					return
				end
				--- </Call>
			end
			close
				preObjects
			deallocate
				preObjects

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Mark the packing job inventory as completed. */
		set @TocMsg = 'Mark the packing job inventory as completed'
		begin
			--- <Update rows="1+">
			set	@TableName = 'FXPL.PackingJobObjects'
			
			update
				pjo
			set
				pjo.Status = 2
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status >= 0
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount <= 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Update>
				
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
		
		/*	Perform whole object combines. */
		set @TocMsg = 'Perform whole object combines'
		if	exists
			(	select
					*
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.Status = 0
					and pjc.FromNewQuantity = 0
			)
		begin
			declare
				wholeCombines
			cursor local for
				select
					pjc.FromSerial
				,	pjc.ToSerial
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.Status = 0
					and pjc.FromNewQuantity = 0

			open
				wholeCombines

			while
				1 = 1 begin

				declare
					@fromSerialWhole int
				,	@toSerialWhole int

				fetch
					wholeCombines
				into
					@fromSerialWhole
				,	@toSerialWhole

				if	@@FETCH_STATUS != 0 begin
					break
				end

				--- <Call>	
				set	@CallProcName = 'dbo.usp_InventoryControl_Combine'
				
				execute @ProcReturn = dbo.usp_InventoryControl_Combine
						@Operator = @User
					,	@FromSerial = @fromSerialWhole
					,	@ToSerial = @toSerialWhole
					,	@TranDT = @TranDT out
					,	@Result = @ProcResult out
				
				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
					rollback tran @ProcName
					return
				end
				--- </Call>
			end
			close
				wholeCombines
			deallocate
				wholeCombines

			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Perform partial object breakout-combines. */
		set @TocMsg = 'Perform partial object breakout-combines'
		if	exists
			(	select
					*
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.Status = 0
					and pjc.FromNewQuantity > 0
			)
		begin
			declare
				partialCobines
			cursor local for
				select
					pjc.FromSerial
				,	pjc.ToSerial
				,	CombineQuantity = pjc.FromOriginalQuantity - pjc.FromNewQuantity
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.FromNewQuantity > 0

			open
				partialCobines

			while
				1 = 1 begin

				declare
					@fromSerialPartial int
				,	@toSerialPartial int
				,	@combineQuantity numeric(20,6)

				fetch
					partialCobines
				into
					@fromSerialPartial
				,	@toSerialPartial
				,	@combineQuantity

				if	@@FETCH_STATUS != 0 begin
					break
				end

				declare
					@breakoutSerial int

				--- <Call>
				set	@CallProcName = 'dbo.usp_InventoryControl_Breakout'
				
				execute @ProcReturn = dbo.usp_InventoryControl_Breakout
						@Operator = @User
					,	@Serial = @fromSerialPartial
					,	@QtyBreakout = @combineQuantity
					,	@ObjectCount = 1
					,	@BreakoutSerial = @breakoutSerial out
					,	@TranDT = @TranDT out
					,	@Result = @ProcResult out
				
				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
					rollback tran @ProcName
					return
				end
				--- </Call>

				--- <Call>	
				set	@CallProcName = 'dbo.usp_InventoryControl_Combine'

				execute @ProcReturn = dbo.usp_InventoryControl_Combine
						@Operator = @user
					,	@FromSerial = @breakoutSerial
					,	@ToSerial = @toSerialPartial
					,	@TranDT = @TranDT out
					,	@Result = @ProcResult out
				
				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
					rollback tran @ProcName
					return
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
					rollback tran @ProcName
					return
				end
				--- </Call>

				--- <Update rows="1">
				set	@TableName = 'FXPL.PackingJobCombines'
				
				update
					pjc
				set
					pjc.BreakoutTempSerial = @breakoutSerial
				from
					FXPL.PackingJobCombines pjc
				where
					PackingJobNumber = @PackingJobNumber
					and pjc.Status = 0
					and pjc.FromSerial = @fromSerialPartial
				
				select
					@Error = @@Error,
					@RowCount = @@Rowcount
				
				if	@Error != 0 begin
					set	@Result = 999999
					RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
					rollback tran @ProcName
					return
				end
				if	@RowCount != 1 begin
					set	@Result = 999999
					RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
					rollback tran @ProcName
					return
				end
				--- </Update>
			end
			close
				partialCobines
			deallocate
				partialCobines
				
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Mark combines as processed. */
		set @TocMsg = 'Mark combines as processed'
		if	exists
			(	select
					*
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.Status = 0
			)
		begin
			--- <Update rows="*">
			set	@TableName = 'FXPL.PackingJobCombines'
			
			update
				FXPL.PackingJobCombines
			set
				Status = 1
			from
				FXPL.PackingJobCombines pjc
			where
				pjc.PackingJobNumber = @PackingJobNumber
				and pjc.Status = 0
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			--- </Update>
				
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Close MES Job. */
		set @TocMsg = 'Close MES Job'
		begin
			declare
				@wodid int =
				(	select
						max(wod.RowID)
					from
						dbo.WorkOrderDetails wod
					where
						wod.WorkOrderNumber = @PackingJobNumber
				)
			
			--- <Call>	
			set	@CallProcName = 'dbo.usp_MES_Job_Completed'

			execute @ProcReturn = dbo.usp_MES_Job_Completed
					@WODID = @wodid
				,	@TranDT = @TranDT out
				,	@Result = @ProcResult out
			
			set	@Error = @@Error
			if	@Error != 0 begin
				set	@Result = 900501
				RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
				rollback tran @ProcName
				return
			end
			if	@ProcReturn != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
				rollback tran @ProcName
				return
			end
			if	@ProcResult != 0 begin
				set	@Result = 900502
				RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
				rollback tran @ProcName
				return
			end
			--- </Call>
			
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end

		/*	Close packing job. */
		set @TocMsg = 'Close packing job'
		begin
			--- <Update rows="1">
			set	@TableName = 'FXPL.PackingJobHeaders'
			
			update
				pjh
			set
				pjh.Status = 1
			,	pjh.ShelfInventoryFlag = @ShelfInventoryFlag
			,	pjh.JobDoneFlag = @JobDoneFlag
			,	pjh.PackingCompleteDT = @TranDT
			from
				FXPL.PackingJobHeaders pjh
			where
				pjh.PackingJobNumber = @PackingJobNumber
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error updating %s in procedure %s.  Rows Updated: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Update>
				
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
			
		/*	Return packing job. */
		set @TocMsg = 'Return packing job'
		begin
			select
				result = FXPL.udf_Q_PackingJob(@PackingJobNumber)
					
			--- <TOC>
			if	@Debug & 0x01 = 0x01 begin
				set @TocDT = getdate()
				set @TimeDiff =
					case
						when datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01')) > 1
							then convert(varchar, datediff(day, @TocDT - @TicDT, convert(datetime, '1900-01-01'))) + ' day(s) ' + convert(char(12), @TocDT - @TicDT, 114)
						else
							convert(varchar(12), @TocDT - @TicDT, 114)
					end
				set @DebugMsg = @DebugMsg + char(13) + char(10) + replicate(' -', (@Debug & 0x3E) / 2) + @TocMsg + ': ' + @TimeDiff
				set @TicDT = @TocDT
			end
			set @DebugMsg += coalesce(char(13) + char(10) + @cDebugMsg, N'')
			set @cDebugMsg = null
			--- </TOC>
		end
		--- </Body>

		---	<CloseTran AutoCommit=Yes>
		if	@TranCount = 0 begin
			commit tran @ProcName
		end
		---	</CloseTran AutoCommit=Yes>

		--- <SP End Logging>
		update
			uc
		set	EndDT = getdate()
		,	OutArguments = convert
				(	varchar(max)
				,	(	select
							[@TranDT] = @TranDT
						,	[@Result] = @Result
						,	[@DebugMsg] = @DebugMsg
						for xml raw			
					)
				)
		from
			FXSYS.USP_Calls uc
		where
			uc.RowID = @LogID
		--- </SP End Logging>

		--- <TIC/TOC END>
		if	@Debug & 0x3F = 0x01 begin
			set @DebugMsg = @DebugMsg + char(13) + char(10)
			print @DebugMsg
		end
		--- </TIC/TOC END>

		---	<Return>
		set	@Result = 0
		return
			@Result
		--- </Return>
	end try
	begin catch
		declare
			@errorSeverity int
		,	@errorState int
		,	@errorMessage nvarchar(2048)
		,	@xact_state int
	
		select
			@errorSeverity = error_severity()
		,	@errorState = error_state ()
		,	@errorMessage = error_message()
		,	@xact_state = xact_state()

		execute FXSYS.usp_PrintError

		if	@xact_state = -1 begin 
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount = 0 begin
			rollback
			execute FXSYS.usp_LogError
		end
		if	@xact_state = 1 and @TranCount > 0 begin
			rollback transaction @ProcName
			execute FXSYS.usp_LogError
		end

		raiserror(@errorMessage, @errorSeverity, @errorState)
	end catch
end

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

declare
	@User varchar(5) = 'EES'
,	@PackingJobNumber varchar(50) = 'PJ_000000060'
,	@ShelfInventoryFlag bit = 0
,	@JobDoneFlag bit = 1

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXPL.usp_CRUD_PackingJob_Complete
	@User = @User
,	@PackingJobNumber = @PackingJobNumber
,	@ShelfInventoryFlag = @ShelfInventoryFlag
,	@JobDoneFlag = @JobDoneFlag
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	FXPL.PackingJobHeaders pjh
where
	pjh.PackingJobNumber = @PackingJobNumber

select
	*
from
	dbo.WorkOrderHeaders woh
where
	WorkOrderNumber = @PackingJobNumber

select
	*
from
	dbo.WorkOrderDetails wod
where
	WorkOrderNumber = @PackingJobNumber

select
	*
from
	dbo.object o
where
	exists
		(	select
				*
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Serial = o.serial
		)

select
	*
from
	dbo.audit_trail at
where
	at.date_stamp = @TranDT
go

--commit
if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
