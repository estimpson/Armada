SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListShipperLineItems_ByShipper]
(	@ShipperID int)
as
/*
execute	custom.usp_Shipping_ListShipperLineItems_ByShipper
	@ShipperID = 25453
*/
set nocount on

select	ShipperID = shipper, PartWithSuffix = part, Part = part_original,
	ReqdQty = convert (int, qty_required),
	PckdQty = convert (int, qty_packed),
	CustomerPart = customer_part, PartDesc = part_name
from	shipper_detail
where	shipper = @ShipperID
order by
	1, 2

GO
