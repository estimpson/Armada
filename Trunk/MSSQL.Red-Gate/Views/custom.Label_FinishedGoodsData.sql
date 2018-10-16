SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO






CREATE view [custom].[Label_FinishedGoodsData]
as
select
	*
,	LabelDataCheckSum = binary_checksum(*)
from
	(	select
		--	Fields on every label    
			Serial = o.serial
		,	Quantity = convert (int, o.quantity)
		,	CustomerPart = oh.customer_part
		,	CompanyName = param.company_name
		,	CompanyAddress1 = param.address_1
		,	CompanyAddress2 = param.address_2
		,	CompanyAddress3 = param.address_3
		,	CompanyPhoneNumber = param.phone_number
		--	Fields on some labels ...
		,	CustPartRemove0 = replace(ltrim(replace(oh.customer_part, '0', ' ')), ' ', '0')
		,	LicensePlate = 'UN' + es.supplier_code + '' + convert(varchar, o.serial) 
		,	SerialThreeDigitTesla = convert(char(3), right(o.serial, 3))
		,	SerialTenDigitTesla = right(('0000000000' + convert(varchar, o.serial)), 10)
		,	SerialCooper =  right(('000000000' + convert(varchar, o.serial)), 9)
		,	SerialPaddedNineNines =  right(('999999999' + convert(varchar, o.serial)), 9)
		,	EDISetupsparentDestination = es.parent_destination
		,	EDISetupsMaterialIssuer = es.material_issuer
		,	InterBoxLicPlate= coalesce(sd.Customer_part, oh.Customer_part) +'S' + right(('999999999' + convert(varchar, o.serial)), 9) + 'Q' + convert(varchar(15), convert( int, o.quantity ))
		,	TELFBoxLicPlate = 'ZZ' + es.supplier_code + right(('0000000000' + convert(varchar(15), o.serial)), 10)
		,	PartNumber = o.part
		,	UnitOfMeasure =  o.unit_measure
		,	Location = o.location
		,	Lot = o.lot
		,	Operator = o.operator
		,	MfgDate = convert(varchar(10), o.last_date, 101)
		,	MfgTime = convert(varchar(5), o.last_date, 108)
		,	ThreeDigitDate = FT.fn_GetThreeDigitDate(coalesce(s.date_stamp, getdate()) )
		,	ShippedDate = coalesce(convert(varchar(10), s.date_stamp, 101), convert(varchar(10), getdate(), 101))
		--,	MfgDateMM = case when rl.name in ('Ford_Part Container') then convert(varchar(6), o.last_time, 12) end
		,	MfgDateMMM = upper(replace(convert(varchar, o.last_time, 106), ' ', ''))
		,	MfgDateMMMDashes = upper(replace(convert(varchar, o.last_time, 106), ' ', '-'))
		,	GrossWeight = convert(numeric(10,2), round(o.weight + o.tare_weight, 2))
		,	GrossWeightKilograms = convert(numeric(10,0),((o.weight + o.tare_weight) / 2.2))
		,	NetWeightKilograms = convert(numeric(10,0),((o.weight) / 2.2))
		,	NetWeight = convert(numeric(10,2), round(o.weight,2))
		,	TareWeight = convert(numeric(10,2), round(o.tare_weight,2))
		,	StagedObjects = s.staged_objs
--		,	Origin = o.origin
		,	PackageType = o.package_type
		,	PartName = p.name
--		,	Customer = oh.customer
		,	DockCode =  oh.dock_code
		,	ZoneCode = oh.zone_code
		,	LineFeedCode = oh.line_feed_code
		,	Line11 = oh.line11 -- Material Handling Code
		,	Line12 = oh.line12  --Plant/Dock on GM Label
		,	Line13 = oh.line13
		,	Line14 = oh.line14
		,	Line15 = oh.line15
		,	Line16 = oh.line16
		,	Line17 = oh.line17
		,	BTM = oh.contact
		,	SupplierCode = es.supplier_code
		,	MaterialIssuer = es.material_issuer
		,	Shipper = sd.shipper
		,	CustomerPO =  sd.customer_po
		,	EngineeringLevel =  oh.engineering_level
		,	Destination = oh.destination
		,	DestinationName = d.name
		,	DestinationAddress1 = d.address_1
		,	DestinationAddress2 = d.address_2
		,	DestinationAddress3 = d.address_3
		,	DestinationAddress4 = d.address_4
		,	ObjectKANBAN = coalesce(o.kanban_number, '') 
		,	ObjectCustom5 = coalesce(o.custom5, '')
		,	ShipToID = coalesce(es.ediShipToID, es.parent_destination)
		,	PO_or_Release =  
				case
				when nullif(sd.customer_po,'') is null
				then sd.release_no 
				else sd.customer_po 
				end
				
		,	ReleaseNumber =  sd.release_no
		,	ShipperDateStamp = s.date_stamp
		,	DecoPlasBarcode = 'A'+oh.customer_part +'  '+'00'+convert(varchar(15), convert(int, o.quantity))+'.000'+'EA'+'A'+convert(varchar(15),o.serial)
		,	OHCustom01 = oh.custom01
		,	OHcustom02 = oh.custom02
		,	OHCustom03 = oh.custom03
		,	OHAUCustPartDescription = oha.CustomerPartDescription
		,	OHAUCustom1 = oha.Custom1
		,	OHAUCustom2 = oha.Custom2
		,	TeslaShipDate = coalesce(convert(varchar(8), s.date_stamp, 112), convert(varchar(8), getdate(), 112) ) -- YYYYMMDD
		,	TeslaQuantity = right('000000' + convert(varchar(6), convert(int, o.quantity) ), 6 )
		,	TeslaCustomerPart = right('0000000000' + replace(replace(oh.customer_part, '-', ''), ' ', ''), 10 )
		,	TeslaContentLabelId = 
				'3S' + 
				'AVJ' + 
				right('000000' + convert(varchar(6), convert(int, o.quantity) ), 6 ) +
				convert(char(3), right(o.serial, 3) ) +
				FT.fn_GetThreeDigitDate(coalesce(o.last_date, getdate()) ) +
				right('0000000000' + replace(replace(oh.customer_part, '-', ''), ' ', ''), 10 )
		,	TeslaPOline = lss.CustomerPOLine
		--,	DateTimeZoneDue = CASE WHEN rl.NAME IN ('MITSUBISHI_RAN') THEN mran.date_time_zone_due END
		--,	RevLevel = CASE WHEN rl.NAME IN ('MITSUBISHI_RAN') THEN oh.engineering_level END 
		--	Make sure we printed the correct label format.
		,	BoxLabelFormat = rl.NAME
		from
			dbo.OBJECT o
			left join (select max(engineering_level) as engineering_level, part as ecn_part from dbo.effective_change_notice group by part) ecn on
				ecn.ecn_part = o.part
			left join dbo.shipper s
				join dbo.shipper_detail sd
					on sd.shipper = s.id
				on s.id = coalesce(o.shipper, case when o.origin not like '%[^0-9]%' and len(o.origin) < 10 then convert (int, o.origin) end)
				and sd.part_original = o.part
			left join dbo.order_header oh on
				oh.order_no = coalesce(sd.order_no, case when o.origin not like '%[^0-9]%' and len(o.origin) < 10 then convert(int, o.origin) end)
				and oh.blanket_part = o.part
			left join custom.OrderHeaderAdditional oha
				on oha.OrderNo = oh.order_no
			left join dbo.destination d on
				d.destination = coalesce(s.destination, oh.destination, o.destination)
			left join dbo.edi_setups es on
				es.destination = coalesce(s.destination, oh.destination, o.destination)
			--LEFT JOIN (SELECT MAX(CONVERT(VARCHAR(10),PickUpDT,105)) AS date_time_zone_due, RAN FROM EDIMitsubishi.RanDetails GROUP BY RAN) mran ON
			--	mran.RAN = o.custom1
			left join EDI4010.LastShipSchedule lss
				on lss.ShipToCode = coalesce(es.ediShipToID, es.parent_destination)
				and lss.CustomerPart = oh.customer_part
			join dbo.part p on
				p.part = o.part
			join dbo.part_inventory pi on
				pi.part = p.part
			join dbo.report_library rl on
				rl.name = coalesce(oh.box_label, pi.label_format)
			cross join dbo.parameters param
	) rawLabelData


	












GO
