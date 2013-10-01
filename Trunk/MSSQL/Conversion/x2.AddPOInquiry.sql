insert
	dbo.dw_inquiry_files
select
	*
from
	FxArmada.dbo.dw_inquiry_files dif
where
	dif.datawindow_name not in
	(	select
			difTSM.datawindow_name
		from
			dbo.dw_inquiry_files difTSM
	)
