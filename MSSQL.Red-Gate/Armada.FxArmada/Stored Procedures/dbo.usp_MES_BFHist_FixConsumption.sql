SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_MES_BFHist_FixConsumption]
	@Operator varchar(5)
,	@BackflushNumber varchar(50)
,	@PartCodeOld varchar(25)
,	@PartCodeNew varchar(25)
,	@TranDT datetime = null out
,	@Result integer = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
	declare
		@workOrderNumber varchar(50)
	,	@workorderDetailLine float
	,	@qtyRequested numeric(20,6)
	
	select
		@workOrderNumber = bh.WorkOrderNumber
	,   @workorderDetailLine = bh.WorkOrderDetailLine
	,   @qtyRequested = bh.QtyProduced
	from
		dbo.BackflushHeaders bh
	where
		bh.BackflushNumber = @BackflushNumber


	/*	Get the amount of overage. */
	declare
		@QtyOverageJCUnit numeric(20,6)

	select
		@QtyOverageJCUnit = sum(bd.QtyOverage / bd.QtyRequired) * @qtyRequested
	from
		dbo.BackflushDetails bd
	where
		bd.BackflushNumber = @BackflushNumber
		and bd.PartConsumed = @PartCodeOld
		and bd.Status = 0 --(select dbo.udf_StatusValue('dbo.BackflushDetails', 'New'))

	/*	Calculate the consumption for the overage amount. */
	declare
		@InventoryConsumption table
		(	Serial int
		,	Part varchar(25)
		,	BackflushingPrinciple int
		,	BOMStatus int
		,	BOMLevel tinyint
		,	Sequence tinyint
		,	Suffix int
		,	AllocationDT datetime
		,	BillOfMaterialID int
		,	QtyOriginal float
		,	QtyAvailable float
		,	QtyPer int
		,	QtyIssue float default 0
		,	QtyOverage float default 0
		,	QtyRequired float
		,	PriorAccum float
		,	Concurrence tinyint
		,	LastAllocation tinyint
		)

	delete
		@InventoryConsumption

	insert
		@InventoryConsumption
	(	Serial
	,	Part
	,	BackflushingPrinciple
	,	BOMStatus
	,	BOMLevel
	,	Sequence
	,	Suffix
	,	AllocationDT
	,	BillOfMaterialID
	,	QtyOriginal
	,	QtyAvailable
	,	QtyPer
	,	QtyIssue
	,	QtyOverage
	,	QtyRequired
	,	PriorAccum
	,	Concurrence
	,	LastAllocation
	)
	select
		Serial
	,	Part
	,	BackflushingPrinciple
	,	BOMStatus
	,	BOMLevel
	,	Sequence
	,	Suffix
	,	AllocationDT
	,	BillOfMaterialID
	,	QtyOriginal
	,	QtyAvailable
	,	QtyPer
	,	QtyIssue
	,	QtyOverage
	,	QtyRequired
	,	PriorAccum
	,	Concurrence
	,	LastAllocation
	from
		dbo.fn_MES_GetJobBackflushDetails(@workOrderNumber, @workorderDetailLine, @QtyOverageJCUnit) ugbd
	where
		ugbd.Part = @PartCodeNew
		and ugbd.QtyIssue > 0

	declare
		@fixLine float

	select
		@fixLine = min(bd.Line)
	from
		dbo.BackflushDetails bd
	where
		bd.BackflushNumber = @BackflushNumber
		and bd.PartConsumed = @PartCodeOld
		and bd.Status = 0
		and bd.QtyOverage > 0

	--- <Update rows="*">
	set	@TableName = 'dbo.BackflushDetails'
	
	/*	Loop through material issues. */
	--- <DefineCursor curosrName="materialIssues">
	declare
		@issueSerial int
	,	@qtyIssue numeric(20,6)

	declare materialIssues cursor local for
	select
		Serial
	,	QtyIssue = sum(QtyIssue)
	from
		@InventoryConsumption ic
	where
		ic.Serial > 0
		and ic.QtyIssue > 0
		and ic.Part = @PartCodeNew
	group by
		Serial

	open
		materialIssues

	fetch
		materialIssues
	into
		@issueSerial
	,	@qtyIssue

	while
		@@fetch_status = 0 begin

		--- <LoopBody>

	/*		Write material issues. (dbo.usp_InventoryControl_MaterialIssue).*/
		--- <Call procName"dbo.usp_InventoryControl_MaterialIssue" >	
		set	@CallProcName = 'dbo.usp_InventoryControl_MaterialIssue'
		execute
			@ProcReturn = dbo.usp_InventoryControl_MaterialIssue
			@Operator = @Operator
		,	@Serial = @issueSerial
		,	@QtyIssue = @qtyIssue
		,	@WorkOrderNumber = @workOrderNumber
		,	@Notes = 'Material issue by backflush.'
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
	
		--- </LoopBody>
		fetch
			materialIssues
		into
			@issueSerial
		,	@qtyIssue
	end

	close
		materialIssues

	deallocate
		materialIssues
	--- </DefineCursor>

	--- <Update rows="*">
	set	@TableName = 'dbo.BackflushDetails'
	
	update
		bd
	set
		Type = 1 --(select dbo.udf_TypeValue('dbo.BackflushDetails', 'Consumption'))
	,	QtyOverage = 0
	,	Notes = coalesce(bd.Notes + '.  ', '') + convert(varchar, QtyOverage) + ' overage corrected.'
	,	RowModifiedDT = @TranDT
	from
		dbo.BackflushDetails bd
	where
		bd.BackflushNumber = @BackflushNumber
		and bd.Line = @fixLine
	
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

	/*	Write new backflush details. */
	--- <Insert rows="*">
	set	@TableName = 'dbo.BackflushDetails'
	
	insert
		dbo.BackflushDetails
	(	BackflushNumber
	,	Line
	,	Status
	,	Type
	,	ChildPartSequence
	,	ChildPartBOMLevel
	,	BillOfMaterialID
	,	PartConsumed
	,	SerialConsumed
	,	QtyAvailable
	,	QtyRequired
	,	QtyIssue
	,	QtyOverage
	,	Notes
	,	RowCreateDT
	,	RowModifiedDT
	)
	select
		BackflushNumber = @BackflushNumber
	,	Line = @fixLine + row_number() over (order by ic.Sequence, ic.AllocationDT) * .1
	,	Status = 0 --(select dbo.udf_StatusValue('dbo.BackflushDetails', 'New'))
	,	Type =
			case
				when ic.QtyOverage > 0 then 2 --(select dbo.udf_TypeValue('dbo.BackflushDetails', 'Overage Consumption'))
				else 1 --(select dbo.udf_TypeValue('dbo.BackflushDetails', 'Consumption'))
			end
	,	ChildPartSequence = ic.Sequence
	,	ChildPartBOMLevel = ic.BOMLevel
	,	BillOfMaterialID = ic.BillOfMaterialID
	,	PartConsumed = ic.Part
	,	SerialConsumed = ic.Serial
	,	QtyAvailable = ic.QtyAvailable
	,	QtyRequired = ic.QtyRequired
	,	QtyIssue = ic.QtyIssue
	,	QtyOverage = ic.QtyOverage
	,   Notes = 'Corrected overage consumption.'
	,	RowCreateDT = @TranDT
	,	RowModifiedDT = @TranDT
	from
		@InventoryConsumption ic
	where
		ic.Part = @PartCodeNew
	order by
		2
	,	9

	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
return
	@Result
--- </Return>

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
	@Operator varchar(5)
,	@BackflushNumber varchar(50)
,	@PartCodeOld varchar(25)
,	@PartCodeNew varchar(25)

set @Operator = 'EES'
set	@BackflushNumber = 'BF_0000040223'
set @PartCodeOld = 'VW0020-05'
set @PartCodeNew = 'VW0020-05'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_BFHist_FixConsumption
	@Operator = @Operator
,	@BackflushNumber = @BackflushNumber
,	@PartCodeOld = @PartCodeOld
,	@PartCodeNew = @PartCodeNew
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

select
	*
from
	dbo.BackflushDetails bd
where
	bd.BackflushNumber = @BackflushNumber
order by
	bd.Line

select
	*
from
	dbo.audit_trail at
where
	at.date_stamp = @TranDT
go

--	commit
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
