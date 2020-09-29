SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_ReceivingDock_CreateReceiverLines_fromRMAReceiverHeader]
	@ReceiverID int,
	@Result int output
as
/*

begin tran Test
declare
	@ReceiverID int

set @ReceiverID = 1

execute	usp_ReceivingDock_CreateReceiverLines_fromPOReceiverHeader
	@ReceiverID = @ReceiverID,
	@Result = 0
	
select	*
from	ReceiverLines

select	ReceiverLineID,
	ReceiverID,
	LineNo,
	PartCode,
	PONumber,
	POLineNo,
	POLineDueDate,
	PackageType,
	RemainingBoxes,
	StdPackQty,
	TotalReceiveQty = convert (numeric(20,6), null),
	TotalOnOrderQty =
	(	select	balance
		from	dbo.po_detail po_detail
		where	po_detail.part_number = ReceiverLines.PartCode and
			po_detail.po_number = ReceiverLines.PONumber and
			po_detail.row_id = ReceiverLines.POLineNo and
			po_detail.date_due = ReceiverLines.POLineDueDate),
	SupplierLotNumber,
	ArrivalDT
from	dbo.ReceiverLines ReceiverLines
where	ReceiverID = @ReceiverID

select	ro.*
from	dbo.ReceiverObjects ro
	join dbo.ReceiverLines rl on ro.ReceiverLineID = rl.ReceiverLineID
where	rl.ReceiverID = @ReceiverID

--commit
rollback tran


*/
set ansi_warnings off
set nocount on
set	@Result = 999999

--- <ErrorHandling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty (@@procid, 'OwnerId')) + '.' + object_name (@@procid)  -- e.g. dbo.usp_Test
--- </ErrorHandling>

--- <Tran required=Yes autoCreate=Yes tranDTParm=No>
declare	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
save tran @ProcName
declare
	@TranDT datetime
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

--	Argument transformations:
--		Supplier, expected / actual receive DT.
declare
	@ShipFrom varchar (10)
,	@ReceiveDT datetime

select
	@ShipFrom = rh.ShipFrom
,	@ReceiveDT = coalesce(rh.ReceiveDT, rh.ActualArrivalDT, rh.ConfirmedArrivalDT, rh.ExpectedReceiveDT)
from
	dbo.ReceiverHeaders rh
where
	rh.ReceiverID = @ReceiverID

if	@ReceiveDT is null begin
	rollback tran @ProcName
	set	@Result = 1000004
	raiserror ('Unable to create lines for Receiver %d.  Please set the expected arrival date.', 16, 1, @ReceiverID)
	return @Result
end

--	Calculate new receiver lines...
--		Find open RMAs
declare
	@Requirements table
(	ReceiverID int
,	RMA_ID integer
,	RMA_LineID integer
,	PartCode varchar(25)
,	Quantity numeric(20,6)
,	PackageType varchar(20)
,	StdPackQty numeric(20,6)
,	Reason varchar(254)
)

--- <Insert>
set	@TableName = '@Requirements'

insert
	@Requirements
(	ReceiverID
,	RMA_ID
,	RMA_LineID
,	PartCode
,	Quantity
,	PackageType
,	StdPackQty
,	Reason
)
select
	ReceiverID = @ReceiverID,
	RMA_ID = sRMA.id
,	RMA_LineID = suffix
,	PartCode = sdRMALines.part_original
,	Quantity = -(sdRMALines.qty_required - sdRMALines.qty_packed)
,	PackageType = coalesce(ohBlanket.package_type, ppAlt.code)
,	StdPackQty = coalesce(pp.quantity, pc.customer_standard_pack, pInv.standard_pack)
,	Reason = sdRMALines.note
from
	dbo.shipper sRMA
	join dbo.shipper_detail sdRMALines
		on sdRMALines.shipper = sRMA.id
		and -(sdRMALines.qty_required - sdRMALines.qty_packed) > 0
	left join dbo.order_header ohBlanket
		join dbo.part_packaging pp
			on pp.part = ohBlanket.blanket_part
			and pp.code = ohBlanket.package_type
		on ohBlanket.order_no = sdRMALines.order_no
		and ohBlanket.blanket_part = sdRMALines.part_original
	left join dbo.part_customer pc
		on pc.customer = sRMA.customer
		and pc.part = sdRMALines.part_original
	join dbo.part_inventory pInv
		on pInv.part = sdRMALines.part_original
	left join dbo.part_packaging ppAlt
		on ppAlt.part = sdRMALines.part_original
		and ppalt.code =
		(	select
				min(code)
			from
				dbo.part_packaging
			where
				part = sdRMALines.part_original
				and quantity = coalesce(pp.quantity, pc.customer_standard_pack, pInv.standard_pack)
		)
where
	sRMA.type = 'R'
	and sRMA.status = 'O'
	and sRMA.destination = @ShipFrom

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Insert>

--		Load to temp table to generate line no's.
--- <Insert>
set	@TableName = '#ReceiverLines'

select
	ReceiverID
,	[LineNo] = identity(int, 1, 1)
,	RMA_ID
,	RMA_LineID
,	PartCode
,	PackageType
,	Quantity
,	Boxes
,	StdPackQty
,	Reason
into
	#ReceiverLines
from
	(	select
			r.ReceiverID
		,	r.RMA_ID
		,	r.RMA_LineID
		,	r.PartCode
		,	PackageType = null --min(r.PackageType)
		,	Quantity = sum(r.Quantity)
		,	Boxes = 1 --ceiling(sum(r.Quantity) / min(r.StdPackQty))
		,	StdPackQty = sum(r.Quantity) --min(r.StdPackQty)
		,	Reason = min(r.Reason)
		from
			@Requirements r
		group by
			r.ReceiverID
		,	r.RMA_ID
		,	r.RMA_LineID
		,	r.PartCode
		having
			ceiling(sum(r.Quantity) / min(r.StdPackQty)) > 0
	) Requirements
order by
	PartCode
,	RMA_ID
,	Boxes desc

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Insert>

--	Recalculate Receiver Objects and Receiver Lines.
--		Remove old receiver objects (not yet received against).
--- <Delete>
set	@TableName = 'dbo.ReceiverObjects'

delete
	dbo.ReceiverObjects
from
	dbo.ReceiverObjects rlo
		join dbo.ReceiverLines rl on
			rlo.ReceiverLineID = rl.ReceiverLineID
		and rl.ReceiverID = @ReceiverID
where
	 rlo.Status = 0	

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Delete>

--		Remove old receiver line (not yet received against).
--- <Delete>
set	@TableName = 'dbo.ReceiverLines'

delete
	dbo.ReceiverLines
from
	dbo.ReceiverLines rl
where
	ReceiverID = @ReceiverID
	and not exists
		(	select
				*
			from
				dbo.ReceiverObjects ro
			where
				ReceiverLineID = rl.ReceiverLineID
		)

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Delete>

--		Set quantity remaining on lines that have been partially received.
--- <Update>
set	@TableName = 'dbo.part_vendor'

update
	dbo.ReceiverLines
set
	RemainingBoxes = rl2.Boxes
,	StdPackQty = rl2.StdPackQty
,	[LineNo] =
		(	select
				count(1)
			from
				dbo.ReceiverLines
			where
				ReceiverID = @ReceiverID
				and [LineNo] <= rl.[LineNo]
		)
from
	dbo.ReceiverLines rl
	join #ReceiverLines rl2 on
		rl.PartCode = rl2.PartCode
		and	rl.PONumber = rl2.RMA_ID
		and	rl.POLineNo = rl2.RMA_LineID
where
	rl.ReceiverID = @ReceiverID

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Update>

--		Create new receiver lines.
--- <Insert>
set	@TableName = 'dbo.ReceiverLines'

insert
	dbo.ReceiverLines
(	ReceiverID,
	[LineNo],
	PartCode,
	PONumber,
	POLineNo,
	PackageType,
	RemainingBoxes,
	StdPackQty)
select
	rl.ReceiverID
,	rl.[LineNo] + coalesce
		(	(	select
					max([LineNo])
				from
					dbo.ReceiverLines
				where
					ReceiverID = @ReceiverID
			)
		,	0
		)
,	rl.PartCode
,	rl.RMA_ID
,	rl.RMA_LineID
,	rl.PackageType
,	rl.Boxes
,	rl.StdPackQty
from
	#ReceiverLines rl
where
	not exists
		(	select
				*
			from
				dbo.ReceiverLines rl2
			where
				rl.ReceiverID = rl2.ReceiverID
				and rl.PartCode = rl2.PartCode
				and rl.RMA_ID = rl2.PONumber
				and rl.RMA_LineID = rl2.POLineNo
		)

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Insert>

--		Create new receiver objects.
--- <Insert>
set	@TableName = 'dbo.ReceiverLines'

insert
	dbo.ReceiverObjects
(	ReceiverLineID
,	[LineNo]
,	Status
,	PONumber
,	POLineNo
,	POLineDueDate
,	PartCode
,	PartDescription
,	EngineeringLevel
,	QtyObject
,	PackageType
,	Location
,	Plant
,	DrAccount
,	CrAccount
,	Note
,	UserDefinedStatus
)
select
	rl.ReceiverLineID
,	[LineNo] = r.RowNumber
,	rl.Status
,	rl.PONumber
,	rl.POLineNo
,	rl.POLineDueDate
,	rl.PartCode
,	PartDescription = null
,	EngineeringLevel = p.engineering_level
,	rl.StdPackQty
,	rl.PackageType
,	Location = case coalesce(p.class, 'N') when 'N' then '' else coalesce((select max(plant) from po_header where po_number =rl.PONumber),pi.primary_location) end
,	Plant = coalesce((select max(plant) from po_header where po_number =rl.PONumber),l.plant)
,	p.gl_account_code
,	pp.gl_account_code
,	Reason = (select min(Reason) from #ReceiverLines where RMA_ID = rl.PONumber and RMA_LineID = rl.POLineNO and PartCode = rl.PartCode)
,	'On Hold'
from
	dbo.ReceiverLines rl
	join dbo.udf_Rows(1000) r on
		r.RowNumber <= rl.RemainingBoxes
	left join dbo.part p on rl.PartCode = p.part
	left join dbo.part_inventory pi on rl.PartCode = pi.part
	left join dbo.location l on pi.primary_location = l.code
	left join dbo.part_purchasing pp on rl.PartCode = pp.part
where
	rl.ReceiverID = @ReceiverID

select
	@Error = @@Error
,	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
--- </Insert>

--		Done with temporary receiver lines.
drop table #ReceiverLines

--- <CloseTran required=Yes autoCreate=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
--- </CloseTran>

---	<Return success=True>
set	@Result = 0
return	@Result
--- </Return>

GO
