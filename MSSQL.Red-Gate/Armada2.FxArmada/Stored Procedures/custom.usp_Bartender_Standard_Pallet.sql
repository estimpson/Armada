SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [custom].[usp_Bartender_Standard_Pallet]
	@Serial INT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	SELECT
		PalletSerial = oPallet.serial
	,	PalletSerialIrvin = RIGHT(('000000000' + CONVERT(VARCHAR, oPallet.serial)), 9)
	,	PalletSerialPaddedNineNines =  RIGHT(('999999999' + CONVERT(VARCHAR, oPallet.serial)), 9)
	,   LotNumber = oBox.lot
	,   MfgDate = CONVERT(VARCHAR(10), oPallet.last_date, 101)
	,	MfgDateMMM = UPPER(REPLACE(CONVERT(VARCHAR, oPallet.last_date, 106), ' ', ''))
	,   UM = oBox.unit_measure 
	,   Operator = oPallet.operator
	,	PalletNetWeight = 
		(	SELECT
				SUM(weight)
			FROM
				object
			WHERE
				parent_serial = oPallet.serial
		)
	,	PalletNetWeightKG =
		(	SELECT
				SUM(weight) / 2.2
			FROM
				object
			WHERE
				parent_serial = oPallet.serial
		)
	,	PalletGrossWeight = 
		(	SELECT
				SUM(object.weight + object.tare_weight)
			FROM
				object
			WHERE
				parent_serial = oPallet.serial
				OR serial = oPallet.serial
		)
	,	PalletGrossWeightKG = 
		(	SELECT
				SUM(object.weight + object.tare_weight) / 2.2
			FROM
				object
			WHERE
				parent_serial = oPallet.serial
				OR serial = oPallet.serial
		)
	,	PartCode = oBox.part
	,	PartName = pBox.name
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
	,	ECN = 
		(	SELECT
				MAX(engineering_level)
			FROM
				effective_change_notice
			WHERE
				part = oBox.part
				AND effective_date =
				(	SELECT
						MAX(effective_date)
					FROM
						effective_change_notice
					WHERE
						part = oBox.part
				)
		)
	,   CustomerPO = oh.customer_po
	,   CustomerPart = oh.customer_part
	,   CustomerName = c.name
	,   BillToCode = oh.customer
	,   ShipToCode = oh.destination
	,	SupplierCode = es.supplier_code
	,   ShipToName = d.name
	,   ShipToAddress1 = d.address_1
	,   ShipToAddress2 = d.address_2
	,   ShipToAddress3 = d.address_3
	,   ShipToAddress4 = d.address_4
	,	PoolCode = es.pool_code
	,	DockCode = oh.dock_code
	,	LineFeedCode = oh.line_feed_code
	,	ZoneCode = oh.zone_code
	,	Line11 = oh.line11
	,	Line12 = oh.line12
	,	Line13 = oh.line13
	,	Line14 = oh.line14
	,	Line15 = oh.line15
	,	Line16 = oh.line16
	,	Line17 = oh.line17
	,	Shipper = sd.shipper
	,	CompanyName = parm.company_name
	,	CompanyAddress1 = parm.address_1
	,	CompanyAddress2 = parm.address_2
	,	CompanyAddress3 = parm.address_3
	,	PhoneNumber = parm.phone_number
	FROM
		parameters parm
		CROSS JOIN object oPallet
		JOIN object oBox
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
			LEFT JOIN order_header oh
				LEFT JOIN customer c
					ON c.customer = oh.customer
				LEFT JOIN destination d
					ON d.destination = oh.destination
				LEFT JOIN edi_setups es
					ON es.destination = oh.destination
				ON oh.order_no = sd.order_no
			ON sd.shipper = oPallet.shipper
			AND sd.part_original = oBox.part
	WHERE
		oPallet.serial = @Serial
END
GO
