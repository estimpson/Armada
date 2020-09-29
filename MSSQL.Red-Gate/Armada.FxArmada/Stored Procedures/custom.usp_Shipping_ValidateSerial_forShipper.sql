SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ValidateSerial_forShipper]
(	@Serial int,
	@Shipper int)
as
/*
Example:
execute	custom.usp_Shipping_ValidateSerial_forShipper
	@Serial = 282897,
	@Shipper = 88180
:End Example
*/

--	I.	Return Serial validation.
declare	@PartMismatch int

select	@PartMismatch = count (1)
from	object
where	(	(serial = @Serial and type is null) or
		parent_serial = @Serial) and
	part not in
	(	select	part_original
		from	shipper_detail
		where	shipper = @Shipper)

select	Serial = @Serial,
	Shipper = @Shipper,
	IsObject = (select count (1) from object where serial = @Serial),
	IsBox = (select count (1) from object where serial = @Serial and type is null),
	IsPallet = (select count (1) from object where serial = @Serial and type = 'S'),
	IsOnPallet = (select count (1) from object where serial = @Serial and parent_serial in (select serial from object where type = 'S')),
	IsStaged = (select count (1) from object where serial = @Serial and shipper = @Shipper),
	IsValidForShipper = (case when @PartMismatch > 0 then 0 else 1 end),
	IsVerified = (select count (1) from object where serial = @Serial and shipper = @Shipper and custom5 > ''),
	IsLineItemStaged = (select count (1) from shipper_detail where shipper = @Shipper and qty_packed >= qty_required and part_original in (select part from object where serial = @Serial or parent_serial = @Serial)),
	OnShipper = isnull ((select shipper from object where serial = @Serial), 0),
	IsShipperVerified = (select count (1) from shipper where scheduled_ship_time is not null and id = @Shipper),
	WouldOverStage =
	(	select	count (1)
		from	shipper_detail
		where	shipper = @Shipper and
			isnull (qty_packed, 0) + isnull (
			(	select	sum (std_quantity)
				from	object
				where	(serial = @Serial or
					parent_serial = @Serial) and
					part = shipper_detail.part_original and
					shipper is null), 0) > qty_required and
			part_original in
			(	select	part
				from	object
				where	serial = @Serial or
					parent_serial = @Serial))

GO
