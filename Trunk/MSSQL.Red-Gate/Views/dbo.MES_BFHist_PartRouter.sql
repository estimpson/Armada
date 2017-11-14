SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[MES_BFHist_PartRouter]
as
select
	TopPart = xr.TopPart
,	TempWIP = case when p.type = 'T' then 1 else 0 end
,	MachineList =
	(	select
 			FX.ToList(pm.machine)
 		from
 			dbo.part_machine pm
		where
			pm.part = xr.ChildPart
 	)
,	VendorList =
	(	select
 			FX.ToList(pv.vendor)
 		from
 			dbo.part_vendor pv
		where
			pv.part = xr.ChildPart
 	)
,   xr.ChildPart
,   xr.BOMID
,   xr.Sequence
,   xr.BOMLevel
,   xr.XQty
,   xr.XScrap
,   xr.XBufferTime
,   xr.XRunRate
,   xr.Hierarchy
,   xr.Infinite
from
	FT.XRt xr
	left join dbo.part p
		on p.part = xr.ChildPart
GO
