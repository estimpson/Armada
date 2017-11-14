SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





CREATE VIEW [EDIToyota].[BlanketOrders]
AS
SELECT
	BlanketOrderNo = oh.order_no
,	ShipToCode = oh.destination
,	EDIShipToCode = COALESCE(NULLIF(es.EDIShipToID,''), NULLIF(es.parent_destination,''), es.destination)
,	ShipToConsignee = es.pool_code
,	SupplierCode = es.supplier_code
,	Plant = oh.plant
,	CustomerPart = oh.customer_part
,	CustomerPO = oh.customer_po
,	CheckCustomerPOPlanning = CONVERT(BIT, CASE COALESCE(check_po, 'N') WHEN 'Y' THEN 1 ELSE 0 END)
,	CheckCustomerPOShipSchedule = COALESCE(CheckCustomerPOFirm, 0)
,	ModelYear862 = COALESCE(RIGHT(oh.model_year,1),'')
,	ModelYear830 = COALESCE(LEFT(oh.model_year,1),'')
,	CheckModelYearPlanning = CONVERT(BIT, CASE COALESCE(check_model_year, 'N') WHEN 'Y' THEN 1 ELSE 0 END)
,	CheckModelYearShipSchedule = 0
,	PartCode = oh.blanket_part
,	StandardPack = oh.standard_pack
,	OrderUnit = oh.shipping_unit
,	PackageMaterial = pmDef.name
,	LastSID = oh.shipper
,	LastShipDT = s.date_shipped
,	LastShipQty = (SELECT MAX(qty_packed) FROM dbo.shipper_detail WHERE shipper = oh.shipper AND order_no = oh.order_no)
,	PackageType = oh.package_type
,	UnitWeight = pi.unit_weight
,	AccumShipped = oh.our_cum
,	ProcessReleases = CONVERT (BIT, CASE WHEN COALESCE(es.release_flag, 'P') = 'F' THEN 1 ELSE 1 END)
,	ActiveOrder = CONVERT(BIT, CASE WHEN COALESCE(order_status,'') = 'A' THEN 1 ELSE 0 END )
,	ModelYear = oh.model_year
,	PlanningFlag= COALESCE(es.PlanningReleasesFlag,'A')
,	TransitDays = COALESCE(es.TransitDays,0)
,	ReleaseDueDTOffsetDays = COALESCE(es.EDIOffsetDays,0)
,	ReferenceAccum = COALESCE('N',ReferenceAccum,'O')
,	AdjustmentAccum = COALESCE('N',AdjustmentAccum,'C')
,	PlanningReleaseHorizonDaysBack = -1*(COALESCE(PlanningReleaseHorizonDaysBack,30))
,	ShipScheduleHorizonDaysBack = -1*(COALESCE(ShipScheduleHorizonDaysBack,30))
,	ProcessPlanningRelease = COALESCE(es.ProcessPlanningRelease,1)
,	ProcessShipSchedule = COALESCE(es.ProcessShipSchedule,1)
FROM
	dbo.order_header oh
	JOIN dbo.edi_setups es
		ON es.destination = oh.destination
	JOIN dbo.part_inventory pi
		ON pi.part = oh.blanket_part
	LEFT JOIN dbo.part_packaging ppDef
		JOIN dbo.package_materials pmDef
			ON pmDef.code = ppDef.code
		ON ppDef.part = oh.blanket_part
		AND ppDef.code =
			(	SELECT
					COALESCE(MAX(CASE WHEN pm.returnable = 'Y' THEN pp.code END), MAX(pp.code))
				FROM
					dbo.part_packaging pp
					JOIN dbo.package_materials pm
						ON pm.code = pp.code
				WHERE
					pp.part = oh.blanket_part
					AND pp.quantity = oh.standard_pack
			)
	LEFT JOIN dbo.shipper s
		ON s.id = oh.shipper
WHERE
	oh.order_type = 'B'
	AND	(es.trading_partner_code LIKE '%TMM%' OR Trading_partner_code LIKE '%TOYOTA%')





GO
