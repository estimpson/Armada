select top(100)
	*
from
	EDICHRY.ShipScheduleSupplemental sss
order by
	sss.RowID desc

select top(100)
	*
from
	EDIToyota.ShipScheduleSupplemental sss
order by
	sss.RowID desc

select
	*
from
	FxEDI.EDI.EDIDocuments ed
where
	ed.GUID = 'CA4E975F-289B-E911-A9F3-001E6746D5DD'