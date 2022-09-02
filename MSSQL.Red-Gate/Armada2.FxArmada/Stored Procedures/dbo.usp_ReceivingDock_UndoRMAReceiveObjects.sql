SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [dbo].[usp_ReceivingDock_UndoRMAReceiveObjects]
(	@User varchar(5),
	@RMA_ID int,
	@RMA_LineID int,
	@PartCode varchar(25),
	@SerialNumber int,
	@TranDT datetime out,
	@Result int out)
as
set nocount on
set	@Result = 999999

--- <Error Handling>
declare	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn int,
	@ProcResult int,
	@Error int,
	@RowCount int

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
save tran @ProcName
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

--	Initializations.
--		Verify the receipt has not already been invoiced.
--if	exists
--	(
--		select
--			*
--		from
--			dbo.audit_trail at
--			join dbo.po_receiver_items pri on
--				at.po_number = pri.purchase_order
--				and
--					at.part = pri.item
--				and
--					at.shipper + 
--					case
--						when (select IsNull(value,'') from dbo.preferences_standard where preference = 'MonitorAppendDateToShipper') = 'Y' then '_' + Convert(char(6), at.date_stamp, 12)
--						else ''
--					end = pri.bill_of_lading
--		where
--			at.serial = @SerialNumber
--			and
--				at.type = 'R'
--			and
--				pri.invoice > ''
--	) begin
--	set	@Result = 999999
--	RAISERROR ('The receipt for serial %d has already been invoiced in Empower and cannot be undone.', 16, 1, @SerialNumber)
--	rollback tran @ProcName
--	return @Result
--end

--		Get receipt transaction datetime, quantity and standard quantity.
declare
	@ReceiptDT datetime
,	@ReceiptQty numeric(20,6)
,	@ReceiptStdQty numeric(20,6)

select
	@ReceiptDT = at.date_stamp
,	@ReceiptQty = at.quantity
,	@ReceiptStdQty = at.std_quantity
from
	audit_trail at
where
	at.serial = @SerialNumber
	and at.type = 'U'
	and at.date_stamp =
		(	select
				max(date_stamp)
			from
				dbo.audit_trail
			where
				serial = @SerialNumber)

if	@ReceiptQty is null begin
	set	@Result = 999999
	RAISERROR ('Error reading receipt quantity for serial %d in procedure %s.', 16, 1, @SerialNumber, @ProcName)
	rollback tran @ProcName
	return @Result
end

--	Remove inventory.
--			New audit trail record for reversal.
--- <Insert Rows="1">
set	@TableName = 'dbo.audit_trail'

insert	audit_trail
(	serial, date_stamp, type, part,
	quantity, remarks, price, vendor,
	po_number, operator, from_loc, to_loc,
	on_hand, lot, weight, status,
	shipper, unit, std_quantity, cost, control_number,
	custom1, custom2, custom3, custom4, custom5,
	plant, notes, gl_account, package_type,
	release_no, std_cost,
	user_defined_status,
	part_name, tare_weight, field1)
select	at.serial, @TranDT, 'U', at.part,
	-at.quantity, 'RMA', at.price, at.vendor,
	at.po_number, @User, at.from_loc, at.to_loc,
	IsNull(po.on_hand, 0) - at.std_quantity, at.lot, at.weight, at.status,
	at.shipper, at.unit, -at.std_quantity, at.cost, at.control_number,
	at.custom1, at.custom2, at.custom3, at.custom4, at.custom5,
	at.plant, at.notes, at.gl_account, at.package_type,
	at.release_no, at.std_cost, at.user_defined_status,
	at.part_name, at.tare_weight, at.field1
from
	audit_trail at
	left join dbo.part_online po on
		at.part = po.part
where
	at.serial = @SerialNumber and
	at.type = 'U' and
	at.date_stamp = @ReceiptDT

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
if	@RowCount != 1 begin
	set	@Result = 999999
	RAISERROR ('Error inserting into table %s in procedure %s.  Rows inserted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
	rollback tran @ProcName
	return @Result
end
--- </Insert>

--			Remove object records.
--- <Delete Rows="1">
set	@TableName = 'dbo.object'
delete
	dbo.object
where
	serial = @SerialNumber
		
select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return @Result
end
if	@RowCount != 1 begin
	set	@Result = 900102
	RAISERROR ('Error deleting from table %s in procedure %s.  Rows deleted: %d.  Expected rows: %d.', 16, 1, @TableName, @ProcName, @RowCount, 1)
	rollback tran @ProcName
	return @Result
end
--- </Delete>
	
/*	Update part on hand.*/
--- <Call>	
set	@CallProcName = 'dbo.usp_InventoryControl_UpdatePartOnHand'
execute
	@ProcReturn = dbo.usp_InventoryControl_UpdatePartOnHand
		@PartCode = @PartCode
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

/*	Update RMA Line and RMA Header. */
/*		RMA Line.*/
--- <Update rows="1">
set	@TableName = 'dbo.shipper_detail'

update
	sd
set
	qty_packed = coalesce(sd.qty_packed, 0) + dbo.udf_GetQtyFromStdQty(@PartCode, @ReceiptStdQty, sd.alternative_unit)
,	alternative_qty = coalesce(sd.alternative_qty, 0) + @ReceiptStdQty
from
	dbo.shipper_detail sd
where
	sd.shipper = @RMA_ID
	and sd.suffix = @RMA_LineID
	and sd.part_original = @PartCode

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

/*	RMA Header */
--- <Update rows="*">
set	@TableName = 'dbo.shipper'

update
	s
set
	status =
		case
			when exists
				(	select
						*
					from
						dbo.shipper_detail
					where
						shipper = @RMA_ID
						and abs(qty_packed) < abs(qty_required)
				) then 'O'
			else 'S'
		end
from
	dbo.shipper s
where
	s.id = @RMA_ID

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

--<CloseTran Required=Yes AutoCreate=Yes>
if	@TranCount = 0 begin
	commit transaction @ProcName
end
--</CloseTran Required=Yes AutoCreate=Yes>

--	IV.	Return.
set	@Result = 0
return @Result


GO
