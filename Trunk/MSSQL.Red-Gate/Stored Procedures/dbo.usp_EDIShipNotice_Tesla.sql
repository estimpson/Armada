SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



CREATE PROCEDURE [dbo].[usp_EDIShipNotice_Tesla]  (@shipper INT)
AS
BEGIN
-- Test
-- Exec [dbo].[usp_EDIShipNotice_Tesla] 337127

/*

SP returns both ASN flat file and Invoice Flat File
   
  
    856 Overlay: TLO_856_D_v4010_TESLA SOTPI-PI_160707     

    810 Overlay : TMO_810_D_v4010_TESLA MOTORS_160203



*/

set ANSI_Padding on
--ASN Header

declare
--Variables for Flat File


--//Line
		@TradingPartner	char(12),
		@DESADV char(10),
		@ShipperIDHeader char(30),
		@PartialComplete char(1) = '' ,

--Header

		@1BSN01_Purpose char(2) = '00',										-- Purpose Code
		@1BSN02_ShipperID char(30),											--Shipper.id
		@1BSN03_SystemDate char(8),											--Getdate() 'CCYYMMDD'
		@1BSN04_SystemTime char(8),											--Getdate() 'HHMM'

		
		@1MEA01_PDQualifier char(2) = 'PD',															
		@1MEA02_GrossWeightQualifier char(3) = 'G',			--
		@1MEA03_Grossweight char(22),										--shipper.gross_weight
		@1MEA02_NetWeightQualifier char(3) = 'N',				--
		@1MEA03_Netweight char(22),											--shipper.net_weight
		@1MEA04_WeightUOM char(2) = 'LB',		

	
		@1TD101_PackCodeCNT90 char(5) = 'BOX90',				--Loose Container Indicator
		@1TD102_PackCountCNT90 char(8),								--count(1) of loose objects
		@1TD101_PackCodePLT90 char(5) = 'PLT90',				--Pallet Indicator
		@1TD102_PackCountPLT90 char(8)	,							--count(1) of distinct pallets


		@1TD501_RoutingSequence char(1) = 'B'	,					--Routing Sequence Code; appears to be B for all shipments
		@1TD502_IdCodeType char(2) = '2'	,							--'2'
		@1TD503_CarrierSCAC char(78)	,								--shipper.carrier
		@1TD504_ShipperTransMode char(2)	,						--shipper.trans_mode

		@1TD301_EquipmentDesc char(2) = 'TL',						--'TL'
		@1TD303_EquipmentNumber char(10),							--shipper.truck_number

		@REF02_ProNumberQualifier char(3)  = 'CN',			--Tesla wants  pro  number here
		@REF02_ProNumber char(30),									--Tesla wants Pro number
		@REF02_BillofLadingQualifier char(3)  = 'BM',		--Tesla wants trailer number here
		@REF02_BillofLading char(30),									--Tesla wants trailer number here

		@1DTM01_DateShippedQualifier char(3) = '011',				--date shipped qualifier "011"
		@1DTM02_DateShipped char(8),										--shipper.date_shipped 'CCYYMMDD'
		@1DTM03_TimeShipped char(8),										--shipper.date_shipped 'HHMM'
		@1DTM04_TimeZone char(2),												-- dbo.udfGetDSTIndication(date_shipped) returns either 'ED' or 'ET'
		

		@1N103_ShipFromQualifier char(3) = 'SF',
		@1N104_ShipFromCode char(78),
		@1N103_ShipFromName char(60),
		@1N103_ShipFromAddress char(55),

		@1N103_ShiptoQualifier char(3) = 'ST',
		@1N104_ShiptoCode char(78),
		@1N103_ShiptoName char(60),
		@1N103_ShiptoAddress char(55),
		




	


--Detail

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
		
	select
		@TradingPartner	= coalesce(nullif(es.trading_partner_code,''), 'Tesla'),
		@1BSN02_ShipperID  =  s.id,
		@1BSN03_SystemDate = CONVERT(VARCHAR(25), GETDATE(), 112)+LEFT(CONVERT(VARCHAR(25), GETDATE(), 108),2) +SUBSTRING(CONVERT(VARCHAR(25), GETDATE(), 108),4,2),
		@1BSN04_SystemTime = left(replace(convert(char, getdate(), 108), ':', ''),4),
		@1MEA03_Grossweight = convert(int, s.gross_weight),
		@1MEA03_Netweight = convert(int, s.net_weight),
		@1TD102_PackCountCNT90 = convert(int , s.staged_objs),
		@1TD503_CarrierSCAC = Coalesce(s.ship_via,''),
		@1TD504_ShipperTransMode = coalesce(s.trans_mode, 'LT'),
		@1TD303_EquipmentNumber = Coalesce(s.truck_number, convert(varchar(15),s.id)),
		@REF02_BillofLading = coalesce(s.truck_number,convert(varchar(15),s.bill_of_lading_number), convert(varchar(15),s.id)),
		@REF02_ProNumber = coalesce(s.pro_number, convert(varchar(15),s.id)),		
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
						--+ 'P')
						+  @PartialComplete )


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
 /*
declare	@ShipperDetail table (
	ID int identity(1,1),
	InvoiceNumber int, 
	KanbanNumber varchar(30),
	CustomerPart char(30),
	ManifestReceiverNo char(22),
	QtyShipped int, primary key (ID))
	
insert	@ShipperDetail 
(	InvoiceNumber,
	KanbanNumber,
	CustomerPart,
	ManifestReceiverNo,
	QtyShipped
	)
	
select
	coalesce(s.invoice_number,@Shipper),
	coalesce(st.Kanban,' ' ),
	md.CustomerPart,
	CASE WHEN md.ManifestNumber LIKE '%-%' THEN SUBSTRING(md.ManifestNumber,1,PATINDEX('%-%', md.ManifestNumber)-1) ELSE md.ManifestNumber END,
	md.Quantity
from
	shipper s
join
		editoyota.Pickups mp on mp.ShipperID = s.id
join
		editoyota.ManifestDetails md on md.PickUpID = mp.RowID
JOIN	
		EDIToyota.ShipTos st ON st.EDIShipToCode = mp.ShipToCode
Where
	s.id = @shipper
	
	
/*declare	@AuditTrailSerial table (
Part varchar(25),
ObjectPackageType varchar(35),
PalletPackageType varchar(35),
SerialQuantity int,
ParentSerial int,
Serial int, 
id int identity primary key (id))
	
insert	@AuditTrailSerial 
(		Part,
		ObjectPackageType,
		PalletPackageType,	
		SerialQuantity,
		ParentSerial,
		Serial 
)
	
select
	at.part,
	coalesce( pm.name, at.package_type,'0000CART'),
	Coalesce((Select max(package_type) 
		from audit_trail at2
		left join package_materials pm2 on pm2.code =  at2.package_Type
		where		at2.serial = at.parent_serial and
						at2.shipper = convert(varchar(15),@shipper)  and
						at2.type = 'S'and
						at2.part = 'PALLET'
		),'0000PALT'),
	quantity,
	isNull(at.parent_serial,0),
	serial
from
	dbo.audit_trail at
left join
	dbo.package_materials pm on pm.code = at.package_type
Where
	at.shipper = convert(varchar(15),@shipper) and
	at.type = 'S' and
	part != 'Pallet'
order by		isNull(at.parent_serial,0), 
						part, 
						serial

--declare	@AuditTrailPartPackGroupRangeID table (
--Part varchar(25),
--PackageType varchar(35),
--PartPackQty int,
--Serial int,
--RangeID int, primary key (Serial))


--insert	@AuditTrailPartPackGroupRangeID
--(	Part,
--	PackageType,
--	PartPackQty,
--	Serial,
--	RangeID
--)

--Select 
--	atl.part,
--	atl.PackageType,
--	SerialQuantity,
--	Serial,
--	Serial-id
	
--From
--	@AuditTrailSerial atL
--join
--	@AuditTrailPartPackGroup atG on
--	atG.part = atl.part and
--	atg.packageType = atl.PackageType and
--	atg.partPackQty = atl.SerialQuantity



--declare	@AuditTrailPartPackGroupSerialRange table (
--Part varchar(25),
--PackageType varchar(35),
--PartPackQty int,
--SerialRange varchar(50), primary key (SerialRange))


--insert	@AuditTrailPartPackGroupSerialRange
--(	Part,
--	PackageType,
--	PartPackQty,
--	SerialRange
--)

--Select 
--	part,
--	PackageType,
--	PartPackQty,
--	Case when min(serial) = max(serial) 
--		then convert(varchar(15), max(serial)) 
--		else convert(varchar(15), min(serial)) + ':' + convert(varchar(15), max(serial)) end
--From
--	@AuditTrailPartPackGroupRangeID atR

--group by
--	part,
--	PackageType,
--	PartPackQty,
--	RangeID


/*	Select * From @ShipperDetail
	Select * From @AuditTrailLooseSerial
	Select * From @AuditTrailPartPackGroupRangeID
	Select * From @AuditTrailPartPackGroup
	Select * From @AuditTrailPartPackGroupSerialRange
*/


--Delcare Variables for ASN Details		
/*
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
	@SN102_QuantityShipped char(12),
	@SN103_QuantityShippedUM char(2) = 'PC',
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
	@CustomerPO char(35),
	@CustomerECL char(35),
	@CustomerECLQual char(3),
	@PackageType char(17),
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
	@SupplierSerial char(35),
	@CPS03 Char(3),
	@UM char(3)
	 
--Populate Static Variables
select	@CountryOfOrigin = 'CA'
select	@PartUM = 'EA'	
select	@PCI_S = 'S'
select	@PCI_M = 'M'
Select	@DunnageIdentifier = '37'
Select	@DunnagePackType = 'YazakiDunnage'
Select	@UM = 'C62'
Select  @PCIQualifier = '17'
Select 	@CPS03 = 1
Select	@SupplierPartQual = 'SA'
Select	@CustomerECLQual = 'DR'
Select	@REF02_InvoiceIDID = @shipper
Select	@REF02_PackingSlipID = @shipper
 */
 
 
 */		
 Declare
		Manifest cursor local for

Select
		Distinct
		InvoiceNumber = InvoiceNumber,
		ManifestNo = ManifestReceiverNo
From
		@ShipperDetail SD

open
	Manifest

while
	1 = 1 begin
	
	fetch
		Manifest
	into
		@2REF02InvoiceNumber,
		@1PRF01ManifestReceiverNo

		if	@@FETCH_STATUS != 0 begin
		break
	end

		Insert	#ASNFlatFile (LineData)
					Select  '12' 									
							+ @1PRF01ManifestReceiverNo

	Insert	#ASNFlatFile (LineData)
					Select  '13' 									
							+ @2REF02InvoiceNumber

	Insert	#ASNFlatFile (LineData)
					Select  '14' 									
							+ @1N104_SupplierCode


declare
	PartsPerManifest cursor local for
select
	CustomerPart = customerpart,
	KanbanNumber = KanbanNumber,
	QtyShipped = convert(int, QtyShipped)
From
	@ShipperDetail SD
	where
		SD.ManifestReceiverNo = @1PRF01ManifestReceiverNo

open
	PartsPerManifest

while
	1 = 1 begin
	
	fetch
		PartsPerManifest
	into
		@1LIN03CustomerPart,
		@1LIN05Kanban,
		@1SN102QtyShipped
			
	if	@@FETCH_STATUS != 0 begin
		break
	end



	Insert	#ASNFlatFile (LineData)
					Select  '15' 									
							+ @1LIN01LineItem
							+ @1LIN02CustomerPartBP
							+ @1LIN03CustomerPart
							--+ @1LIN04KanbanRC

		Insert	#ASNFlatFile (LineData)
					Select  '16' 									
							+ SPACE(30)
							+ @1SN102QtyShipped
							+ @1SN103QtyShippedUM
	
	
/*
		Insert	#ASNFlatFile (LineData)
		Select '27'
				+		@LIN02_BPIDtype
				+		@LIN02_CustomerPart
				+		@LIN02_VPIDtype

		Insert	#ASNFlatFile (LineData)
		Select '28'
				+		@LIN02_VendorPart
				+		@LIN02_PDIDtype

		Insert	#ASNFlatFile (LineData)
		Select '29'
				+		@LIN02_PartDescription
				+		@LIN02_POIDtype

		Insert	#ASNFlatFile (LineData)
		Select '30'
				+		@LIN02_CustomerPO

		Insert	#ASNFlatFile (LineData)
		Select '34'
				+		space(48)
				+		@LIN02_CHIDtype

		Insert	#ASNFlatFile (LineData)
		Select '35'
				+		@LIN02_CountryOfOrigin

		Insert	#ASNFlatFile (LineData)
		Select '36'
				+		space(48)
				+		@SN102_QuantityShipped
				+		@SN103_QuantityShippedUM

		Insert	#ASNFlatFile (LineData)
		Select '37'
				+		@SN104_AccumQuantityShipped

		Insert	#ASNFlatFile (LineData)
		Select '39'
				+		@REF01_IVIDType

		Insert	#ASNFlatFile (LineData)
		Select '40'
				+		@REF02_InvoiceIDID

		Insert	#ASNFlatFile (LineData)
		Select '39'
				+		@REF01_PKIDType

		Insert	#ASNFlatFile (LineData)
		Select '40'
				+		@REF02_PackingSlipID
*/
/*
		declare PartPack cursor local for
			select
				1,
				count(serial),
				ObjectPackageType				
			From
				@AuditTrailSerial
			where
				part = @InternalPart
				group by
				ObjectPackageType
				union
			 Select
			  2,
				count(Distinct ParentSerial),
				PalletPackageType				
			From
				@AuditTrailSerial
			where
				part = @InternalPart and
				ParentSerial > 0
				group by
				PalletPackageType
				order by 1,2
												
			open
				PartPack

			while
				1 = 1 begin
							
				fetch
					PartPack
				into
					@PackTypeType,
					@1PAC01PackageCount,
					@1PAC01PackageType
					
								
																								
				if	@@FETCH_STATUS != 0 begin
					break
				end
									Insert	#ASNFlatFile (LineData)
										Select  '10' 									
										+ @1PAC01PackageCount
										+ @1PAC01PackageType
							
					end		
					close
						PartPack
					deallocate
						PartPack
						
					

			Insert	#ASNFlatFile (LineData)
										Select  '14' 									
										+ @2LIN030CustomerPart
										+ @1PIAModelYear

			Insert	#ASNFlatFile (LineData)
										Select  '16' 									
										+ @2QTY010QtyTypeShipped
										+ @2QTY010QtyShipped
										+	@2QTY010QtyShippedUM

		Insert			#ASNFlatFile (LineData)
										Select  '16' 									
										+ @2QTY010AccumTypeShipped
										+ @2QTY010AccumShipped
										+	@2QTY010AccumShippedUM

			Insert			#ASNFlatFile (LineData)
										Select  '17' 									
										+ space(3)
										+ @1RFF010CustomerPO
	*/									
end
close
	PartsPerManifest
 
deallocate
	PartsPerManifest

end
close
	Manifest
 
deallocate
	Manifest

--Get 810 data
*/


/*

--Declare Variables for 810 Flat File

DECLARE @1BIG01InvoiceDate CHAR(8),
				@1BIG02InvoiceNumber CHAR(5),
				@1IT01KanbanCard CHAR(4),
				@1IT102QtyInvoiced CHAR(12), 
				@1IT104UnitPrice CHAR(16),
				@1IT102QtyInvoicedNumeric NUMERIC(20,6), 
				@1IT104UnitPriceNumeric NUMERIC(20,6),
				@1IT105BasisOfUnitPrice CHAR(2) = 'QT',
				@1IT106PartQualifier CHAR(2) = 'PN',
				@1IT107CustomerPart CHAR(12),
				@1IT108PackageDrawingQual CHAR(2) = 'PK',
				@1IT109PackageDrawing CHAR(12) = '1',
				@1IT110 CHAR(2) = 'ZZ', 
				@1IT111 CHAR(12),
				@1REF01MKQualifier CHAR(2) = 'MK',
				@1REF02Manifest CHAR(30),
				@1DTM02PickUpDate CHAR(8),
				@1TDS01InvoiceAmount CHAR(12),
				@PartNumber VARCHAR(25)

SELECT
		
		@1BIG01InvoiceDate= CONVERT(VARCHAR(25), s.date_shipped, 112)+LEFT(CONVERT(VARCHAR(25), s.date_shipped, 108),2) +SUBSTRING(CONVERT(VARCHAR(25), s.date_shipped, 108),4,2),
		
		@1BIG02InvoiceNumber = '01560',

		@1IT01KanbanCard = COALESCE( 'M390', es.material_issuer, 'M390')

		


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
	ManifestNumber VARCHAR(25),
	PartNumber VARCHAR(25),
	CustomerPart VARCHAR(50),
	DockCode VARCHAR(30),
	QtyShipped INT,
	Price NUMERIC(20,6))
	
INSERT	@InvoiceDetail 
(	ManifestNumber,
	PartNumber,
	CustomerPart,
	DockCode,
	QtyShipped,
	Price
	)
	
SELECT
	
	md.ManifestNumber,
	sd.part_original,
	md.customerpart,
	mp.ShipToCode,
	md.Quantity,
	sd.alternate_price
FROM
	shipper_detail sd
JOIN
	shipper s ON s.id = @shipper
JOIN
		EDIToyota.Pickups mp ON mp.ShipperID = @shipper
JOIN
		EDIToyota.ManifestDetails md ON md.PickupID= mp.RowID
WHERE
	sd.shipper = @shipper AND
	sd.order_no = md.OrderNo
	
DECLARE
	InvoiceLine CURSOR LOCAL FOR
SELECT
	ManifestNumber,
	PartNumber,
	Customerpart
	, DockCode
	,	ROUND(QtyShipped,0)
	,	ROUND(Price,4)
	,	ROUND(QtyShipped,0)
	,	ROUND(Price,4)
FROM
	@InvoiceDetail InvoiceDetail


OPEN
	InvoiceLine

WHILE
	1 = 1 BEGIN
	
	FETCH
		InvoiceLine
	INTO
		@1REF02Manifest,
		@PartNumber,
		@1IT107CustomerPart
		,@1IT111
	,	@1IT102QtyInvoiced
	, @1IT104UnitPrice
	,	@1IT102QtyInvoicedNumeric
	, @1IT104UnitPriceNumeric
			
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END

	INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//810'
						+  @TradingPartner 
						+  @ShipperIDHeader
						+  'P' )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+		@1BIG01InvoiceDate
				+		@1BIG02InvoiceNumber
						)


	INSERT	#ASNFlatFile (LineData)
					SELECT  '02' 									
							+ @1IT01KanbanCard
							+ @1IT102QtyInvoiced
							+ @1IT104UnitPrice
							+ @1IT105BasisOfUnitPrice
							+ @1IT106PartQualifier
							+ @1IT107CustomerPart
							+ @1IT108PackageDrawingQual
							+ @1IT109PackageDrawing
							+ @1IT110
							+ @1IT111

	INSERT	#ASNFlatFile (LineData)
					SELECT  '03' 									
							+ @1REF01MKQualifier
							+ @1REF02Manifest


	INSERT	#ASNFlatFile (LineData)
					SELECT  '04' 									
							+ @1BIG01InvoiceDate



SELECT @1TDS01InvoiceAmount = SUBSTRING(CONVERT(VARCHAR(MAX),ROUND(SUM(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)),1,PATINDEX('%.%', CONVERT(VARCHAR(MAX),ROUND(SUM(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)))-1 ) +
		SUBSTRING(CONVERT(VARCHAR(MAX),ROUND(SUM(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)),PATINDEX('%.%', CONVERT(VARCHAR(MAX),ROUND(SUM(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)))+1, 2)


INSERT	#ASNFlatFile (LineData)
					SELECT  '05' 									
							+ @1TDS01InvoiceAmount


	
	
								
END
CLOSE
	InvoiceLine	
 
DEALLOCATE
	InvoiceLine	


	*/

SELECT 
	--LEFT((LineData +convert(char(1), (lineID % 2 ))),80)
	 LineData + CASE WHEN LEFT(linedata,2) IN ('04', '10') THEN '' ELSE RIGHT(CONVERT(CHAR(2), (lineID )),2) END
FROM 
	#ASNFlatFile
ORDER BY 
	LineID


	      
SET ANSI_PADDING OFF	
END
         























GO
