SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_EDIShipNotice_Tesla]  (@shipper INT)
AS
BEGIN
-- Test
-- Exec [dbo].[usp_EDIShipNotice_Tesla] 346271

/*

SP returns both ASN flat file and Invoice Flat File
   
  
    856 Overlay: TLO_856_D_v4010_TESLA SOTPI-PI_160707   

    810 Overlay : TMO_810_D_v4010_TESLA MOTORS_160203



*/

SET ANSI_PADDING ON
--ASN Header

DECLARE
--Variables for Flat File


--//Line
		@TradingPartner	CHAR(12),
		@DESADV CHAR(10),
		@ShipperIDHeader CHAR(30),
		@PartialComplete CHAR(1) = '' ,

--Header

		@1BSN01_Purpose CHAR(2) = '00',										-- Purpose Code
		@1BSN02_ShipperID CHAR(30),											--Shipper.id
		@1BSN03_SystemDate CHAR(8),											--Getdate() 'CCYYMMDD'
		@1BSN04_SystemTime CHAR(8),											--Getdate() 'HHMM'

		
		@1MEA01_PDQualifier CHAR(2) = 'PD',															
		@1MEA02_GrossWeightQualifier CHAR(3) = 'G',			--
		@1MEA03_Grossweight CHAR(22),										--shipper.gross_weight
		@1MEA02_NetWeightQualifier CHAR(3) = 'N',				--
		@1MEA03_Netweight CHAR(22),											--shipper.net_weight
		@1MEA04_WeightUOM CHAR(2) = 'LB',		

	
		@1TD101_PackCodeCNT90 CHAR(5) = 'BOX90',				--Loose Container Indicator
		@1TD102_PackCountCNT90 CHAR(8),								--count(1) of loose objects
		@1TD101_PackCodePLT90 CHAR(5) = 'PLT90',				--Pallet Indicator
		@1TD102_PackCountPLT90 CHAR(8)	,							--count(1) of distinct pallets


		@1TD501_RoutingSequence CHAR(1) = 'B'	,					--Routing Sequence Code; appears to be B for all shipments
		@1TD502_IdCodeType CHAR(2) = '2'	,							--'2'
		@1TD503_CarrierSCAC CHAR(78)	,								--shipper.carrier
		@1TD504_ShipperTransMode CHAR(2)	,						--shipper.trans_mode

		@1TD301_EquipmentDesc CHAR(2) = 'TL',						--'TL'
		@1TD303_EquipmentNumber CHAR(10),							--shipper.truck_number

		@REF02_ProNumberQualifier CHAR(3)  = 'CN',			--Tesla wants  pro  number here
		@REF02_ProNumber CHAR(30),									--Tesla wants Pro number
		@REF02_BillofLadingQualifier CHAR(3)  = 'BM',		--Tesla wants trailer number here
		@REF02_BillofLading CHAR(30),									--Tesla wants trailer number here

		@1DTM01_DateShippedQualifier CHAR(3) = '011',				--date shipped qualifier "011"
		@1DTM02_DateShipped CHAR(8),										--shipper.date_shipped 'CCYYMMDD'
		@1DTM03_TimeShipped CHAR(8),										--shipper.date_shipped 'HHMM'
		@1DTM04_TimeZone CHAR(2),												-- dbo.udfGetDSTIndication(date_shipped) returns either 'ED' or 'ET'
		

		@1N103_ShipFromQualifier CHAR(3) = 'SF',
		@1N104_ShipFromCode CHAR(78),
		@1N103_ShipFromName CHAR(60),
		@1N103_ShipFromAddress CHAR(55),

		@1N103_ShiptoQualifier CHAR(3) = 'ST',
		@1N104_ShiptoCode CHAR(78),
		@1N103_ShiptoName CHAR(60),
		@1N103_ShiptoAddress CHAR(55)
		
		SELECT @REF02_ProNumber =  ISNULL(MAX(release_no),'')
		FROM
			Shipper_detail sd
		WHERE 
			sd.shipper = @shipper 
			AND			sd.release_no LIKE '%-%'
		

		
	SELECT
		@TradingPartner	= COALESCE(NULLIF(es.trading_partner_code,''), 'Tesla'),
		@1BSN02_ShipperID  =  s.id,
		@1BSN03_SystemDate = CONVERT(VARCHAR(25), GETDATE(), 112)+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2),
		@1BSN04_SystemTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@1MEA03_Grossweight = convert(int, s.gross_weight),
		@1MEA03_Netweight = convert(int, s.net_weight),
		@1TD102_PackCountCNT90 = convert(int , s.staged_objs),
		@1TD503_CarrierSCAC = Coalesce(s.ship_via,''),
		@1TD504_ShipperTransMode = coalesce(s.trans_mode, 'LT'),
		@1TD303_EquipmentNumber = Coalesce(s.truck_number, convert(varchar(15),s.id)),
		@REF02_BillofLading = coalesce(convert(varchar(15),s.bill_of_lading_number), convert(varchar(15),s.id)),				
		@1TD504_ShipperTransMode = coalesce(s.trans_mode, 'LT'),
		@1TD503_CarrierSCAC = Coalesce(s.ship_via,''),
		@1DTM02_DateShipped= CONVERT(VARCHAR(25), s.date_shipped, 112)+LEFT(CONVERT(VARCHAR(25), s.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), s.date_shipped, 108),4,2),
		@1DTM03_TimeShipped = left(replace(convert(char, s.date_shipped, 108), ':', ''),4),
		@1DTM04_TimeZone = dbo.udfGetDSTIndication(date_shipped),
		@1N104_ShipFromCode = coalesce(es.supplier_code,''),
		@1N103_ShipFromAddress = parms.address_1 ,
		@1N103_ShipFromName = parms.company_name,
		@1N104_ShiptoCode  =  coalesce(NULLIF(es.ediShipToID,'') , Nullif(es.parent_destination,'') ,es.destination),
		@1N103_ShiptoName = d.name
	from
		Shipper s
	JOIN
		dbo.edi_setups es on s.destination = es.destination
	JOIN
		dbo.destination d on es.destination = d.destination
	JOIN
		dbo.customer c on c.customer = s.customer
	CROSS APPLY 
	 dbo.parameters parms  
	
	where
		s.id = @shipper


Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(78) )

INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//856'
						+  @TradingPartner 
						+  @1BSN02_ShipperID
						+ 'P')
						--+  @PartialComplete )


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+		@1BSN01_Purpose
				+		@1BSN02_ShipperID
				+		@1BSN03_SystemDate
				+		@1BSN04_SystemTime
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'02'
				+		@1MEA01_PDQualifier
				+		@1MEA02_GrossWeightQualifier
				+		@1MEA03_Grossweight
				+		@1MEA04_WeightUOM
						)

INSERT	#ASNFlatFile (LineData)
		SELECT	(	'02'
				+		@1MEA01_PDQualifier
				+		@1MEA02_NetWeightQualifier
				+		@1MEA03_Netweight
				+		@1MEA04_WeightUOM
						)


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @1TD101_PackCodeCNT90
				+ @1TD102_PackCountCNT90		
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+		@1TD503_CarrierSCAC
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'05'
				+		@1TD504_ShipperTransMode
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+		@REF02_BillofLadingQualifier
				+		@REF02_BillofLading
						)
INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+		@REF02_ProNumberQualifier
				+		@REF02_ProNumber
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'08'
				+		@1DTM01_DateShippedQualifier
				+		@1DTM02_DateShipped
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'09'
				+		@1N103_ShiptoQualifier
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'10'
				+		@1N104_ShiptoCode
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'11'
				+		@1N103_ShiptoName
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'09'
				+		@1N103_ShipFromQualifier
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'10'
				+		@1N104_ShipFromCode
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'11'
				+		@1N103_ShipFromName
						)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'12'
				+		@1N103_ShipFromAddress
						)


 --ASN Detail 

Declare
		@2CPS01CPSCounter char(12),
		@2CPS03CPSIndicator char(3),
		@1PAC01PackageCount char(10),
		@1PAC01PackageType char(17),
		@1PCI01MarkingInstructions char(3),
		@3RFF010ProNumber char(35),
		@1LIN01LineItem char(20) = '001',
		@1LIN02CustomerPartBP char(2) = 'BP',
		@1LIN03CustomerPart char(30),
		@1LIN04KanbanRC char(2) = 'RC',
		@1LIN05Kanban char(30),
		@1SN102QtyShipped char(12),
		@1SN103QtyShippedUM char(2) ='EA',
		@1PIAModelYear char(35),
		@2QTY010QtyTypeShipped char(3) ,
		@2QTY010QtyShipped char(14),
		@2QTY010QtyShippedUM char(3) ,
		@2QTY010AccumTypeShipped char(3) ,
		@2QTY010AccumShipped char(14),
		@2QTY010AccumShippedUM char(3),
		@1RFF010CustomerPOType char(3),
		@1RFF010CustomerPO char(25),
		@2REF02InvoiceNumber char(30),
		@1PRF01ManifestReceiverNo char(22),


	--Variables for Processing Data

	@PackTypeType int,
	@InternalPart varchar(25),
	@PackageType varchar(25),
	@PalletPackageType varchar(25),
	@CPS03Indicator int





declare	@ShipperDetail table (
	ID int identity(1,1),
	CustomerPart varchar(30),
	CustomerPO varchar(22),
	PODate VARCHAR(15),
	CustomerPOLine VARCHAR(30),
	SerialQty INT,
	QtyShipped INT
	PRIMARY key (ID))
	
insert	@ShipperDetail 
(	CustomerPart,
	CustomerPO,
	PODate,
	CustomerPOLine,
	SerialQty,
	QtyShipped
	)
	
SELECT
	distinct
	sd.customer_part,
	sd.customer_po,
	MIN(	CONVERT(VARCHAR(8), oh.order_date, 112)),
	MIN(COALESCE(NULLIF(lss.cpl, ''), '99999')),
	--COALESCE(NULLIF(MIN(oh.engineering_level),''), '001'),
	at.quantity,
	sum(at.quantity)
from
	shipper s
JOIN
	edi_setups es ON es.destination = s.destination
join
	shipper_detail sd ON sd.shipper = s.id
JOIN
	dbo.order_header oh ON oh.order_no =  sd.order_no
JOIN
	dbo.audit_trail at ON at.shipper = CONVERT(VARCHAR(50), @shipper )  
	AND	at.part = sd.part_original
	AND at.type = 'S'
OUTER APPLY 
	( 
		SELECT 
			TOP 1 lss.CustomerPOLine cpl
			FROM 
				edi4010.LastShipSchedule lss
			WHERE lss.fxDestination = s.destination
			AND		lss.CustomerPart = sd.customer_part	) AS lss
Where
	s.id = @shipper
GROUP BY
	sd.customer_po,
	sd.customer_part,
	at.quantity
	
	
declare	@AuditTrailSerial table (
CustomerPart varchar(25),
CustomerPO varchar(50),
SerialQuantity int,
Serial VARCHAR(50), 
id int identity primary key (id))
	
insert	@AuditTrailSerial 
(		CustomerPart,
		CustomerPO,		
		SerialQuantity,
		Serial 
)
	
select
	sd.customer_part,
	sd.customer_po,
	quantity,
	'1J0053702040'+ REPLACE(CONVERT(VARCHAR(10), sd.date_shipped, 1), '/', '') + RIGHT(CONVERT(VARCHAR(25), serial),3)
from
	dbo.audit_trail at
JOIN
	shipper_detail sd ON sd.part_original = at.part 
	AND sd.shipper = @shipper
Where
	at.shipper = convert(varchar(25),@shipper) and
	at.type = 'S' 
order by			1, 
						3



	/*
	Select * From @ShipperDetail
	SELECT * FROM @AuditTrailSerial
	Select * From @AuditTrailLooseSerial
	Select * From @AuditTrailPartPackGroupRangeID
	Select * From @AuditTrailPartPackGroup
	Select * From @AuditTrailPartPackGroupSerialRange
*/


--Delcare Variables for ASN Details		

declare	
	@LineItemID char(6),
	@REF02_PalletSerial char(2),
	@PAL01_PalletPackType char(78),
	@PAL02_PalletTiers char(4),
	@PAL03_PalletBlocks char(4),
	@PAL05_PalletTareWeight char(10),
	@PAL06_PalletTareWeightUM char(2),
	@PAL07_Length char(10),
	@PAL08_Width char(10),
	@PAL09_Height char(10),
	@PAL10_DimUM char(2),
	@PAL11_PalletGrossWeight char(10),
	@PAL12_PalletGrossWeightUM char(2),
	@LIN02_BPIDtype char(2) = 'BP',
	@LIN02_CustomerPart char(48) ,
	@LIN02_VPIDtype char(2) = 'VP',
	@LIN02_VendorPart char(48) ,
	@LIN02_PDIDtype char(2) = 'PD',
	@LIN02_PartDescription char(48) ,
	@LIN02_POIDtype char(2) = 'PD',
	@LIN02_CustomerPO char(48) ,
	@LIN02_CHIDtype char(2) = 'CH',
	@LIN02_CountryOfOrigin char(48) = 'HN' ,
	@SerialQty Int,
	@SN102_QuantityShipped char(12),
	@SN103_QuantityShippedUM char(2) = 'EA',
	@SN104_AccumQuantityShipped char(17),
	@REF01_PKIDType char(3),
	@REF02_PackingSlipID char(78),
	@REF03_PackingSlipDescription char(78),
	@REF01_IVIDType char(3) = 'IV',
	@REF02_InvoiceIDID char(78),
	@CLD01_LoadCount char(6),
	@CLD02_PackQuantity char(12),
	@CLD03_PackCode char(5),
	@CLD04_PackGrossWeight char(10),
	@CLD05_PackGrossWeightUM char(2) = 'LB',
	@REF02_ObjectSerial char(78) ,
	@REF04_ObjectLot char(78) ,
	@DTM02_ObjectLot char(78) ,
	@Part varchar(50),
	@SupplierPart char(35),
	@SupplierPartQual char(3),
	@CountryOfOrigin char(3),
	@PartQty char(12),
	@PartAccum char(12),
	@PartUM char(3),
	@CustomerPart varchar(50),
	@CustomerPO varchar(50),
	@CustomerPOFF char(22),
	@CustomerPODate VARCHAR(8),
	@CustomerPODateFF char(8),
	@CustomerPOLineNoFF char(20),
	@CustomerECL char(35),
	@CustomerECLQual char(3),
	@DunnagePackType char(17),
	@DunnageCount char(10),
	@DunnageIdentifier char(3),
	@PartPackQty char(17),
	@PartPackCount char(10),
	@PCIQualifier char(3),
	@Serial char(20),
	@DockCode char(25),
	@PCI_S char(3),
	@PCI_M char(3),
	@MAN02SupplierSerial char(48),
	@CPS03 Char(3),
	@UM char(3)
	 
 
	
 Declare
		PONumber cursor local for

Select
		SD.CustomerPO,
		MIN(SD.PODate),
		MIN(SD.PODate)
From
		@ShipperDetail SD
	GROUP BY
	SD.CustomerPO


open
	PONumber

while
	1 = 1 begin
	
	fetch
		PONumber
	into
		@CustomerPO,
		@CustomerPODate,
		@CustomerPODateFF

		if	@@FETCH_STATUS != 0 begin
		break
	end
		Select @CustomerPOFF = @CustomerPO
		--PRINT @CustomerPOFF
				Insert	#ASNFlatFile (LineData)
					Select  '15' 									
							+ @CustomerPOFF
							+ @CustomerPODateFF

	
declare
	CustomerpartQtyPerPO cursor local for
select
	CustomerPart = customerpart,
	CustomerPOLine = CustomerPOLine,
	AtQuantity =  SD.SerialQty,
	QtyShipped = QtyShipped
From
	@ShipperDetail SD
where
	SD.CustomerPO = @CustomerPO
	--AND SD.PODate = @CustomerPODate
	

open
	CustomerpartQtyPerPO

while
	1 = 1 BEGIN
	
	fetch
		CustomerpartQtyPerPO
	into
		@CustomerPart,
		@CustomerPOLineNoFF,
		@SerialQty,
		@SN102_QuantityShipped

		if	@@FETCH_STATUS != 0 begin
		break
		END 

	

				declare
				SerialsPerPOCustomerpartQty cursor local for
				select
					serial = Serial
				From
					@AuditTrailSerial AT
					where
						AT.CustomerPO = @CustomerPO
						AND AT.Customerpart = @Customerpart
						AND AT.SerialQuantity = @SerialQty
	

					open
						SerialsPerPOCustomerpartQty
					while
					1 = 1 begin	
					fetch
						SerialsPerPOCustomerpartQty
					into
						@MAN02SupplierSerial
			
					if	@@FETCH_STATUS != 0 begin
					break
					end

					INSERT	#ASNFlatFile (LineData)
					SELECT  '23' 									
							+ 'GM'
							+ @MAN02SupplierSerial
					END
					
		
close
	SerialsPerPOCustomerpartQty

		SELECT @LIN02_CustomerPart = @CustomerPart
			INSERT	#ASNFlatFile (LineData)
					Select  '24' 									
							+ @CustomerPOLineNoFF
							+ @1LIN02CustomerPartBP
							+ @LIN02_CustomerPart
			Insert	#ASNFlatFile (LineData)
					Select  '26' 									
							+ SPACE(48)
							+ @SN102_QuantityShipped
							+ @SN103_QuantityShippedUM
		
 
DEALLOCATE
	SerialsPerPOCustomerpartQty	

END
CLOSE
	CustomerpartQtyPerPO
 
DEALLOCATE
	CustomerpartQtyPerPO

END
close
	PONumber
 
deallocate
	PONumber


    


--Get 810 data





--Declare Variables for 810 Flat File

DECLARE @1BIG01InvoiceDate CHAR(8),
				 @1BIG01PODate CHAR(8),
				@1BIG02InvoiceNumber CHAR(22),
				@PackingList CHAR(30),
				@BuyersAgent CHAR(78) = '111267',
				@AssignedID CHAR(20),
				@1IT01KanbanCard CHAR(4),
				@1IT102QtyInvoiced CHAR(12), 
				@1IT104UnitPrice CHAR(19),
				@1IT102QtyInvoicedNumeric NUMERIC(20,6), 
				@1IT104UnitPriceNumeric NUMERIC(20,6),
				@1IT105BasisOfUnitPrice CHAR(2) = 'QT',
				@1IT106PartQualifier CHAR(2) = 'PN',
				@1IT107CustomerPart CHAR(48),
				@1IT1CustomerPO CHAR(48),
				@1IT108PackageDrawingQual CHAR(2) = 'PK',
				@1IT109PackageDrawing CHAR(12) = '1',
				@1IT110 CHAR(2) = 'ZZ', 
				@1IT111 CHAR(12),
				@1REF01MKQualifier CHAR(2) = 'MK',
				@1REF02Manifest CHAR(30),
				@1DTM02PickUpDate CHAR(8),
				@1TDS01InvoiceAmount CHAR(17),
				@PartNumber VARCHAR(25),
				@ISSUnits CHAR(12),
				@ISSWeight CHAR(12)

SELECT
		
		@1BIG01InvoiceDate= CONVERT(VARCHAR(25), s.date_shipped, 112)/*+LEFT(CONVERT(VARCHAR(25), s.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), s.date_shipped, 108),4,2)*/,		
		@1BIG02InvoiceNumber = s.id,
		@PackingList = s.id,
		@1BIG01PODate =  
			( SELECT MIN(CONVERT(VARCHAR(8), oh.order_date, 112))
				FROM order_header oh 
				JOIN		shipper_detail sd ON oh.order_no = sd.order_no 
				AND		sd.shipper = @shipper )

		


	FROM
		Shipper s
	JOIN
		dbo.edi_setups es ON s.destination = es.destination
	JOIN
		dbo.destination d ON es.destination = d.destination
	JOIN
		dbo.customer c ON c.customer = s.customer
	
	WHERE
		s.id = @shipper


DECLARE	@InvoiceDetail TABLE (
	PartNumber VARCHAR(25),
	CustomerPart VARCHAR(50),
	CustomerPO VARCHAR(50),
	CustomerPOLine VARCHAR(50),
	DockCode VARCHAR(30),
	QtyShipped INT,
	Price NUMERIC(20,6),
	LineWeight INTEGER)
	
INSERT	@InvoiceDetail 
(	PartNumber,
	CustomerPart,
	CustomerPO,
	CustomerPOLine,
	QtyShipped,
	Price,
	Lineweight
	)
	
SELECT
	
	sd.part_original,
	sd.customer_part,
	sd.customer_po,
	lss.cpl,
	sd.qty_packed,
	sd.alternate_price,
	sd.qty_packed*piv.unit_weight
FROM
	shipper_detail sd
JOIN
	shipper s ON s.id = @shipper
JOIN
	dbo.part_inventory piv 
	ON piv.part = sd.part_original
OUTER APPLY
( 
		SELECT 
			TOP 1 lss.CustomerPOLine cpl
			FROM 
				edi4010.LastShipSchedule lss
			WHERE lss.fxDestination = s.destination
			AND		lss.CustomerPart = sd.customer_part	) AS lss
WHERE
	sd.shipper = @shipper 
	


	INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//810'
						+  @TradingPartner 
						+  @1BSN02_ShipperID
						+  'P' )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+		@1BIG01InvoiceDate
				+		@1BIG02InvoiceNumber
				+		@1BIG01PODate
				+		'USD'
				+		@PackingList
						)


	INSERT	#ASNFlatFile (LineData)
					SELECT  '02' 									
							+ @BuyersAgent

		DECLARE
	InvoiceLine CURSOR LOCAL FOR
SELECT
	PartNumber,
	Customerpart,
	CustomerPO
	,InvoiceDetail.CustomerPOLine
	,	ROUND(QtyShipped,0)
	,	ROUND(Price,5)
	,	ROUND(QtyShipped,0)
	,	ROUND(Price,5)
FROM
	@InvoiceDetail InvoiceDetail


OPEN
	InvoiceLine

WHILE
	1 = 1 BEGIN
	
	FETCH
		InvoiceLine
	INTO
		@PartNumber,
		@1IT107CustomerPart
	,	@1IT1CustomerPO
	,	@AssignedID
	,	@1IT102QtyInvoiced
	,	@1IT104UnitPrice
	,	@1IT102QtyInvoicedNumeric
	,	@1IT104UnitPriceNumeric
			
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END

INSERT	#ASNFlatFile (LineData)
					SELECT  '06' 									
							+ @AssignedID
							+ @1IT102QtyInvoiced
							+ 'EA'
							+ @1IT104UnitPrice
							+ SPACE(2)
							+ 'IN'

INSERT	#ASNFlatFile (LineData)
					SELECT  '07' 									
							+  @1IT107CustomerPart
							+ 'PO'

INSERT	#ASNFlatFile (LineData)
					SELECT  '08' 									
							+  @1IT1CustomerPO

			
END
CLOSE
	InvoiceLine	
 
DEALLOCATE
	InvoiceLine	

	SELECT @1TDS01InvoiceAmount =  REPLACE(CAST(ROUND(SUM(qtyShipped*price), 2) AS MONEY) , '.', '') 
	--SELECT @1TDS01InvoiceAmount =  CAST(ROUND(SUM(qtyShipped*price), 2) AS MONEY) 
FROM
	@InvoiceDetail
	
	SELECT @ISSUnits =  CAST(ROUND(SUM(QtyShipped), 0) AS INTEGER) 
	FROM 
	@InvoiceDetail

	SELECT @ISSWeight =  CAST(ROUND(SUM(LineWeight), 0) AS INTEGER) 
	FROM 
	@InvoiceDetail

	INSERT	#ASNFlatFile (LineData)
					SELECT  '11' 									
							+  @1TDS01InvoiceAmount


	INSERT	#ASNFlatFile (LineData)
					SELECT  '12' 									
							+  @ISSUnits
							+ 'EA'
							+ @ISSWeight
							+ 'LB'


	

SELECT 
	--LEFT((LineData +convert(char(1), (lineID % 2 ))),80)
	 LineData + CASE WHEN LEFT(linedata,2) IN ('04', '10', '02') THEN '' ELSE RIGHT(CONVERT(CHAR(2), (lineID )),2) END
FROM 
	#ASNFlatFile
ORDER BY 
	LineID


	      
SET ANSI_PADDING OFF	
END
         































GO
