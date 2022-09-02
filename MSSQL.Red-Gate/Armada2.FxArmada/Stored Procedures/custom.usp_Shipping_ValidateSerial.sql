SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ValidateSerial]
(	@Serial int)
as
/*
Example:
execute	custom.usp_Shipping_ValidateSerial
	@Serial = 235320
:End Example
*/

--	I.	Return Serial validation.
select	SerialSerial = @Serial,
	IsObject = (select count (1) from object where serial = @Serial),
	IsBox = (select count (1) from object where serial = @Serial and type is null),
	IsPallet = (select count (1) from object where serial = @Serial and type = 'S'),
	IsOnPallet = (select count (1) from object where serial = @Serial and parent_serial in (select serial from object where type = 'S')),
	Shipper = (select shipper from object where serial = @Serial and type = 'S')

GO
