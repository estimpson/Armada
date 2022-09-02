SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_CRUD_CombinePreObject]
	@User varchar(5)
,	@PackingJobNumber varchar(50)
,	@CombineSerial int
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
					,	[@CombineSerial] = @CombineSerial
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
		/*	Object exists */
		if	not exists
			(	select
					*
				from
					dbo.object o
				where
					o.serial = @CombineSerial
			) begin
			raiserror ('Validation Failed: No object with serial %d was found', 16, 1, @CombineSerial)
			return
		end

		/*  Object is approved */
		if	(	select
		  			max(o.status)
		  		from
		  			dbo.object o
				where
					o.serial = @CombineSerial
		  	) != 'A' begin
			declare
				@status varchar(50) =
					(	select
							o.status + ' [' + o.user_defined_status + ']'
						from
							dbo.object o
						where
							o.serial = @CombineSerial
					)
				
			raiserror ('Validation Failed: Object with serial %d to combine is not A [Approved].  Object status is %s', 16, 1, @CombineSerial, @status)
			return
		end

		/*	Validate combine object */
		if	(	select
		  			max(o.part)
		  		from
		  			dbo.object o
				where
					o.serial = @CombineSerial
		  	) !=
			(	select
					pjh.PartCode
				from
					FXPL.PackingJobHeaders pjh
				where
					pjh.PackingJobNumber = @PackingJobNumber
			) begin
			declare
				@jobPart varchar(25) =
					(	select
							max(pjh.PartCode)
						from
							FXPL.PackingJobHeaders pjh
						where
							pjh.PackingJobNumber = @PackingJobNumber
					)
			,	@objectPart varchar(25) =
					(	select
							max(o.part)
						from
							dbo.object o
						where
							o.serial = @CombineSerial
					)

			raiserror ('Validation Failed: Object with serial %d has a part number mismatch.  Job part is %s.  Object part is %s', 16, 1, @CombineSerial, @jobPart, @objectPart)
			return
		end

		/*	Validate job has partial to combine with */
		declare
			@PartialBoxSerial int =
				(	select
						max(pjo.Serial)
					from
						FXPL.PackingJobObjects pjo
					where
						pjo.PackingJobNumber = @PackingJobNumber
						and pjo.Quantity =
							(	select
									pjh.PartialBoxQuantity
								from
									FXPL.PackingJobHeaders pjh
								where
									pjh.PackingJobNumber = @PackingJobNumber
							)
				)

		if	@PartialBoxSerial is null begin
			raiserror ('Validation Failed: Packing job doesn''t have a partial box to combine with', 16, 1)
			return
		end

		/*	Validate not already combined with any other job */
		if	exists
			(	select
					*
				from
					FXPL.PackingJobCombines pjc
				where
					pjc.FromSerial = @CombineSerial
					and pjc.Status = 0
			) begin
			raiserror ('Validation Failed: Object with serial %d has a pending combine.', 16, 1, @CombineSerial)
			return
		end
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
		/*	Record combine. */
		set @TocMsg = 'Record combine'
		begin
			declare
				@FromOriginalQuantity numeric(20,6) =
					(	select
							o.std_quantity
						from
							dbo.object o
						where
							o.serial = @CombineSerial
					)

			declare
				@ToOriginalQuantity numeric(20,6) =
					coalesce
					(	(	select top (1)
					 			pjc.ToNewQuantity
					 		from
					 			FXPL.PackingJobCombines pjc
							where
								pjc.PackingJobNumber = @PackingJobNumber
								and pjc.ToSerial = @PartialBoxSerial
								and pjc.Status = 0
							order by
								pjc.RowCreateDT desc
					 	)
					,	(	select
					 			pjo.Quantity
					 		from
					 			FXPL.PackingJobObjects pjo
							where
								pjo.PackingJobNumber = @PackingJobNumber
								and pjo.Serial = @PartialBoxSerial
								and pjo.Status = 0
					 	)
					)
			
			declare
				@StandardPack numeric(20,6) =
					(	select
							pjh.StandardPack
						from
							FXPL.PackingJobHeaders pjh
						where
							pjh.PackingJobNumber = @PackingJobNumber
					)

			declare
				@FromNewQuantity numeric(20,6)
			,	@ToNewQuantity numeric(20,6)

			if	@StandardPack - @ToOriginalQuantity > @FromOriginalQuantity begin
				set @FromNewQuantity = 0
				set @ToNewQuantity = @ToOriginalQuantity + @FromOriginalQuantity
			end
			else begin
				set @FromNewQuantity = @FromOriginalQuantity - (@StandardPack - @ToOriginalQuantity)
				set @ToNewQuantity = @StandardPack
			end

			--- <Insert rows="1">
			set	@TableName = 'FXPL.PackingJobCombines'
			
			insert
				FXPL.PackingJobCombines
			(	PackingJobNumber
			,	FromSerial
			,	FromOriginalQuantity
			,	FromNewQuantity
			,	FromReprint
			,	ToSerial
			,	ToOriginalQuantity
			,	ToNewQuantity
			)
			values
			(	@PackingJobNumber
			,	@CombineSerial
			,	@FromOriginalQuantity
			,	@FromNewQuantity
			,	0
			,	@PartialBoxSerial
			,	@ToOriginalQuantity
			,	@ToNewQuantity
			)
			
			select
				@Error = @@Error,
				@RowCount = @@Rowcount
			
			if	@Error != 0 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
				rollback tran @ProcName
				return
			end
			if	@RowCount != 1 begin
				set	@Result = 999999
				RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: 1.', 16, 1, @TableName, @ProcName, @RowCount)
				rollback tran @ProcName
				return
			end
			--- </Insert>
				
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

		/*	Force reprint for the target. */
		set @TocMsg = 'Force reprint for the target'
		begin
			--- <Update rows="1">
			set	@TableName = 'FXPL.PackingJobObjects'
			
			update
				pjo
			set
				pjo.Printed = 0
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status = 0
				and pjo.Serial = @PartialBoxSerial
			
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
,	@PackingJobNumber varchar(50) = 'PJ_000000038'
,	@CombineSerial int = 12345

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXPL.usp_CRUD_CombinePreObject
	@User = @User
,	@PackingJobNumber = @PackingJobNumber
,	@CombineSerial = @CombineSerial
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
