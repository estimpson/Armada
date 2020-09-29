SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_ReceivingDock_ReceiveObjects_againstBlanketPO]
	@User varchar(5)
,	@PONumber int
,	@PartCode varchar(25)
,	@PackageType varchar(20)
,	@PerBoxQty numeric(20,6)
,	@NewObjects int
,	@Shipper varchar(20)
,	@LotNumber varchar(20)
,	@Location varchar(10) = null
,	@UserDefinedStatus varchar(30) = null
,	@SerialNumber int out
,	@TranDT datetime = null out
,	@Result int = null out
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn int,
	@ProcResult int,
	@Error int,
	@RowCount int

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
/*	Determine the PO line to receive against. */
declare
	@PODueDT datetime
,	@PORowID int

select
	@PORowID = min(pd.Row_ID)
,	@PODueDT = min(pd.date_due)
from
	dbo.po_detail pd
where
	pd.po_number = @PONumber
	and pd.part_number = @PartCode
	and pd.status = 'A'
	and pd.date_due = coalesce
		(	(	select
					min(pd2.date_due)
				from
					dbo.po_detail pd2
				where
					pd2.po_number = @PONumber
					and pd2.part_number = @PartCode
					and pd2.status = 'A'
					and pd2.balance > 0
			)
		,	pd.date_due
		)
	and pd.row_id =
		(	select
				min(pd2.row_id)
			from
				dbo.po_detail pd2
			where
				pd2.po_number = @PONumber
				and pd2.part_number = @PartCode
				and pd2.status = 'A'
				and pd2.date_due = pd.date_due
		)

declare
		@IntercompanyReceipt bit = case when @SerialNumber is not null and @PONumber is not null then 1 else 0 end
	,	@TransferReceipt bit = case when @SerialNumber is not null and @PONumber is null then 1 else 0 end

/*	Perform inventory update. */

--- <Call>	
set	@CallProcName = 'dbo.usp_ReceivingDock_ReceiveObject_Inventory'
execute
	@ProcReturn = dbo.usp_ReceivingDock_ReceiveObject_Inventory
		@User = @User
	,	@PONumber = @PONumber
	,	@PartCode = @PartCode
	,	@PODueDT = @PODueDT
	,	@PORowID = @PORowID
	,	@PackageType = @PackageType
	,	@PerBoxQty = @PerBoxQty
	,	@NewObjects = @NewObjects
	,	@Shipper = @Shipper
	,	@LotNumber = @LotNumber
	,	@Location = @Location
	,	@IntercompanyReceipt = @IntercompanyReceipt
	,	@TransferReceipt = @TransferReceipt
	,	@SerialNumber = @SerialNumber out
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

/*	Update Purchase Order and Part-Vendor relationship. */
select
	ID = identity(int, 1, 1)
,	RowID = convert(int, pd.Row_ID)
,	RequiredQty = pd.standard_qty
,	RequiredAccum = convert (numeric(20,6), null)
into
	#POLines
from
	dbo.po_detail pd
where
	pd.po_number = @PONumber and
	pd.part_number = @PartCode and
	pd.balance > 0
order by
	pd.date_due

update
	#POLines
set
	RequiredAccum = (select sum(RequiredQty) from #POLines PO1 where ID <= #POLines.ID)

/*		Update the Line Item with receipt quantities and date. */
--- <Update>
set	@TableName = 'dbo.po_detail'

update
	pd
set	received = coalesce(pd.received, 0) + dbo.udf_GetQtyFromStdQty(pd.part_number, @PerBoxQty * @NewObjects - (pl.RequiredAccum - pl.RequiredQty), pd.unit_of_measure)
,	balance = coalesce(pd.balance, pd.quantity) - dbo.udf_GetQtyFromStdQty(pd.part_number, @PerBoxQty * @NewObjects - (pl.RequiredAccum - pl.RequiredQty), pd.unit_of_measure)
,	standard_qty = pd.standard_qty - (@PerBoxQty * @NewObjects - (pl.RequiredAccum - pl.RequiredQty))
,	last_recvd_date = @TranDT
,	last_recvd_amount = dbo.udf_GetQtyFromStdQty(pd.part_number, @PerBoxQty * @NewObjects - (pl.RequiredAccum - pl.RequiredQty), pd.unit_of_measure)
from
	dbo.po_detail pd
	join #POLines pl
		on pd.RowID = pl.RowID
where
	pd.po_number = @PONumber
	and pd.part_number = @PartCode
	and pl.RequiredAccum - pl.RequiredQty < @PerBoxQty * @NewObjects
	and pl.RequiredAccum > @PerBoxQty * @NewObjects

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

--- <Update>
set	@TableName = 'dbo.po_detail'

update
	pd
set
	received = pd.received + dbo.udf_GetQtyFromStdQty(pd.part_number, pd.standard_qty, pd.unit_of_measure)
,	balance = 0
,	standard_qty = 0
,	last_recvd_date = @TranDT
,	last_recvd_amount = dbo.udf_GetQtyFromStdQty(pd.part_number, pd.standard_qty, pd.unit_of_measure)
from
	dbo.po_detail pd
	join #POLines pl
		on pd.RowID = pl.RowID
where
	pd.po_number = @PONumber
	and pd.part_number = @PartCode
	and pl.RequiredAccum - pl.RequiredQty < @PerBoxQty * @NewObjects
	and pl.RequiredAccum <= @PerBoxQty * @NewObjects

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

/*		Create receipt history. */
--- <Insert>
set	@TableName = 'po_detail_history'

insert
	po_detail_history
(	po_number, vendor_code, part_number, description, unit_of_measure
, 	date_due, requisition_number, status, type, last_recvd_date
,	last_recvd_amount, cross_reference_part, account_code, notes, quantity
,	received, balance, active_release_cum, received_cum, price
,	row_id, invoice_status, invoice_date, invoice_qty, invoice_unit_price
,	release_no, ship_to_destination, terms, week_no, plant
,	invoice_number, standard_qty, sales_order, dropship_oe_row_id, ship_type
,	dropship_shipper, price_unit, ship_via, release_type, alternate_price)
select
	pd.po_number, pd.vendor_code, pd.part_number, pd.description, pd.unit_of_measure
,	pd.date_due, pd.requisition_number, pd.status, pd.type, @TranDT
,	pd.last_recvd_amount, pd.cross_reference_part, pd.account_code, pd.notes, pd.quantity
,	pd.received, pd.balance, pd.active_release_cum, pd.received_cum, pd.price
,	pd.row_id, pd.invoice_status, pd.invoice_date, pd.invoice_qty, pd.invoice_unit_price
,	pd.release_no, pd.ship_to_destination, pd.terms, pd.week_no, pd.plant
,	pd.invoice_number, pd.standard_qty, pd.sales_order, pd.dropship_oe_row_id, pd.ship_type
,	pd.dropship_shipper, pd.price_unit, pd.ship_via, pd.release_type, pd.alternate_price
from
	dbo.po_detail pd
	join #POLines pl on
		pd.RowID = pl.RowID
where
	pd.po_number = @PONumber
	and pd.part_number = @PartCode
	and pl.RequiredAccum - pl.RequiredQty < @PerBoxQty * @NewObjects

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

/*		Remove releases which have been fully met. */
--- <Delete>
set	@TableName = 'dbo.po_detail'

delete
	pd
from
	dbo.po_detail pd
where
	pd.po_number = @PONumber
	and	pd.part_number = @PartCode
	and	pd.balance <= 0

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

/*		Update Part-Vendor relationship. */
--- <Update>
set	@TableName = 'dbo.part_vendor'

update
	pv
set
	accum_received = coalesce(accum_received, 0) + (@PerBoxQty * @NewObjects)
from
	dbo.part_vendor pv
where
	pv.part = @PartCode
	and	pv.vendor =
		(	select
				max(pd.vendor_code)
			from
				dbo.po_detail pd
			where
				pd.po_number = @PONumber
				and pd.part_number = @PartCode
		)

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
	@Param1 [scalar_data_type]

set	@Param1 = [test_value]

begin transaction Test

declare
	@ProcReturn int
,	@TranDT datetime
,	@ProcResult int
,	@Error int

execute
	@ProcReturn = dbo.usp_ReceivingDock_ReceiveObjects_againstBlanketPO
	@Param1 = @Param1
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
