set nocount on
set ansi_warnings on

declare
	@Current862s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current862s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDISUMMIT.CurrentShipSchedules ()

declare
	@Current830s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(15)
,	ShipFromCode varchar(15)
,	ConsigneeCode varchar(15)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
)

insert
	@Current830s
select distinct
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
from
	EDISUMMIT.CurrentPlanningReleases ()

/*
select
	*
from
	EDISUMMIT.ShipScheduleHeaders fh

select
	'PlanningHeaders'
		
select
	*
from
	EDISUMMIT.PlanningHeaders fh
*/

declare
	@RawReleases table
(	RowID int not null IDENTITY(1, 1) primary key
,	Status int default(0)
,	ReleaseType int
,	OrderNo int
,	Type tinyint
,	ReleaseDT datetime
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	DockCode varchar(30) null
,	LineFeedCode varchar(30) null
,	ReserveLineFeedCode varchar(30) null
,	StandardPack numeric(20,6) null
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	QtyReleaseRounded numeric(20,6)
,	ReferenceAccum numeric(20,6)
,	CustomerAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	RelPriorRounded numeric(20,6)
,	RelPostRounded numeric(20,6)
,	NewDocument int
,	unique
	(	OrderNo
	,	NewDocument
	,	RowID
	)
,	unique
	(	OrderNo
	,	RowID
	,	RelPost
	,	QtyRelease
	,	StdQtyRelease
	)
,	unique
	(	OrderNo
	,	Type
	,	RowID
	)
)

insert
	@RawReleases
(	ReleaseType
,	OrderNo
,	Type
,	ReleaseDT
,	BlanketPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	OrderUnit
,	ReleaseNo
,	StandardPack
,	QtyRelease
,	StdQtyRelease
,	ReferenceAccum
,	CustomerAccum
,	NewDocument
)
/*		Add releases due today when behind and no release for today exists. */

select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = ft.fn_TruncDate('dd', getdate())
,	BlanketPart = min(bo.PartCode)
,	CustomerPart = min(bo.CustomerPart)
,	ShipToID = min(bo.ShipToCode)
,	CustomerPO = min(bo.CustomerPO)
,	ModelYear = min(bo.ModelYear)
,	OrderUnit = min(bo.OrderUnit)
,	ReleaseNo = 'Accum Demand'
,	StandardPack = max(bo.StandardPack)
,	QtyRelease = 0
,	StdQtyRelease = 0
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'C' 
												then min(coalesce(convert(int,fa.LastAccumQty),0))
												else min(coalesce(convert(int,bo.AccumShipped),0))
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'P' 
												then min(coalesce(convert(int,faa.PriorCUM),0))
												else min(coalesce(convert(int,fa.LastAccumQty),0))
												end
	,	(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.ShipScheduleHeaders fh
	join EDISUMMIT.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
		join
				(Select * From @Current862s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where
		not exists
		(	select
				*
			from
				EDISUMMIT.ShipSchedules ss
			where
				ss.Status = 1 and
				ss.RawDocumentGUID = c.RawDocumentGUID and
				ss.RawDocumentGUID = fr.RawDocumentGUID
				and ss.CustomerPart = fr.CustomerPart
				and ss.ShipToCode = fr.ShipToCode
				and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
		)
	and fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.ShipScheduleHeaders', 'Status', 'Active'))
	and		c.RawDocumentGUID = fr.RawDocumentGUID
group by
	bo.BlanketOrderNo
,	fh.RawDocumentGUID
, bo.ReferenceAccum
, bo.AdjustmentAccum 
having
					case bo.AdjustmentAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'P' 
												then min(coalesce(convert(int,faa.PriorCUM),0))
												else min(coalesce(convert(int,fa.LastAccumQty),0))
												end > 
												case bo.ReferenceAccum 
												When 'N' 
												then min(coalesce(convert(int,bo.AccumShipped),0))
												When 'C' 
												then min(coalesce(convert(int,fa.LastAccumQty),0))
												else min(coalesce(convert(int,bo.AccumShipped),0))
												end

/*		862s. */
union all
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	StandardPack = bo.StandardPack
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,fa.LastAccumQty),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,faa.PriorCUM),0)
												else coalesce(convert(int,fa.LastAccumQty),0)
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current862s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.ShipScheduleHeaders fh
	join EDISUMMIT.ShipSchedules fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.ShipScheduleAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOShipSchedule = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearShipSchedule = 0
			or bo.ModelYear862 = fr.CustomerModelYear
		)
		join
				(Select * From @Current862s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
and			fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.ShipScheduleHeaders', 'Status', 'Active'))
		

/*		830s. */
Union all
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
,	Type = (	case 
					when bo.PlanningFlag = 'P' then 2
					when bo.PlanningFlag = 'F' then 1
					when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z') then 2
					else 1
					end
			  )
,	ReleaseDT = dateadd(dd, ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = fr.ReleaseNo
,	StandardPack = bo.StandardPack
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum = case bo.ReferenceAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'C' 
												then coalesce(convert(int,fa.LastAccumQty),0)
												else coalesce(convert(int,bo.AccumShipped),0)
												end
,	CustomerAccum = case bo.AdjustmentAccum 
												When 'N' 
												then coalesce(convert(int,bo.AccumShipped),0)
												When 'P' 
												then coalesce(convert(int,faa.PriorCUM),0)
												else coalesce(convert(int,fa.LastAccumQty),0)
												end
,	NewDocument =
		(	select
				min(c.NewDocument)
			from
				@Current830s c
			where
				c.RawDocumentGUID = fh.RawDocumentGUID
		)
from
	EDISUMMIT.PlanningHeaders fh
	join EDISUMMIT.PlanningReleases fr
		on fr.RawDocumentGUID = fh.RawDocumentGUID
	left join EDISUMMIT.PlanningAccums fa
		on fa.RawDocumentGUID = fh.RawDocumentGUID
		and fa.CustomerPart = fr.CustomerPart
		and	fa.ShipToCode = fr.ShipToCode
		and	coalesce(fa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(fa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	left join EDISUMMIT.PlanningAuthAccums faa
		on faa.RawDocumentGUID = fh.RawDocumentGUID
		and faa.CustomerPart = fr.CustomerPart
		and	faa.ShipToCode = fr.ShipToCode
		and	coalesce(faa.CustomerPO,'') = coalesce(fr.CustomerPO,'')
		and	coalesce(faa.CustomerModelYear,'') = coalesce(fr.CustomerModelYear,'')
	join EDISUMMIT.BlanketOrders bo
		on bo.EDIShipToCode = fr.ShipToCode
		and bo.CustomerPart = fr.CustomerPart
		and
		(	bo.CheckCustomerPOPlanning = 0
			or bo.CustomerPO = fr.CustomerPO
		)
		and
		(	bo.CheckModelYearPlanning = 0
			or bo.ModelYear830 = fr.CustomerModelYear
		)
		join
				(Select * From @Current830s) c 
			on
				c.CustomerPart = bo.customerpart and
				c.ShipToCode = bo.EDIShipToCode and
				(	bo.CheckCustomerPOShipSchedule = 0
							or bo.CustomerPO = c.CustomerPO
				)
					and	(	bo.CheckModelYearShipSchedule = 0
							or bo.ModelYear862 = c.CustomerModelYear
				)
where		c.RawDocumentGUID = fr.RawDocumentGUID
	and		fh.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningHeaders', 'Status', 'Active'))
	and		fr.Status = 1 --(select dbo.udf_StatusValue('EDISUMMIT.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
	
order by
		2,1,4

/*		Calculate orders to update. */
update
	rr
set
	NewDocument =
	(	select
			max(NewDocument)
		from
			@RawReleases rr2
		where
			rr2.OrderNo = rr.OrderNo
	)
from
	@RawReleases rr

update
	@RawReleases
set
	RelPost = CustomerAccum + coalesce (
	(	select
			sum(StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

update
	rr
set
	rr.RelPostRounded = CustomerAccum + coalesce(ceiling((RelPost - CustomerAccum) / nullif(StandardPack, 0)) * StandardPack, RelPost - CustomerAccum)
from
	@RawReleases rr
	

update
	rr
set
	rr.RelPost = case when rr.ReferenceAccum > rr.RelPost then rr.ReferenceAccum else rr.RelPost end
,	rr.RelPostRounded = case when rr.ReferenceAccum > rr.RelPostRounded then rr.ReferenceAccum else rr.RelPostRounded end
from
	@RawReleases rr

update
	rr
set
	rr.RelPrior = coalesce (
	(	select
			max(RelPost)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), ReferenceAccum)
,	rr.RelPriorRounded = coalesce (
	(	select
			max(RelPostRounded)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), ReferenceAccum)
from
	@RawReleases rr

update
	rr
set
	releaseNo = 'Accum Increase'
from
	@RawReleases rr
where
	CustomerAccum > ReferenceAccum
	and RelPriorRounded = ReferenceAccum

update
	rr
set
	rr.QtyRelease = RelPost - RelPrior
,	rr.StdQtyRelease = RelPost - RelPrior
,	rr.QtyReleaseRounded = RelPostRounded - RelPriorRounded
from
	@RawReleases rr

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyReleaseRounded <= 0

update
	rr
set
	ReleaseDT = dateadd(dd,1,(select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1and Status>-1))
from
	@RawReleases rr
where
	rr.ReleaseType = 2
	and rr.ReleaseDT <= (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1 and Status>-1)

update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID
			and Status = 0
	)
,	QtyShipper = shipSchedule.qtyRequired
from
	@RawReleases rr
	left join
	(	select
			orderNo = sd.order_no
		,	qtyRequired = sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
		group by
			sd.order_no
	) shipSchedule
		on shipSchedule.orderNo = rr.OrderNo
where
	rr.status = 0

select
	rr.RowID
,	rr.Status
--,	rr.ReleaseType
--,	rr.OrderNo
--,	rr.Type
,	rr.ReleaseDT
,	rr.BlanketPart
,	rr.CustomerPart
,	rr.ShipToID
,	rr.CustomerPO
--,	rr.ModelYear
--,	rr.OrderUnit
--,	rr.QtyShipper
,	rr.Line
,	rr.ReleaseNo
--,	rr.DockCode
--,	rr.LineFeedCode
--,	rr.ReserveLineFeedCode
,	rr.StandardPack
,	rr.QtyRelease
,	rr.StdQtyRelease
,	rr.QtyReleaseRounded
,	rr.ReferenceAccum
,	rr.CustomerAccum
,	rr.RelPrior
,	rr.RelPost
,	rr.RelPriorRounded
,	rr.RelPostRounded
,	rr.NewDocument
from
	@RawReleases rr
where
	rr.CustomerPart = 'COM.0397'
order by
	rr.ReleaseDT

select
	*
from
	EDISUMMIT.BlanketOrders bo
where
	bo.CustomerPart = 'COM.0397'