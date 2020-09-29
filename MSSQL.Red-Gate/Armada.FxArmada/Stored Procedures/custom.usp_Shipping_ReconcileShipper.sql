SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ReconcileShipper]
(	@ShipperID integer,
	@Result integer = 0 output
--<Debug>
	, @Debug integer = 0
--</Debug>
)
/*
Example:
begin transaction

declare	@ProcReturn int,
	@ProcResult int

execute	@ProcReturn = custom.usp_Shipping_ReconcileShipper
	@ShipperID = ?,
	@BoxSerial = ?,
	@Result = @ProcResult output

select	@ProcReturn,
	@ProcResult

rollback
:End Example
*/
as
set nocount on
set	@Result = 999999

--<Tran Required=Yes AutoCreate=No>
if	@@TranCount = 0 begin
	set	@Result = 900001
	RAISERROR (@Result, 16, 1, 'Shipping_ReconcileShipper')
	return	@Result
end
--</Tran>

--	I.	Update the shipper line items.
declare	@NotScheduled int,
	@NotTaxable char (1),
	@PerPiecePrice char (1)

set	@NotScheduled = 0
set	@NotTaxable = 'N'
set	@PerPiecePrice = 'P'

--		A.	Set the quantity packed, weights, etc.
update	shipper_detail
set	qty_packed = IsNull (QtyPacked, 0),
	qty_required = case when qty_original = @NotScheduled then IsNull (QtyPacked, 0) else qty_required end,
	alternative_qty = IsNull (QtyPacked, 0),
	boxes_staged = IsNull (Boxes, 0),
	net_weight = IsNull (NetWeight, 0),
	tare_weight = IsNull (TareWeight, 0),
	gross_weight = IsNull (NetWeight+TareWeight, 0)
from	shipper_detail
	left outer join
	(	select	Part = part,
			Suffix = suffix,
			QtyPacked = sum (std_quantity),
			Boxes = count (1),
			NetWeight = sum (weight),
			TareWeight = sum (tare_weight)
		from	object
		where	object.shipper = @ShipperID and
			object.type is null
		group by
			part,
			suffix ) ShippingInventory on shipper_detail.part_original = ShippingInventory.Part and
		IsNull (shipper_detail.suffix, -1) = IsNull (ShippingInventory.Suffix, -1)
where	shipper = @ShipperID

--			1.	Adjust committed quantity.
update	order_detail
set	committed_qty =
		case	when the_cum < CommittedQty then quantity
			when our_cum < CommittedQty then CommittedQty - our_cum
			else 0
		end
from	order_detail
	left outer join
	(	select	OrderNo = shipper_detail.order_no,
			CommittedQty = sum (shipper_detail.qty_required) + min (order_header.our_cum)
		from	shipper_detail
			join shipper on shipper_detail.shipper = shipper.id
			join order_header on shipper_detail.order_no = order_header.order_no
		where	isnull (shipper.type, 'N') = 'N' and
			shipper.status not in ('C', 'E')
		group by
			shipper_detail.order_no) Committed on order_detail.order_no = Committed.OrderNo
where	order_detail.order_no in
	(	select	order_no
		from	shipper_detail
		where	shipper = @ShipperID)

--		B.	Delete empty lines from shipper.
delete	shipper_detail
where	shipper = @ShipperID and
	qty_packed = 0 and
	qty_original = @NotScheduled


--	I.	Update the shipper header.
--		A.	Set totals for pallets and boxes and shipper status.
update	shipper
set	status = case when StagedCount > 0 and UnstagedCount = 0 then 'S' else 'O' end,
	staged_objs = Boxes,
	staged_pallets = Pallets,
	net_weight = NetWeight,
	tare_weight = TareWeight,
	gross_weight = NetWeight + TareWeight
from	shipper
	left outer join
	(	select	StagedCount = sum (case when qty_packed >= qty_required then 1 else 0 end),
			UnstagedCount = sum (case when qty_packed < qty_required then 1 else 0 end),
			Boxes = sum (boxes_staged),
			Pallets =
				(	select	count (1)
					from	object
					where	shipper = @ShipperID and
						type = 'S'),
			NetWeight = sum (net_weight),
			TareWeight = sum (tare_weight) +
				(	select	sum (tare_weight)
					from	object
					where	shipper = @ShipperID and
						type = 'S')
		from	shipper_detail
		where	shipper = @ShipperID) ShipperSummary on 1=1
where	id = @ShipperID

--	III.	Reconciled.
set	@Result = 0
return	@Result

GO
