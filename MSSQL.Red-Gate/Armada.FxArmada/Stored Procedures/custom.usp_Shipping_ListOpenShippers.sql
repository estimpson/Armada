SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListOpenShippers]
as
select	SID = shipper.id,
	ETD = shipper.date_stamp,
	Carrier = '(' + shipper.ship_via + ') ' + carrier.name,
	Customer = '(' + shipper.customer + ') ' + customer.name,
	Boxes =
	(	select	count (1)
		from	object
		where	shipper = shipper.id and
			part != 'PALLET'),
	Pallets =
	(	select	count (1)
		from	object
		where	shipper = shipper.id and
			part = 'PALLET')
from	shipper
	join carrier on shipper.ship_via = carrier.scac
	join customer on shipper.customer = customer.customer
where	shipper.status in ('O', 'S')
order by
	1, 2

GO
