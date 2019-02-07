
/*
Create View.FxArmada.EDISUMMIT.BlanketOrders.sql
*/

use FxArmada
go

--drop table EDISUMMIT.BlanketOrders
if	objectproperty(object_id('EDISUMMIT.BlanketOrders'), 'IsView') = 1 begin
	drop view EDISUMMIT.BlanketOrders
end
go

create view EDISUMMIT.BlanketOrders
as
select
	oh.model_year
,	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = coalesce(nullif(es.EDIShipToID, ''), nullif(es.parent_destination, ''), es.destination)
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = convert(bit, case coalesce(check_po, 'N')when 'Y' then 1 else 0 end)
,	CheckCustomerPOShipSchedule = coalesce(CheckCustomerPOFirm, 0)
,	ModelYear862 = coalesce(right(oh.model_year, 1), '')
,	ModelYear830 = coalesce(left(oh.model_year, 1), '')
,	CheckModelYearPlanning = convert(bit, case coalesce(check_model_year, 'N')when 'Y' then 1 else 0 end)
,	CheckModelYearShipSchedule = 0
,	PartCode = oh.blanket_part
,	OrderUnit = oh.shipping_unit
,	LastSID = oh.shipper
,	LastShipDT = s.date_shipped
,	LastShipQty =
	(
		select
			max(qty_packed)
		from
			dbo.shipper_detail
		where
			shipper = oh.shipper
			and order_no = oh.order_no
	)
,	PackageType = oh.package_type
,	StandardPack = coalesce(pp.quantity, pi.standard_pack)
,	UnitWeight = pi.unit_weight
,	AccumShipped = oh.our_cum
,	ProcessReleases = coalesce(es.ProcessEDI, 0)
,	ActiveOrder = convert(bit, case when coalesce(order_status, '') = 'A' then 1 else 0 end)
,	ModelYear = oh.model_year
,	PlanningFlag = coalesce(es.PlanningReleasesFlag, 'A')
,	TransitDays = coalesce(es.TransitDays, 0)
,	ReleaseDueDTOffsetDays = coalesce(es.EDIOffsetDays, 0)
,	ReferenceAccum = coalesce(ReferenceAccum, 'O')
,	AdjustmentAccum = coalesce(AdjustmentAccum, 'C')
,	PlanningReleaseHorizonDaysBack = -1 * (coalesce(PlanningReleaseHorizonDaysBack, 30))
,	ShipScheduleHorizonDaysBack = -1 * (coalesce(ShipScheduleHorizonDaysBack, 30))
,	ProcessPlanningRelease = coalesce(es.ProcessPlanningRelease, 1)
,	ProcessShipSchedule = coalesce(es.ProcessShipSchedule, 1)
from
	dbo.order_header oh
	join dbo.edi_setups es
		on es.destination = oh.destination
	join dbo.part_inventory pi
		on pi.part = oh.blanket_part
	left join dbo.part_packaging pp
		on pp.part = oh.blanket_part
		and pp.code = oh.package_type
	left join dbo.shipper s
		on s.id = oh.shipper
where
	oh.order_type = 'B'
	and coalesce(ProcessEDI, 1) = 1
	--and es.InboundProcessGroup in ( 'EDI2001' )
	--and oh.customer_part = 'COM.0065'
	--and oh.destination = 'SUMSTU'
go

select
	*
from
	EDISUMMIT.BlanketOrders bo
where
	bo.PartCode = '10370'
	and bo.ShipToCode = 'SUMSTU'