SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE view [custom].[Label_FinishedGoodsData_Master]
as
select
	*
,	LabelDataCheckSum = binary_checksum(*)
from
	(	select
			Serial = oPallet.serial
		,	PalletSerialCooper = right(('000000000' + convert(varchar, oPallet.serial)), 9)
		,	InterPalletLicPlate= COALESCE(sd.Customer_part, oh.Customer_part) +'S' + RIGHT(('999999999' + CONVERT(VARCHAR, opallet.serial)), 9) + 'Q' + CONVERT(VARCHAR(15), CONVERT( INT, (	SELECT
					SUM(std_quantity)
				FROM
					object
				WHERE
					parent_serial = oPallet.serial
			)  ))
		,   LotNumber =  oBox.lot 
		,	LicensePlate = 'UN' + es.supplier_code + '' + convert(varchar, oPallet.serial) 
		--,   MfgDate = convert(varchar(10), oPallet.last_date, 101)  
		,   MfgDate = convert(varchar(10), COALESCE((Select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (Select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_date), 101)  
		--,	MfgDateMM = CONVERT(varchar(6), oPallet.last_time, 12) 
		,	MfgDateMM = CONVERT(varchar(6), COALESCE((Select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (Select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 12) 
		--,	MfgDateMMM = UPPER(REPLACE(CONVERT(VARCHAR, oPallet.last_date, 106), ' ', '')) 
		,	MfgDateMMM = UPPER(REPLACE(CONVERT(VARCHAR, COALESCE((Select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (Select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 106), ' ', '')) 
		--,	MfgDateMMMDashes = UPPER(REPLACE(CONVERT(VARCHAR, oPallet.last_time, 106), ' ', '-')) 
		,	MfgDateMMMDashes = UPPER(REPLACE(CONVERT(VARCHAR, COALESCE((Select max(date_stamp) from audit_trail where type in ('J', 'B') and Serial in (Select serial from object o2 where o2.parent_serial = oPallet.serial)),oPallet.last_time), 106), ' ', '-'))
		,   UM =  oBox.unit_measure  
		--,   Operator = oPallet.operator
		,	PalletNetWeight = 
			(	SELECT
					CONVERT(NUMERIC(10,2), ROUND(SUM(weight),2))
				FROM
					object
				WHERE
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
			(	SELECT
					CONVERT(NUMERIC(10,2), ROUND(SUM(COALESCE(object.weight, 0) + COALESCE(object.tare_weight,0)),2))
				FROM
					object
				WHERE
					parent_serial = oPallet.serial
					OR serial = oPallet.serial
			) 
		,	PalletGrossWeightKG = 
			(	SELECT
					CONVERT(NUMERIC(10,0), ROUND(SUM(COALESCE(object.weight,0) + COALESCE(object.tare_weight,0)) / 2.2,2))
				FROM
					object
				WHERE
					parent_serial = oPallet.serial
					OR serial = oPallet.serial
			) 
		,	PalletTareWeight = 
			(	SELECT
					CONVERT(NUMERIC(10,2), ROUND(SUM(object.tare_weight),2))
				FROM
					object
				WHERE
					parent_serial = oPallet.serial
					OR serial = oPallet.serial
			) 
		,	PartCode =  oBox.part 
		,	WorkorderPartCode = mjl.PartCode 
		,	PartName =  pBox.name 
		--,	UDF1 = pcBox.user_defined_1
		,	PalletQty = 
			(	SELECT
					SUM(std_quantity)
				FROM
					object
				WHERE
					parent_serial = oPallet.serial
			) 
		,	Boxes = 
			(	SELECT
					COUNT(*)
				FROM
					object
				WHERE
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
		,	SerialPaddedNineNines =  RIGHT(('999999999' + CONVERT(VARCHAR, oPallet.serial)), 9)
		,	SerialCooper =  RIGHT(('000000000' + CONVERT(VARCHAR, oPallet.serial)), 9)
		,	EDISetupsparentDestination = es.parent_destination
		,	MasterMixed =	CASE	
								WHEN (SELECT COUNT(DISTINCT part) FROM object WHERE parent_serial = oPallet.serial) > 1 THEN 'MIXED PALLET'
								WHEN  (SELECT COUNT(DISTINCT part) FROM object WHERE parent_serial = oPallet.serial) = 1 THEN 'MASTER LABEL'
								ELSE 'GENERIC'
								END
							
		--,	PDF417MessageHeader = '[)>' + char(30)
		--,	PDF417FormatHeader = '06' + char(29)
		--,	PDF417RecordSeparator = char(30)
		--,	PDF417GroupSeparator = char(29)
		--,	PDF417FieldSeparator = char(28)
		--,	PDF417MessageTrailer = char(30) + char(04)
		,	PalletLabelFormat = rl.NAME
		FROM
			parameters parm
			CROSS JOIN OBJECT oPallet
			LEFT JOIN OBJECT oBox
				JOIN part pBox
					ON pBox.part = oBox.part
				LEFT JOIN part_characteristics pcBox
					ON pcBox.part = oBox.part
				ON oBox.parent_serial = oPallet.serial
				AND oBox.serial =
				(	SELECT
						MIN(serial)
					FROM
						object
					WHERE
						parent_serial = oPallet.serial
				)
			LEFT JOIN shipper_detail sd
				ON sd.shipper = COALESCE(oBox.shipper, CASE WHEN oBox.origin NOT LIKE '%[^0-9]%' AND LEN(oBox.origin) < 10 THEN CONVERT (INT, oBox.origin) END)
				AND sd.part_original = oBox.part
			LEFT JOIN order_header oh
					LEFT JOIN customer c
						ON c.customer = oh.customer
					LEFT JOIN destination d
						ON d.destination = oh.destination
					LEFT JOIN edi_setups es
						ON es.destination = oh.destination
				ON oh.order_no = COALESCE(sd.order_no, CASE WHEN oBox.origin NOT LIKE '%[^0-9]%' AND LEN(oBox.origin) < 10 THEN CONVERT (INT, oBox.origin) END)
			LEFT JOIN dbo.Mes_JobList mjl
				ON mjl.WorkOrderNumber = oPallet.workorder
			JOIN dbo.report_library rl ON
				rl.name = COALESCE(oh.pallet_label, 'PALLET')
	) rawLabelData




GO
