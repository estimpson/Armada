SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListStagedItems_ByShipper]
(	@ShipperID int)
as
/*
execute	custom.usp_Shipping_ListStagedItems_ByShipper
	@ShipperID = 25472
*/
set nocount on

select	ShipperID = shipper, Serial = serial, Part = part, Qty = Quantity,
	PalletSerial = convert (int, parent_serial), ShowOnShipper = show_on_shipper
from	object
where	shipper = @ShipperID
order by
	1, 2

GO
