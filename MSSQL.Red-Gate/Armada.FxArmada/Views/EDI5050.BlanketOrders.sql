SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE view [EDI5050].[BlanketOrders]
as
select
	oh.model_year
,	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = coalesce(nullif(es.parent_destination, ''), nullif(es.EDIShipToID, ''), es.destination)
,	AuxShipToCode = coalesce(nullif(es.EDIShipToID, es.parent_destination), '')
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = convert(bit, case when es.check_po ='Y' then 1 else 0 end)
,	CheckCustomerPOShipSchedule = coalesce(es.CheckCustomerPOFirm, 0)
,	ModelYear862 = coalesce(right(oh.model_year, 1), '')
,	ModelYear830 = coalesce(left(oh.model_year, 1), '')
,	CheckModelYearPlanning = convert(bit, case when es.check_model_year = 'Y' then 1 else 0 end)
,	CheckModelYearShipSchedule = 0
,	PartCode = oh.blanket_part
,	OrderUnit = oh.shipping_unit
,	LastSID = oh.shipper
,	LastShipDT = s.date_shipped
,	LastShipQty =
	(	select
			max(qty_packed)
		from
			dbo.shipper_detail
		where
			shipper = oh.shipper
			and order_no = oh.order_no
	)
,	PackageType = oh.package_type
,	UnitWeight = pi.unit_weight
,	AccumShipped = oh.our_cum
,	ProcessReleases = coalesce(es.ProcessEDI, 0)
,	ActiveOrder = convert(bit, case when oh.order_status = 'A' then 1 else 0 end)
,	ModelYear = oh.model_year
,	PlanningFlag = coalesce(es.PlanningReleasesFlag, 'A')
,	TransitDays = coalesce(es.TransitDays, 0)
,	ReleaseDueDTOffsetDays = coalesce(es.EDIOffsetDays, 0)
,	ReferenceAccum = coalesce(es.ReferenceAccum, 'O')
,	AdjustmentAccum = coalesce(es.AdjustmentAccum, 'C')
,	PlanningReleaseHorizonDaysBack = -1 * (coalesce(es.PlanningReleaseHorizonDaysBack, 30))
,	ShipScheduleHorizonDaysBack = -1 * (coalesce(es.ShipScheduleHorizonDaysBack, 30))
,	ProcessPlanningRelease = coalesce(es.ProcessPlanningRelease, 1)
,	ProcessShipSchedule = coalesce(es.ProcessShipSchedule, 1)
from
	dbo.order_header oh
	join dbo.edi_setups es
		on es.destination = oh.destination
	join dbo.part_inventory pi
		on pi.part = oh.blanket_part
	left join dbo.shipper s
		on s.id = oh.shipper
where
	oh.order_type = 'B'
	and coalesce(es.ProcessEDI, 1) = 1
GO
