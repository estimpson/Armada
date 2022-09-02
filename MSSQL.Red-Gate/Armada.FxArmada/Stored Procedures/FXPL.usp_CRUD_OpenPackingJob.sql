SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [FXPL].[usp_CRUD_OpenPackingJob]
	@User varchar(5)
,	@PartCode varchar(25)
,	@PackagingCode varchar(25)
,	@StandardPack numeric(20,6)
,	@SpecialInstructions varchar(max)
,	@PieceWeightQuantity numeric(20,6)
,	@PieceWeight numeric(20,6)
,	@PieceWeightTolerance numeric(20,6)
,	@PieceWeightValid bit
,	@PieceWeightDiscrepancyNote varchar(max)
,	@DeflashOperator varchar(25)
,	@DeflashMachine varchar(25)
,	@PackingJobNumber varchar(50) = null out
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

		set @DebugMsg = replicate(' -', (@Debug & 0x3E) / 2) + 'Start ' + schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)
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
		USP_Name = schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)
	,	BeginDT = getdate()
	,	InArguments = convert
			(	varchar(max)
			,	(	select
						[@User] = @User
					,	[@PartCode] = @PartCode
					,	[@PackagingCode] = @PackagingCode
					,	[@StandardPack] = @StandardPack
					,	[@SpecialInstructions] = @SpecialInstructions
					,	[@PieceWeightQuantity] = @PieceWeightQuantity
					,	[@PieceWeight] = @PieceWeight
					,	[@PieceWeightTolerance] = @PieceWeightTolerance
					,	[@PieceWeightValid] = @PieceWeightValid
					,	[@PieceWeightDiscrepancyNote] = @PieceWeightDiscrepancyNote
					,	[@DeflashOperator] = @DeflashOperator
					,	[@DeflashMachine] = @DeflashMachine
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

	set	@ProcName = schema_name(objectproperty(@@procid, 'SchemaId')) + '.' + object_name(@@procid)  -- e.g. FXPL.usp_Test
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
		/*	Create Packing Job Header. */
		set @TocMsg = 'Create Packing Job Header'
		begin
			--- <Insert rows="1">
			declare
				@Inserted table
			(	RowID int
			)

			set	@TableName = 'FXPL.PackingJobHeaders'
			
			insert
				FXPL.PackingJobHeaders
			(	PartCode
			,	PackagingCode
			,	StandardPack
			,	SpecialInstructions
			,	PieceWeightQuantity
			,	PieceWeight
			,	PieceWeightTolerance
			,	PieceWeightValid
			,	PieceWeightDiscrepancyNote
			,	DeflashOperator
			,	DeflashMachine
			,	PackingOperator
			)
			output
				Inserted.RowID
			into
				@Inserted
			select
				PartCode = @PartCode
			,	PackagingCode = @PackagingCode
			,	StandardPack = @StandardPack
			,	SpecialInstructions = @SpecialInstructions
			,	PieceWeightQuantity = @PieceWeightQuantity
			,	PieceWeight = @PieceWeight
			,	PieceWeightTolerance = @PieceWeightTolerance
			,	PieceWeightValid = @PieceWeightValid
			,	PieceWeightDiscrepancyNote = @PieceWeightDiscrepancyNote
			,	DeflashOperator = @DeflashOperator
			,	DeflashMachine = @DeflashMachine
			,	PackingOperator = @User
			
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

			set	@PackingJobNumber =
				(	select top(1)
						pjh.PackingJobNumber
					from
						@Inserted i
						join FXPL.PackingJobHeaders pjh on
							pjh.RowID = i.RowID
					order by
						i.RowID
				)
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

		/*	Schedule job. */
		set @TocMsg = 'Schedule job'
		begin
			--- <Call>	
			set	@CallProcName = 'dbo.usp_Scheduling_ScheduleJob'

			execute @ProcReturn = dbo.usp_Scheduling_ScheduleJob
				@WorkOrderNumber = @PackingJobNumber out
			,	@Operator = @User
			,	@MachineCode = 'Packing'
			,	@ToolCode = null
			,	@ProcessCode = null
			,	@PartCode = @PartCode
			,	@NewFirmQty = 0
			,	@DueDT = null
			,	@TopPart = @PartCode
			,	@SalesOrderNo = null
			,	@ShipToCode = null
			,	@BillToCode = null
			,	@TranDT = @TranDT out
			,	@Result = @Result out
				
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
							[@PackingJobNumber] = @PackingJobNumber
						,	[@TranDT] = @TranDT
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
,	@PartCode varchar(25) = '10370'
,	@PackagingCode varchar(25) = 'B-11.75X11X9'
,	@StandardPack numeric(20,6) = 70000
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
	@ProcReturn = FXPL.usp_CRUD_OpenPackingJob
	@User = @User
,	@PartCode = @PartCode
,	@PackagingCode = @PackagingCode
,	@StandardPack = @StandardPack
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
