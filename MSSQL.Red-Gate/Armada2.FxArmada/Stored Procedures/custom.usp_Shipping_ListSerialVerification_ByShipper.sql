SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create procedure [custom].[usp_Shipping_ListSerialVerification_ByShipper]
(	@SID int)
as
/*
execute	custom.usp_Shipping_ListSerialVerification_ByShipper
	@SID = 88180

*/
select	SID = convert (int, object.shipper),
	IsStaged = (case when (select status from shipper where id = @SID) = 'S' then 1 else 0 end),
	ParentSerial = convert (int, object.parent_serial),
	Serial = convert (int, object.serial),
	IsPallet = (case when isnull (object.type, 'B') = 'S' then 1 else 0 end),
	IsVerified = (case when custom5 is not null then 1 else 0 end)
from	object
where	shipper = @SID
order by
	isnull (parent_serial, serial) asc,
	(case when isnull (object.type, 'B') = 'S' then 1 else 0 end) desc,
	serial asc

GO
