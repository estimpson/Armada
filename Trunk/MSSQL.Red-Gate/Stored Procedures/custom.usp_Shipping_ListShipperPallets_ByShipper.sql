SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListShipperPallets_ByShipper]
(	@SID int)
as
/*
execute	custom.usp_Shipping_ListShipperPallets_ByShipper
	@SID = 88204

*/
select	SID = object.shipper,
	Pallet = convert (int, coalesce (object.parent_serial, -1)),
	Part = '(' + object.part + ') ' + min (part.name),
	Boxes = count (1),
	PalletTotals = convert (int, sum (std_quantity)),
	PartTotals = convert (int,
	(	select	sum (std_quantity)
		from	object o2
		where	shipper = object.shipper and
			part = object.part))
from	object
	join part on object.part = part.part
where	object.shipper = @SID and
	object.part != 'PALLET'
group by
	object.shipper,
	object.parent_serial,
	object.part
union all
select	SID = object.shipper,
	Pallet = object.serial,
	Part = '(' + object.part + ') Empty',
	Boxes = 0,
	PalletTotals = 0,
	PartTotals = 0
from	object
where	object.shipper = @SID and
	object.type = 'S' and
	not exists
	(	select	1
		from	object o2
		where	parent_serial = object.serial)
group by
	object.shipper,
	object.serial,
	object.part
order by
	1, 2

GO
