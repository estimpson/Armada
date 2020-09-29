SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_MES_BFHist_PreviewFix]
	@BackflushNumber varchar(50)
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
		dbo.fn_MES_GetJobBackflushDetails(@workOrderNumber, @workorderDetailLine, @qtyRequested) ugbd
	where
		ugbd.Part = @PartCodeNew
		and ugbd.QtyIssue > 0

	declare
		@replacementLine int

	select
		@replacementLine = min(bd.Line)
	from
		dbo.BackflushDetails bd
	where
		bd.BackflushNumber = @BackflushNumber
		and bd.PartConsumed = @PartCodeOld

	select
		bd.BackflushNumber
	,   bd.Line
	,   Status = case when bd.PartConsumed = @PartCodeOld then -1 else bd.Status end
	,   bd.Type
	,   bd.ChildPartSequence
	,   bd.ChildPartBOMLevel
	,   bd.BillOfMaterialID
	,   bd.PartConsumed
	,   bd.SerialConsumed
	,   bd.QtyAvailable
	,   bd.QtyRequired
	,   bd.QtyIssue
	,   bd.QtyOverage
	,   Notes = coalesce(bd.Notes, '') + 'Consumption replaced after BOM change.'
	from
		dbo.BackflushDetails bd
	where
		bd.BackflushNumber = @BackflushNumber
	union all
	select
		BackflushNumber = @BackflushNumber
	,	Line = @replacementLine + row_number() over (order by ic.Sequence, ic.AllocationDT) * .1
	,	Status = dbo.udf_StatusValue('dbo.BackflushDetails', 'New')
	,	Type =
			case
				when ic.QtyOverage > 0 then dbo.udf_TypeValue('dbo.BackflushDetails', 'Overage Consumption')
				else dbo.udf_TypeValue('dbo.BackflushDetails', 'Consumption')
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
	,   Notes = 'Consumption corrected by BOM change.'
	from
		@InventoryConsumption ic
	order by
		2
	,	9
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
	@BackflushNumber varchar(50)
,	@PartCodeOld varchar(25)
,	@PartCodeNew varchar(25)

set	@BackflushNumber = 'BF_0000019866'
set @PartCodeOld = 'CH5280-30'
set @PartCodeNew = 'CH5280-20'

begin transaction Test

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_MES_BFHist_SetPartTempWIP
	@PartCode = @PartCodeOld
,	@JobID = null
,	@TranDT = @TranDT out
,	@Result = @ProcResult out

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult

execute
	@ProcReturn = dbo.usp_MES_BFHist_PreviewFix
	@BackflushNumber = @BackflushNumber
,	@PartCodeOld = @PartCodeOld
,	@PartCodeNew = @PartCodeNew
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
