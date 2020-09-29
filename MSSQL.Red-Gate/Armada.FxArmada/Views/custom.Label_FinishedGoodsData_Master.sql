SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


-- Change Log
--
-- 06/05/2019 - added columns Ford2dPart, Ford2dPartFront0 - Craig D.





CREATE view [custom].[Label_FinishedGoodsData_Master]
as
select
	*
,	LabelDataCheckSum = binary_checksum(*)
from
	(	select
			Serial = oPallet.serial
		,	SerialTenDigitTesla = right(('0000000000' + convert(varchar, oPallet.serial)), 10)
		,	PalletSerialCooper = right(('000000000' + convert(varchar, oPallet.serial)), 9)
		,	InterPalletLicPlate= coalesce(sd.Customer_part, oh.Customer_part) +'S' + right(('999999999' + convert(varchar, opallet.serial)), 9) + 'Q' + convert(varchar(15), convert( int, (	select
					sum(std_quantity)
				from
					object
				where
					parent_serial = oPallet.serial
			)  ))
		,   LotNumber =  oBox.lot 
		,	LicensePlate = 'UN' + es.supplier_code + '' + convert(varchar, oPallet.serial) 
		--,   MfgDate = convert(varchar(10), oPallet.last_date, 101)  
		,   MfgDate = convert(varchar(10), coalesce((select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_date), 101)  
		--,	MfgDateMM = CONVERT(varchar(6), oPallet.last_time, 12) 
		,	MfgDateMM = convert(varchar(6), coalesce((select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 12) 
		--,	MfgDateMMM = UPPER(REPLACE(CONVERT(VARCHAR, oPallet.last_date, 106), ' ', '')) 
		,	MfgDateMMM = upper(replace(convert(varchar, coalesce((select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 106), ' ', '')) 
		--,	MfgDateMMMDashes = UPPER(REPLACE(CONVERT(VARCHAR, oPallet.last_time, 106), ' ', '-')) 
		,	MfgDateMMMDashes = upper(replace(convert(varchar, coalesce((select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 106), ' ', '-'))
		,	ShippedDate = coalesce(convert(varchar(10), sd.date_shipped, 101), convert(varchar(10), getdate(), 101))
		,	ShippedDateTesla = coalesce(convert(varchar(6), sd.date_shipped, 12), convert(varchar(6), getdate(), 12))
		,   UM =  oBox.unit_measure  
		--,   Operator = oPallet.operator
		,	PalletNetWeight = 
			(	select
					convert(numeric(10,2), round(sum(weight),2))
				from
					object
				where
					parent_serial = oPallet.serial
			) 
		,	PalletNetWeightKG =
			(	select
					convert(numeric(10,2), round(sum(weight) / 2.2,2))
				from
					object
				where
					parent_serial = oPallet.serial
			)
		,	PalletGrossWeight =
			(	select
					convert(numeric(10,2), round(sum(coalesce(object.weight, 0) + coalesce(object.tare_weight,0)),2))
				from
					object
				where
					parent_serial = oPallet.serial
					or serial = oPallet.serial
			) 
		,	PalletGrossWeightKG = 
			(	select
					convert(numeric(10,0), round(sum(coalesce(object.weight,0) + coalesce(object.tare_weight,0)) / 2.2,2))
				from
					object
				where
					parent_serial = oPallet.serial
					or serial = oPallet.serial
			) 
		,	PalletTareWeight = 
			(	select
					convert(numeric(10,2), round(sum(object.tare_weight),2))
				from
					object
				where
					parent_serial = oPallet.serial
					or serial = oPallet.serial
			) 
		,	PartCode =  oBox.part 
		,	WorkorderPartCode = mjl.PartCode 
		,	PartName =  pBox.name 
		--,	UDF1 = pcBox.user_defined_1
		,	PalletQty = 
			(	select
					sum(std_quantity)
				from
					object
				where
					parent_serial = oPallet.serial
			) 
		,	Boxes = 
			(	select
					count(*)
				from
					object
				where
					parent_serial = oPallet.serial
			) 
		,	BoxQty = oBox.std_quantity 
		,	ECN = oh.engineering_level
		--,	ECN = 
		--	(	SELECT 
		--			MAX(engineering_level)
		--		FROM
		--			effective_change_notice
		--		WHERE
		--			part = oBox.part
		--			AND effective_date =
		--			(	SELECT
		--					MAX(e.effective_date)
		--				FROM
		--					effective_change_notice e
		--				WHERE
		--					e.part = oBox.part
		--			)
		--	) 
		,   CustomerPO =  oh.customer_po 
		,   CustomerPart =  oh.customer_part
		,	Ford2dPart = replace(oh.customer_part, ' ', '')
		,	Ford2dPartFront0 = ltrim(oh.customer_part)
		--,   CustomerName = c.name
		--,   BillToCode = oh.customer
		,	Shipper = oBox.shipper
		,   ShipToCode = oh.destination 
		,	SupplierCode = es.supplier_code 
		,   ShipToName =  d.name 
		,   ShipToAddress1 =  d.address_1 
		,   ShipToAddress2 =  d.address_2 
		,   ShipToAddress3 = d.address_3 
		,   ShipToAddress4 = d.address_4 
		,	PoolCode = es.pool_code 
		,	DockCode =  oh.dock_code 
		,	LineFeedCode =  oh.line_feed_code 
		,	ZoneCode =  oh.zone_code 
		,	Line11 =  oh.line11  -- material handling code
		,	Line12 = oh.line12  --Plant/Dock on GM Master Label
		,	Line13 = oh.line13
		,	Line14 = oh.line14
		,	Line15 = oh.line15
		,	Line16 = oh.line16
		,	Line17 = oh.line17
		,	Location =  oPallet.location 
		,	ContainerType =  oPallet.package_type 
		,	CompanyName =  parm.company_name 
		,	CompanyAddress1 =  parm.address_1 
		,	CompanyAddress2 =  parm.address_2 
		,	CompanyAddress3 =  parm.address_3 
		,	PhoneNumber =  parm.phone_number
		,	EDISetupsMaterialIssuer = es.material_issuer
		,	SerialPaddedNineNines =  right(('999999999' + convert(varchar, oPallet.serial)), 9)
		,	SerialCooper =  right(('000000000' + convert(varchar, oPallet.serial)), 9)
		,	EDISetupsparentDestination = es.parent_destination
		,	MasterMixed =	case	
								when (select count(distinct part) from object where parent_serial = oPallet.serial) > 1 then 'MIXED PALLET'
								when  (select count(distinct part) from object where parent_serial = oPallet.serial) = 1 then 'MASTER LABEL'
								else 'GENERIC'
								end
							
		--,	PDF417MessageHeader = '[)>' + char(30)
		--,	PDF417FormatHeader = '06' + char(29)
		--,	PDF417RecordSeparator = char(30)
		--,	PDF417GroupSeparator = char(29)
		--,	PDF417FieldSeparator = char(28)
		--,	PDF417MessageTrailer = char(30) + char(04)
		,	OHAUCustPartDescription = oha.CustomerPartDescription
		,	OHAUCustom1 = oha.Custom1
		,	OHAUCustom2 = oha.Custom2
		,	TeslaLicensePlate =
				case when
					(	select
							count(distinct part)
						from
							dbo.object
						where
							parent_serial = oBox.parent_serial
					) > 1 then '5J'
					else '6J'
				end + 
				right('000000000' + es.supplier_code, 9) + 
				coalesce(convert(varchar(6), sd.date_shipped, 12), convert(varchar(6), getdate(), 12)) +
				--convert(varchar(6), getdate(), 12) + 
				right(('0000000000' + convert(varchar, oPallet.serial)), 10)
		,	TeslaPOline = lss.CustomerPOLine
		,	ReleaseNumber =  sd.release_no
		,	PalletLabelFormat = rl.NAME
		from
			parameters parm
			cross join OBJECT oPallet
			left join OBJECT oBox
				join part pBox
					on pBox.part = oBox.part
				left join part_characteristics pcBox
					on pcBox.part = oBox.part
				on oBox.parent_serial = oPallet.serial
				and oBox.serial =
				(	select
						min(serial)
					from
						object
					where
						parent_serial = oPallet.serial
				)
			left join shipper_detail sd
				on sd.shipper = coalesce(oBox.shipper, case when oBox.origin not like '%[^0-9]%' and len(oBox.origin) < 10 then convert (int, oBox.origin) end)
				and sd.part_original = oBox.part
			left join order_header oh
					left join customer c
						on c.customer = oh.customer
					left join destination d
						on d.destination = oh.destination
					left join edi_setups es
						on es.destination = oh.destination
				on oh.order_no = coalesce(sd.order_no, case when oBox.origin not like '%[^0-9]%' and len(oBox.origin) < 10 then convert (int, oBox.origin) end)
			
			left join custom.OrderHeaderAdditional oha
				on oha.OrderNo = oh.order_no
				
			left join EDI4010.LastShipSchedule lss
				on lss.ShipToCode = coalesce(es.ediShipToID, es.parent_destination)
				and lss.CustomerPart = oh.customer_part
			
			left join dbo.Mes_JobList mjl
				on mjl.WorkOrderNumber = oPallet.workorder
			join dbo.report_library rl on
				rl.name = coalesce(oh.pallet_label, 'PALLET')
	) rawLabelData








GO
