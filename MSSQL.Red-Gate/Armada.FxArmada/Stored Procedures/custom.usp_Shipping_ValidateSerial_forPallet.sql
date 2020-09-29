SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ValidateSerial_forPallet]
(	@Serial int,
	@PalletSerial int)
as
/*
Example:
execute	custom.usp_Shipping_ValidateSerial_forPallet
	@Serial = 282897,
	@PalletSerial = 88180
:End Example
*/

--	I.	Return Serial/Pallet validation.
declare	@OtherParts int

select	@OtherParts = count (1)
from	object
where	parent_serial = @PalletSerial and
	part !=
	(	select	part
		from	object
		where	serial = @Serial)

select	Serial = @Serial,
	PalletSerial = @PalletSerial,
	WouldMixPallets = (case when @OtherParts > 0 then 1 else 0 end)

GO
