begin tran
go

exec
	dbo.usp_Scheduling_BuildXRt 
	    @Result = 0
	,   @Debug = 0 -- int
go

commit tran
go

select
	*
from
	FT.XRt xr
order by
	xr.TopPart
,	xr.Sequence
