SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListOpenShippers_BySerial]
(	@Serial int)
as
set nocount on

select	ID = id, ShipDT = date_stamp, ShipTo = shipper.destination, BillToName = customer.name
from	shipper
	left outer join customer on shipper.customer = customer.customer
where	status in ('O','S') and
	isnull (type, 'N') in ('N', 'T', 'V', 'O') and
	id in
	(	select	shipper_detail.shipper
		from	shipper_detail
			join object on shipper_detail.part_original = object.part
		where	object.serial = @Serial or
			object.parent_serial = @Serial)
order by
	1, 2

GO
