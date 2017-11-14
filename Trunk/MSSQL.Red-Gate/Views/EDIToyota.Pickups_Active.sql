SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [EDIToyota].[Pickups_Active]
as
select
	ReleaseDate = ss.ReleaseDT
,	PickupDT = ss.ReleaseDT
,	ShipToCode = ss.ShipToCode
,	PickupCode = ss.ShipFromCode
from
	EDIToyota.ShipScheduleHeaders ssh
	join EDIToyota.ShipSchedules ss
		on ss.RawDocumentGUID = ssh.RawDocumentGUID
		and ss.Status = 1 --(dbo.udf_StatusValue('EDITOYO.ShipSchedules', 'Active'))
where
	ssh.Status = 1 --(dbo.udf_StatusValue('EDITOYO.ShipScheduleHeaders', 'Active'))
group by
	ss.ReleaseDT
,	ss.ShipToCode
,	ss.ShipFromCode
GO
