select top 100
	*
from
	FXSYS.USP_Calls uc
where
	uc.USP_Name like '%Receiving%'
order by
	uc.RowCreateDT desc