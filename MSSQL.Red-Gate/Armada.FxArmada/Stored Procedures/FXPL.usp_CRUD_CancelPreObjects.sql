SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_CRUD_CancelPreObjects]
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
		/*	Cancel pre-objects. */
		set @TocMsg = 'Cancel pre-objects'
		begin
			declare
				PreObjects
			cursor local for
				select
					pjo.Serial
				from
					FXPL.PackingJobObjects pjo
				where
					pjo.PackingJobNumber = @PackingJobNumber
					and pjo.Status = 0

			open
				PreObjects

			while
				1 = 1 begin
				declare
					@PreObjectSerial int
				
				fetch
					PreObjects
				into
					@PreObjectSerial
				
				if	@@FETCH_STATUS != 0 break

				--- <Call>	
				set	@CallProcName = 'dbo.usp_MES_CancelPreObject'
			
				execute @ProcReturn = dbo.usp_MES_CancelPreObject
						@Operator = @User
					,	@PreObjectSerial = @PreObjectSerial
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
			end

			close
				PreObjects
			deallocate
				PreObjects
			
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
		

		/*	Record the removal of package job inventory in header. */
		set @TocMsg = 'Record the packing job inventory in header'
		begin
			--- <Update rows="1">
			set	@TableName = 'FXPL.PackingJobHeaders'
			
			update
				pjh
			set
				pjh.CompleteBoxes = null
			,	pjh.PartialBoxQuantity = null
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

		/*	Cancel any combines. */
		set @TocMsg = 'Cancel any combines'
		begin
			if	exists
				(	select
						*
					from
						FXPL.PackingJobCombines pjc
					where
						pjc.PackingJobNumber = @PackingJobNumber
						and pjc.Status = 0
				) begin

				--- <Update rows="1+">
				set	@TableName = 'FXPL.PackingJobCombines'
				
				update
					pjc
				set
					pjc.Status = -1
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
				if	@RowCount <= 0 begin
					set	@Result = 999999
					RAISERROR ('Error updating into %s in procedure %s.  Rows Updated: %d.  Expected rows: 1 or more.', 16, 1, @TableName, @ProcName, @RowCount)
					rollback tran @ProcName
					return
				end
				--- </Update>
			end
				
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

		/*	Cancel packing job objects. */
		set @TocMsg = 'Cancel packing job objects'
		begin
			--- <Update rows="1+">
			set	@TableName = 'FXPL.PackingJobObjects'
			
			update
				pjo
			set
				pjo.Status = -1
			from
				FXPL.PackingJobObjects pjo
			where
				pjo.PackingJobNumber = @PackingJobNumber
				and pjo.Status = 0
			
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
,	@PartCode varchar(25) = '10047'
,	@PackagingCode varchar(25) = 'B-18X12X12'
,	@SpecialInstructions varchar(max) = null
,	@PieceWeightQuantity numeric(20,6) = 1
,	@PieceWeight numeric(20,6) = 0.0048
,	@PieceWeightTolerance numeric(20,6) = 0.03
,	@PieceWeightValid bit = 1
,	@PieceWeightDiscrepancyNote varchar(max) = null
,	@DeflashOperator varchar(25) = 'DF'
,	@DeflashMachine varchar(25) = 'SB11'
,	@PackingJobNumber varchar(50) = null

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = FXPL.usp_CRUD_CancelPreObjects
	@User = @User
,	@PartCode = @PartCode
,	@PackagingCode = @PackagingCode
,	@SpecialInstructions = @SpecialInstructions
,	@PieceWeightQuantity = @PieceWeightQuantity
,	@PieceWeight = @PieceWeight
,	@PieceWeightTolerance = @PieceWeightTolerance
,	@PieceWeightValid = @PieceWeightValid
,	@PieceWeightDiscrepancyNote = @PieceWeightDiscrepancyNote
,	@DeflashOperator = @DeflashOperator
,	@DeflashMachine = @DeflashMachine
,	@PackingJobNumber = @PackingJobNumber out
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@PackingJobNumber, @Error, @ProcReturn, @TranDT, @ProcResult

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
	dbo.WorkOrderDetailBillOfMaterials wodbom
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
