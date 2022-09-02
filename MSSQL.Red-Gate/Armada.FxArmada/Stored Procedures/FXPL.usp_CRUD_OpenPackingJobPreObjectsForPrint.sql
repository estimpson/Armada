SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_CRUD_OpenPackingJobPreObjectsForPrint]
	@User varchar(5)
,	@PackingJobNumber varchar(50)
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
		/*	Set open status. */
		set @TocMsg = 'Set open status'
		begin
			--- <Update rows="1+">
			set	@TableName = 'FXPL.PackingJobObjects'
			
			update
				pjo
			set
				Status = 1
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

		/*	Open pre-objecst. */
		set @TocMsg = 'Open pre-objects'
		begin

			declare
				preObjects cursor local for
			select
				pjo.Serial
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status >= 0

			open
				preObjects

			while
				1 = 1 begin

				declare
					@serial int

				fetch
					preObjects
				into
					@serial

				if	@@FETCH_STATUS != 0 break;

				--- <Call>	
				set	@CallProcName = 'dbo.usp_MES_OpenPreObject'

				execute @ProcReturn = dbo.usp_MES_OpenPreObject
						@Operator = @User
					,	@PreObjectSerial = @Serial
					,	@TranDT = @TranDT out
					,	@Result = @ProcResult out
			
				set	@Error = @@Error
				if	@Error != 0 begin
					set	@Result = 900501
					RAISERROR ('Error encountered in %s.  Error: %d while calling %s', 16, 1, @ProcName, @Error, @CallProcName)
					rollback tran @ProcName
					return	@Result
				end
				if	@ProcReturn != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcReturn: %d while calling %s', 16, 1, @ProcName, @ProcReturn, @CallProcName)
					rollback tran @ProcName
					return	@Result
				end
				if	@ProcResult != 0 begin
					set	@Result = 900502
					RAISERROR ('Error encountered in %s.  ProcResult: %d while calling %s', 16, 1, @ProcName, @ProcResult, @CallProcName)
					rollback tran @ProcName
					return	@Result
				end
				--- </Call>

				/*	If there are combines for this pre-object, update the object quantity. */
				set @TocMsg = 'If there are combines for this pre-object, update the object quantity'
				declare @quantityAfterCombine numeric(20,6) =
					(	select
							max(pjc.ToNewQuantity)
						from
							FXPL.PackingJobCombines pjc
						where
							pjc.PackingJobNumber = @PackingJobNumber
							and pjc.Status >= 0
							and pjc.ToSerial = @serial
					)
				if	@quantityAfterCombine > 0
				begin
					--- <Update rows="1">
					set	@TableName = 'dbo.object o'
					
					update
						o
					set
						o.quantity = @quantityAfterCombine
					,	o.std_quantity = @quantityAfterCombine
					from
						dbo.object o
					where
						o.serial = @serial
					
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
		
		/*	Temporarily adjust the quantity on any combined partials that have remaining inventory. */
		set @TocMsg = 'Temporarily adjust the quantity on any combined partials that have remaining inventory'
		if	exists
			(	select
					*
				from
					FXPL.PackingJobCombines pjc
					join dbo.object o
						on o.serial = pjc.FromSerial
						and o.quantity = pjc.FromOriginalQuantity
				where
					pjc.PackingJobNumber = @PackingJobNumber
					and pjc.Status >= 0
					and pjc.FromNewQuantity > 0
					and pjc.FromNewQuantity != pjc.FromOriginalQuantity
			)
		begin
			--- <Update rows="1">
			set	@TableName = 'dbo.object'
			
			update
				o
			set
				o.quantity = pjc.FromNewQuantity
			,	o.std_quantity = pjc.FromNewQuantity
			from
				FXPL.PackingJobCombines pjc
				join dbo.object o
					on o.serial = pjc.FromSerial
			where
				pjc.PackingJobNumber = @PackingJobNumber
				and pjc.Status >= 0
				and pjc.FromNewQuantity > 0
				and pjc.FromNewQuantity != pjc.FromOriginalQuantity
			
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

		/*	Return packing job objects for print. */
		set @TocMsg = 'Return packing job objects for print'
		begin
			select
				result =
					coalesce
						(	(	select
						 	 		*
						 	 	from
						 	 		(	select
											pjo.PackingJobNumber
										,	pjo.Serial
										,	pjo.Quantity
										,	pjo.Printed
										,	labelInfo.LabelPath
										,	labelInfo.Copies
										,	pjo.RowID
										,	Combines = (	select
								 					pjc.PackingJobNumber
												,	pjc.FromSerial
												,	pjc.FromOriginalQuantity
												,	pjc.FromNewQuantity
												,	pjc.FromReprint
												,	pjc.ToSerial
												,	pjc.ToOriginalQuantity
												,	pjc.ToNewQuantity
												,	pjc.RowID
								 				from
								 					FXPL.PackingJobCombines pjc
												where
													pjc.PackingJobNumber= pjo.PackingJobNumber
													and pjc.Status >= 0
													and pjc.ToSerial = pjo.Serial
												for xml raw ('Combines'), type
								 			)
										from
											FXPL.PackingJobObjects pjo
											join dbo.object o on
												o.serial = pjo.Serial
											outer apply
												(	select
 														bl.LabelPath
													,	Copies = convert(int, rl.copies)
 													from
 														dbo.part_inventory pInv
														join dbo.report_library rl
															on rl.name = pInv.label_format
														join dbo.BartenderLabels bl
															on bl.LabelFormat = pInv.label_format
													where
														pInv.part = o.part
 												) labelInfo
										where
											pjo.PackingJobNumber = @PackingJobNumber
											and pjo.Status >= 0
								
										union all

										select
											pjo.PackingJobNumber
										,	Serial = pjc.FromSerial
										,	Quantity = pjc.FromNewQuantity
										,	Printed = pjc.FromReprint
										,	labelInfo.LabelPath
										,	labelInfo.Copies
										,	pjc.RowID
										,	null
										from
											FXPL.PackingJobObjects pjo
											join FXPL.PackingJobCombines pjc
												on pjc.PackingJobNumber= pjo.PackingJobNumber
												and pjc.Status >= 0
												and pjc.ToSerial = pjo.Serial
												and pjc.FromNewQuantity > 0
											left join dbo.object o on
												o.serial = pjc.FromSerial
											outer apply
												(	select
 														bl.LabelPath
													,	Copies = convert(int, rl.copies)
 													from
 														dbo.part_inventory pInv
														join dbo.report_library rl
															on rl.name = pInv.label_format
														join dbo.BartenderLabels bl
															on bl.LabelFormat = pInv.label_format
													where
														pInv.part = o.part
 												) labelInfo
										where
											pjo.PackingJobNumber = @PackingJobNumber
											and pjo.Status >= 0
									) x for xml raw('PackingJobObjectForPrint')
							)
						,	convert(xml, '')
						)
					
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
,	@PackingJobNumber varchar(50) = 'PJ_000000035'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXPL.usp_CRUD_OpenPackingJobPreObjectsForPrint
	@User = @User
,	@PackingJobNumber = @PackingJobNumber
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

go

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
