SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>

-- Change Log
-- 06/05/2019 - added columns Ford2dPart, Ford2dPartFront0 - Craig D.
-- =============================================
CREATE procedure [custom].[usp_Bartender_Standard]
	@Serial int
as
begin
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	select   
		Serial = o.serial
	,	Quantity = convert (int, o.quantity)
	,	CustomerPart = oh.customer_part
	,	Ford2dPart = replace(oh.customer_part, ' ', '')
	,	Ford2dPartFront0 = ltrim(oh.customer_part)
	,	CompanyName = param.company_name
	,	CompanyAddress1 = param.address_1
	,	CompanyAddress2 = param.address_2
	,	CompanyAddress3 = param.address_3
	,	CompanyPhoneNumber = param.phone_number
	,	PartNumber = o.part
	,	UnitOfMeasure = o.unit_measure
	,	Location = o.location
	,	Lot = o.lot
	,	Operator = o.operator
	,	MfgDate = convert(varchar(10), o.last_date, 101)
	,	MfgTime = convert(varchar(5), o.last_date, 108)
	,	MfgDateMMM = upper(replace(convert(varchar, o.last_time, 106), ' ', ''))
	,	GrossWeight = convert(numeric(10,2), round(s.gross_weight,2))
	,	GrossWeightKilograms = convert(numeric(10,2),((o.weight + o.tare_weight) / 2.2))
	,	NetWeight = convert(numeric(10,2), round(o.weight,2))
	,	TareWeight = o.tare_weight
	,	StagedObjects = s.staged_objs
--	,	Origin = o.origin
	,	PackageType = o.package_type
	,	PartName = p.description_short
	,	Customer = oh.customer
	,	DockCode = oh.dock_code
	,	ZoneCode = oh.zone_code
	,	LineFeedCode = oh.line_feed_code
	,	Line11 = oh.line11
	,	Line12 = oh.line12
	,	Line13 = oh.line13
	,	Line14 = oh.line14
	,	Line15 = oh.line15
	,	Line16 = oh.line16
	,	Line17 = oh.line17
	,	Custom01 = oh.custom01
	,	Custom02 = oh.custom02
	,	Custom03 = oh.custom03
	,	SupplierCode = es.supplier_code
	,	Shipper = sd.shipper
	,	CustomerPO = sd.customer_po
	,	EngineeringLevel = ecn.engineering_level
	,	Destination = oh.destination
	,	DestinationName = d.name
	,	DestinationAddress1 = d.address_1
	,	DestinationAddress2 = d.address_2
	,	DestinationAddress3 = d.address_3
	,	DestinationAddress4 = d.address_4
	from
		object o
		join dbo.shipper s
			on s.id = o.shipper
		join dbo.shipper_detail sd
			on (sd.shipper = o.shipper or convert(varchar(25), sd.shipper) = o.origin)
			and sd.part_original = o.part
		join dbo.order_header oh
			on oh.order_no = sd.order_no
		join dbo.destination d
			on d.destination = s.destination
		left join dbo.edi_setups es
			on es.destination = s.destination
		left join (select max(engineering_level) as engineering_level, part as ecn_part from dbo.effective_change_notice group by part) ecn on
				ecn.ecn_part = o.part
		join dbo.part p
			on p.part = o.part
		cross join dbo.parameters param
	where
		o.serial = @Serial
end
GO
