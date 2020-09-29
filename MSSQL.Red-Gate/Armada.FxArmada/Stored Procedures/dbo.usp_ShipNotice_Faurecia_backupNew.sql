SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_ShipNotice_Faurecia_backupNew]  (@shipper INT)
AS
BEGIN

--dbo.usp_ShipNotice_Faurecia 365303
SET ANSI_PADDING ON
--ASN Header




--declare	@AddressFromDELFOR table (
--	[RawDocumentGUID] [uniqueidentifier] NOT NULL,
--	[ReleaseNo] [varchar](50) NULL,
--	[ConsigneeCode] [varchar](35) NULL,
--	[ShipFromCode] [varchar](35) NULL,
--	[SupplierCode] [varchar](35) NULL,
--	[SupplierAdd1] [varchar](35) NULL,
--	[SupplierAdd2] [varchar](35) NULL,
--	[SupplierAdd3] [varchar](35) NULL,
--	[SupplierAdd4] [varchar](35) NULL,
--	[SupplierName] [varchar](35) NULL,
--	[SupplierStreet] [varchar](35) NULL,
--	[SupplierCity] [varchar](35) NULL,
--	[SupplierCountrySUB] [varchar](35) NULL,
--	[SupplierPostalCode] [varchar](35) NULL,
--	[SupplierCountry] [varchar](35) NULL,
--	[ShipToCode] [varchar](35) NOT NULL,
--	[ShipToAdd1] [varchar](35) NULL,
--	[ShipToAdd2] [varchar](35) NULL,
--	[ShipToAdd3] [varchar](35) NULL,
--	[ShipToAdd4] [varchar](35) NULL,
--	[ShipToName] [varchar](35) NULL,
--	[ShipToStreet] [varchar](35) NULL,
--	[ShipToCity] [varchar](35) NULL,
--	[ShipToCountrySUB] [varchar](35) NULL,
--	[ShipToPostalCode] [varchar](35) NULL,
--	[ShipToCountry] [varchar](35) NULL primary key (RawDocumentGUID, ShipToCode)
--	)

--Insert @AddressFromDELFOR
--Select * 
--From EDIEDIFACT97A.AddressFromDELFOR




DECLARE
	@TradingPartner	CHAR(12),
	@ShipperID CHAR(35),
	@MessageFunction CHAR(3),
	@ShipperIDHeader CHAR(30),
	@PartialComplete CHAR(1) ,
	@ASNPurpose CHAR(1) = '9',
	@DESADVDateQual CHAR(3) = '11', --DateShipped
	@CurrentDateQual CHAR(3) = '137', --Getdate()
	@EstDelDateQual CHAR(3) = '132',
	@ASNDate CHAR(8),
	@ASNTime CHAR(4),
	@ASNDateTime CHAR(35),
	@ShippedDate CHAR(8),
	@ShippedTime CHAR(4),
	@ShippedDateTime CHAR(35),
	@ArrivalDate CHAR(35),
	@ArrivalTime CHAR(4),
	@ArrivalDateTime CHAR(35),
	@GrossWeightLbs CHAR(18),
	@GrossWeightKG CHAR(10),
	@GrossWeightQual CHAR(3) = 'G',
	@GrossWeightUM CHAR(3) = 'LBR',
	@NetWeightQual CHAR(3) = 'N',
	@NetWeightLbs CHAR(18),
	@NetWeightUM CHAR(3) = 'LBR',
	@PackagingCode CHAR(5),
	@PackagingCountQual CHAR(3) = 'SQ',
	@PackCount CHAR(18),
	@PackCountUM CHAR(3) = 'C62',
	@TDT03_1_TransMode CHAR(17) = 'M',
	@TDT03TransMode CHAR(2),
	@TDT05_1_SCAC CHAR(17),
	@TDT05_3_AgencyCode CHAR(3) = '182',
	@TDT05_4_CarrierName CHAR(35),
	@EQD_01_TrailerNumberQual CHAR(2) = 'TE',	
	@EQD_02_01_TrailerNumber CHAR(17),
	@REFMAQual CHAR(3) = 'MA',
	@REFADEQual CHAR(3) = 'ADE',
	@REFCRNQual CHAR(3) = 'CRN', --TrailerNumber
	@REFMAValue CHAR(35),
	@REFADEValue CHAR(35),
	@REFCRNValue CHAR(35),
	@FOB CHAR(2),	
	@NADQualSU CHAR(3)  ='SU', --Supplier
	@NADSupplierName CHAR(35),
	@NADSupplierCode CHAR(35),
	@NADSupplierAdd1 CHAR(35),
	@NADSupplierCityName CHAR(35),
	@NADSupplierState CHAR(9),
	@NADSupplierPostal CHAR(9),
	@NADSupplierCountry CHAR(3),
	@NADQualST CHAR(3) = 'ST' , --Consignee (destination)
	@NADShipToName CHAR(35),
	@NADShipToID CHAR(35),
	@NADShipToAdd1 CHAR(35),
	@NADShipToCityName CHAR(35),
	@NADShipToState CHAR(9),
	@NADShipToPostal CHAR(9),
	@NADShipToCountry CHAR(3),
	@NADShipToID2 CHAR(25),
	@RoutingCode CHAR(35),
	@BuyerID CHAR(35),
	@BuyerName CHAR(35),
	@SellerID CHAR(35),
	@SellerName CHAR(75),
	@SoldToID CHAR(35),
	@ConsolidationCenterID CHAR(35),
	@SoldToName CHAR(35),
	@ConsolidationCenterName CHAR(35),
	@LOC02_DockCode CHAR(25),
	@MEAGrossWghtQualfier CHAR(3) = 'G',
	@MEANetWghtQualfier CHAR(3) = 'N',
	@MEALadingQtyQualfier CHAR(3) = 'SQ',
	@MEAGrossWghtUMKG CHAR(3) = 'KG',
	@MEANetWghtUMKG CHAR(3) = 'KG',
	@MEAGrossWghtUMLBR CHAR(3) = 'LBR',
	@MEANetWghtUMLBR CHAR(3) = 'LBR',
	@MEALadingQtyUM CHAR(3) = 'C62',
	@MEAGrossWghtKG CHAR(10),
	@MEANetWghtLB  CHAR(18), 
	@MEAGrossWghtLB CHAR(18),
	@MEANetWghtKG  CHAR(18),
	@MEALadingQty CHAR(18),
	@TDTProNumber CHAR(25),
	@REFCOFQual CHAR(3) = 'COF',
	@REFCOFValue CHAR(35), 
	@DESADV CHAR(10) = 'DESADV',
	@NADBuyerAdd1 CHAR(35) = '' ,
	@NADMaterialIssuerID CHAR(9),
	@NADMaterialSupplierID CHAR(35),
	@NADQual16 CHAR(3) = '16',
	@NADQual92 CHAR(3) = '92',
	@SealNumber CHAR(10),
	@NADQualCZ CHAR(3)  ='CZ',
	@NADCOO CHAR(3)  ='US',
	@NADMaterialSupplierIDPadded CHAR(10)

	
	SELECT
		@TradingPartner	= COALESCE(es.trading_partner_code, 'HBPO'),
		@ShipperID =  s.id,
		@MessageFunction ='9',
		@ShipperIDHeader =  s.id,
		@PartialComplete = 'P' ,
		@ASNDate = CONVERT(CHAR, GETDATE(), 112) ,
		@ASNTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''),4),
		@ASNDateTime = RTRIM(@ASNDate)+RTRIM(@ASNTime),
		@ShippedDate = CONVERT(CHAR, s.date_shipped, 112)  ,
		@ShippedTime =  LEFT(REPLACE(CONVERT(CHAR, date_shipped, 108), ':', ''),4),
		@ShippedDateTime = RTRIM(@ShippedDate)+RTRIM(@ShippedTime),
		@ArrivalDate = CONVERT(CHAR, DATEADD(dd,1, s.date_shipped), 112)  ,
		@ArrivalTime =  left(replace(convert(char, date_shipped, 108), ':', ''),4),
		@ArrivalDateTime = rtrim(@ArrivalDate)+rtrim(@ArrivalTime),
		@MEAGrossWghtLB = convert(char,convert(int,s.gross_weight)),
		@MEANetWghtLB = convert(char,convert(int,s.net_weight)),
		@MEAGrossWghtKG = convert(char,convert(int,s.gross_weight/2.2)),
		@MEANetWghtKG = convert(char,convert(int,s.net_weight/2.2)),
		@PackagingCode = 'CNT71' ,
		@MEALadingQty = convert(char,convert(int,ShipperDetail.TotalShippedQty)),
		@TDT03_1_TransMode = coalesce(s.trans_mode,''),
		@TDT05_1_SCAC = s.ship_via,
		@TDT05_4_CarrierName = s.ship_via,
		@EQD_02_01_TrailerNumber = coalesce(nullif(s.truck_number,''), CONVERT(VARCHAR(50),s.id)),
		@REFCRNValue = coalesce(nullif(s.truck_number,''), CONVERT(VARCHAR(50),s.id)),
		--@REFBMQual = 'MB' ,
		--@REFPKQual = 'PK',
		--@REFCNQual = 'CN',
		--@REFBMValue = coalesce(bill_of_lading_number, id),
		--@REFPKValue = id,
		--@REFCNValue = coalesce(nullif(pro_number,''),nullif(s.truck_number,''),'1'),
		@REFCOFValue = coalesce(s.shipping_dock, ''),
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else '' end ,
		@RoutingCode = 'NA',
		@SealNumber = coalesce(s.seal_number,''),
		@ConsolidationCenterID  = case when trans_mode like '%A%' then '' else coalesce(pool_code, '') end,
		@ConsolidationCenterName = coalesce((select max(name) from destination where destination = pool_code),''),
		@SoldToID = d.destination,
		@SoldToName =  d.name,
		@NADShipToID = da.shiptocode,
		@NADShipToName =  da.ShipToname,
		@NADShipToAdd1 =  da.ShipToAdd1,
		@NADShipToCityName =  da.ShipToCity,
		@NADShipToState =  da.ShipToCountrySUB,
		@NADShipToPostal =  da.ShipToPostalCode,
		@NADShipToCountry =  da.ShipToCountry,
		@NADSupplierCode = da.suppliercode,
		@NADSupplierName =  da.suppliername,
		@NADSupplierAdd1 =  da.supplierAdd1,
		@NADSupplierCityName =  da.supplierCity,
		@NADSupplierState =  da.SupplierCountrySUB,
		@NADSupplierPostal =  da.SupplierPostalCode,
		@NADSupplierCountry =  da.SupplierCountry,
		@LOC02_DockCode = coalesce(s.shipping_dock,'TESTDOCKCODE'),		
		@SellerID =  coalesce(es.supplier_code,'SUPP'),
		@SellerName = '',
		@NADMaterialSupplierID =  coalesce(es.supplier_code,'SUPP'),
		@NADMaterialSupplierIDPadded =  RIGHT( '000000000' + coalesce(es.supplier_code,'SUPP'), 10),	
		@BuyerID = c.customer,
		@NADMaterialIssuerID = coalesce(es.material_issuer,''),
		@BuyerName = 'Armada Rubber',
		@TDTProNumber = s.Pro_number,
		@REFMAValue = ( Select top 1 release_no from shipper_detail where shipper = @shipper and nullif(release_no,'') is Not NULL )
	from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	join
		dbo.customer c on c.customer = s.customer
	left join
		dbo.AddressFromDELFOR da on da.ShipToCode = es.EDIShipToID
	cross apply ( select sum(qty_packed) TotalShippedQty 
					from 
						shipper_detail 
					where 
						shipper = s.id ) as ShipperDetail
	where
		s.id = @shipper
	

Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(79) )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'//STX12//   '
				+ @TradingPartner 
				+ @ShipperIDHeader
				+ @PartialComplete
				+ @DESADV 
				+ left(@DESADV,6)
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+	@ShipperID
				/*+	@ASNpurpose
				+	@ASNDateTime 
				+	@ASNDateTime*/ )
INSERT	#ASNFlatFile (LineData)
		SELECT	(	'02'
				+	@CurrentDateQual
				+	@ASNDateTime
				 )


INSERT	#ASNFlatFile (LineData)
	SELECT	  (		'02'
				+	@DESADVDateQual
				+	@ASNDateTime
				 )



INSERT	#ASNFlatFile (LineData)
	   SELECT	(	'02'
				+	@EstDelDateQual
				+	@ArrivalDateTime
				 )



INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEAGrossWghtQualfier
				+ @MEAGrossWghtUMLBR
				+ @MEAGrossWghtLB							
				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEANetWghtQualfier
				+ @MEANetWghtUMLBR
				+ @MEANetWghtLB							
				
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'03'
				+ @MEALadingQtyQualfier
				+ @MEALadingQtyUM
				+ @MEALadingQty							
				
			)


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'04'
				+ @REFMAValue
			)
			


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'05'
				+ @NADQualST
				+ @NADShipToID
				+ @NADShipToName
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'06'
				+ @NADShipToAdd1
				+ @NADShipToCityName
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+ @NADShipToState
				+ @NADShipToPostal
				+ @NADShipToCountry
			)


INSERT	#ASNFlatFile (LineData)
	SELECT	(	'08'
				+ @LOC02_DockCode
			)



			INSERT	#ASNFlatFile (LineData)
	SELECT	(	'05'
				+ @NADQualSU
				+ @NADSupplierCode
				+ @NADSupplierName
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'06'
				+ @NADSupplierAdd1
				+ @NADSupplierCityName
			)

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'07'
				+ @NADSupplierState
				+ @NADSupplierPostal
				+ @NADSupplierCountry
			)
				



INSERT	#ASNFlatFile (LineData)
	SELECT	(	'11'
				+ @EQD_02_01_TrailerNumber
				+ @TDT03_1_TransMode
				+ @TDT05_1_SCAC
				+ @TDTProNumber
							)




 --ASN Detail

declare	@ShipperDetail table (
	ID int identity(1,1),
	Part varchar(25),
	CustomerPart varchar(35),
	CustomerPO varchar(35),
	CustomerPOLine varchar(35),
	CustomerECL varchar(35),
	DockCode varchar(35),
	StorageLocation varchar(50),
	SummedATQty int,
	ATQty INT,
	SerialCount INT,
	AccumShipped int primary key (ID))
	
insert	@ShipperDetail 
(	Part,
	CustomerPart,
	CustomerPO,
	CustomerPOLine,
	CustomerECL,
	DockCode,
	StorageLocation,
	SummedATQty,
	ATQty,
	SerialCount,
	AccumShipped
	)
	
select
	part_original,
	sd.customer_part,
	sd.customer_po,
	coalesce( NULLIF(CustomerPOLine,'') , '00010'),
	coalesce(oh.engineering_level,oh.customer_part,''),
	coalesce(s.shipping_dock,''),
	coalesce(oh.line11,'0001'),
	MAX(ATQty.SummedAtQty),
	MAX(ATQty.AtQty),
	COUNT(1),
	MAX(sd.accum_shipped)
from
	shipper_detail sd
join
	order_header oh on oh.order_no = sd.order_no
join
	edi_setups es on es.destination = oh.destination
outer apply
	( Select top 1 CustomerPOLine 
		from EDIEDIFACT97A.CurrentPlanningReleases() crp
		join EDIEDIFACT97A.PlanningReleases	 pr on pr.RawDocumentGUID = crp.RawDocumentGUID
		where pr.ShipToCode = es.EDIShipToID and
			  pr.CustomerPart = sd.customer_part
			  ) as EDIRelease
join
	shipper s on s.id = @shipper
OUTER APPLY
	 (
	SELECT SUM(quantity) SummedAtQty, part, at2.quantity atQty
	FROM 
		dbo.audit_trail at2
	WHERE at2.Shipper = CONVERT(VARCHAR(20), @shipper ) AND
					at2.type = 'S' AND
                    at2.part =  sd.part_original
		GROUP BY at2.part, at2.quantity
	) AS ATQty
	
	WHERE
	sd.shipper = @shipper
GROUP BY
	part_original,
	sd.customer_part,
	sd.customer_po,
	coalesce( NULLIF(CustomerPOLine,'') , '00010'),
	coalesce(oh.engineering_level,oh.customer_part,''),
	coalesce(s.shipping_dock,''),
	coalesce(oh.line11,'0001'),
	ATQty.AtQty
	
	
declare	@AuditTrailLooseSerial table (
Part varchar(25),
PackageType varchar(35),
PartPackCount int,
SerialQuantity int,
ParentSerial int,
Serial int, 
id int identity primary key (id))
	
insert	@AuditTrailLooseSerial 
(	Part,
	PackageType,
	PartPackCount,
	SerialQuantity,
	ParentSerial,
	Serial 
)
	
select
	part,
	ISNULL(Nullif(package_type,''),'KLT42') ,
	1,
	quantity,
	0,
	serial
from
	dbo.audit_trail at
left join
	dbo.package_materials pm on pm.code = at.package_type
Where
	at.shipper = convert(varchar(15),@shipper) and
	at.type = 'S' and
	--nullif(at.parent_serial,0) is null and
	part != 'Pallet'
order by serial	

declare	@AuditTrailPartPackGroup table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int, 
PartPackCount int, primary key (Part, PackageType, PartPackQty))


insert	@AuditTrailPartPackGroup
(	Part,
	PackageType,
	PartPackQty,
	PartPackCount
)

Select 
	part,
	PackageType,
	SerialQuantity,
	sum(PartPackCount)
From
	@AuditTrailLooseSerial
group by
	part,
	PackageType,
	SerialQuantity



declare	@AuditTrailPartPackGroupRangeID table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
Serial int,
RangeID int, primary key (Serial))


insert	@AuditTrailPartPackGroupRangeID
(	Part,
	PackageType,
	PartPackQty,
	Serial,
	RangeID
)

Select 
	atl.part,
	atl.PackageType,
	SerialQuantity,
	Serial,
	Serial-id
	
From
	@AuditTrailLooseSerial atL
join
	@AuditTrailPartPackGroup atG on
	atG.part = atl.part and
	atg.packageType = atl.PackageType and
	atg.partPackQty = atl.SerialQuantity



declare	@AuditTrailPartPackGroupSerialRange table (
Part varchar(25),
PackageType varchar(35),
PartPackQty int,
SerialRange varchar(50), primary key (SerialRange))


INSERT	@AuditTrailPartPackGroupSerialRange
(	Part,
	PackageType,
	PartPackQty,
	SerialRange
)

SELECT 
	part,
	PackageType,
	PartPackQty,
	CASE WHEN MIN(serial) = MAX(serial) 
		THEN CONVERT(VARCHAR(15), MAX(serial)) 
		ELSE CONVERT(VARCHAR(15), MIN(serial)) + ':' + CONVERT(VARCHAR(15), MAX(serial)) END
FROM
	@AuditTrailPartPackGroupRangeID atR

GROUP BY
	part,
	PackageType,
	PartPackQty,
	RangeID


/*	Select * From @ShipperDetail
	Select * From @AuditTrailLooseSerial
	Select * From @AuditTrailPartPackGroupRangeID
	Select * From @AuditTrailPartPackGroup
	Select * From @AuditTrailPartPackGroupSerialRange
*/


--Delcare Variables for ASN Details		
DECLARE	
	@LineItemID CHAR(3),
	@Lin0302 CHAR(3) = 'IN',
	@CustomerPart CHAR(35) ,
	@IMDpartDescription CHAR(35),
	@Part VARCHAR(50),
	@SupplierPart CHAR(35),
	@SupplierPartQual CHAR(3),
	@CountryOfOrigin CHAR(3),
	@PartQty CHAR(17),
	@PartAccum CHAR(14),
	@PartUM CHAR(3),
	@CustomerPO CHAR(35),
	@CustomerPOLine CHAR(6),
	@CustomerECL CHAR(35),
	@CustomerECLQual CHAR(3),
	@PackageType CHAR(17),
	@DunnagePackType CHAR(17),
	@DunnageCount CHAR(10),
	@DunnageIdentifier CHAR(3),
	@PartPackQty CHAR(17),
	@PartPackCount CHAR(10),
	@PCIQualifier CHAR(3),
	@PCIStorage CHAR(35) ,
	@Serial CHAR(9),
	@DockCode CHAR(25),
	@PCI_S CHAR(3),
	@PCI_M CHAR(3),
	@SupplierSerial CHAR(35),
	@CPS03 CHAR(3) = '1',
	@UM CHAR(3),
	@Kanban CHAR(35) = '0000000',
	@KanbanQual CHAR(3)= 'AL',
	@ModelYear CHAR(35),
	@SerialQty CHAR(35) ,
	@SerialQtyint int ,
	@SerialCount CHAR(10)

	 
--Populate Static Variables
SELECT	@CountryOfOrigin = 'US'
SELECT	@PartUM = 'EA'	
SELECT	@PCI_S = 'S'
SELECT	@PCI_M = 'M'
SELECT	@DunnageIdentifier = '37'
SELECT	@DunnagePackType = ''
SELECT	@UM = 'PCE'
SELECT  @PCIQualifier = '17'
SELECT 	@CPS03 = 1
SELECT	@SupplierPartQual = 'SA'
SELECT	@CustomerECLQual = 'DR'
SELECT	@ModelYear =  (SELECT model_year FROM shipper WHERE id = @Shipper)
 			
DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
	ID = ID,
	InternalPart = sd.Part,
	CustomerPart = customerpart,
	PartDescription = LEFT(p.name,35),
	CustomerPO = customerpo,
	CustomerPOLine = CustomerPOLine,
	CustomerECL = customerECL,
	DockCode = DockCode,
	StorageLocation = StorageLocation,
	SerialQty = CONVERT(INT, SD.ATQty),
	SummedSerialQty = SD.SummedATQty,
	SerialCount = SD.SerialCount,
	AccumShipped = CONVERT(INT, AccumShipped),
	'KLT42'
FROM
	@ShipperDetail SD
JOIN
	part p ON sd.Part = p.part

OPEN
	PartPOLine

WHILE
	1 = 1 BEGIN
	
	FETCH
		PartPOLine
	INTO
		@LineItemID,
		@Part,
		@CustomerPart,
		@IMDpartDescription,
		@CustomerPO,
		@CustomerPOLine,
		@CustomerECL,
		@DockCode,
		@PCIStorage,
		@SerialQtyint,
		@PartQty,
		@SerialCount,
		@PartAccum,
		@PackageType
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END		
																					
					INSERT	#ASNFlatFile (LineData)
					SELECT  '12'
							+ @LineItemID 
							+ SPACE(3)
							+ @CPS03	
							
				
																		
																	
							DECLARE PartPackSerialGroup CURSOR LOCAL FOR

							SELECT	
								CONVERT(VARCHAR(20),PartPackQty),
								CONVERT(VARCHAR(20),PartPackCount),
								PackageType
								PartPackCount
								FROM
									@AuditTrailPartPackGroup
								WHERE
									part = @part
																				

							OPEN
								PartPackSerialGroup

							WHILE
								1 = 1 BEGIN
																				
								FETCH
									 PartPackSerialGroup
								INTO
									@PartPackQty,
									@PartPackCount,
									@PackageType
																						
								IF	@@FETCH_STATUS != 0 BEGIN
									BREAK
								END
																								
									INSERT	#ASNFlatFile (LineData)
									SELECT  '13' +  @PartPackCount + Space(3) + @PackageType 
									
									INSERT	#ASNFlatFile (LineData)
									SELECT  '14' +  @PartPackQty + 'PCE'
									
									INSERT	#ASNFlatFile (LineData)
									SELECT  '15' + @PCIQualifier

										DECLARE PartPackSerials CURSOR LOCAL FOR

										SELECT	
										Serial
										FROM
										@AuditTrailLooseSerial
										WHERE
										part = @part
										and PackageType = rtrim(@PackageType)
										and SerialQuantity = Convert(int, rtrim(@PartpackQty))
																		
										OPEN
										PartPackSerials

										WHILE
										1 = 1 BEGIN

										FETCH
										PartPackSerials
										INTO
										@Serial
																						
										IF	@@FETCH_STATUS != 0 BEGIN
										BREAK
										END
																								
										INSERT	#ASNFlatFile (LineData)
										SELECT  '16' +  @Serial + 'ML '
										
										END							
										CLOSE
										PartPackSerials
										DEALLOCATE
										PartPackSerials
								END
																				
								CLOSE
								PartPackSerialGroup
								DEALLOCATE
								PartPackSerialGroup
																		
														
																					
					
	

		SELECT @SupplierPart = @Part
		INSERT	#ASNFlatFile (LineData)
		SELECT  '18' 
				+ @CustomerPart + space(3) + @SupplierPart + 'SA '
				


		INSERT	#ASNFlatFile (LineData)
		SELECT  '19' 
				+ @IMDpartDescription
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '20' 
				+ @PartQty
				+ @UM
				
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '21' 
				+ @CountryOfOrigin
				
		
		INSERT	#ASNFlatFile (LineData)
		SELECT  '28' 
				+ @CustomerPO
				+ @CustomerPOLine 
				
	END	
	
	
CLOSE
	PartPOLine	
 
DEALLOCATE
	PartPOLine


SELECT 
	(CONVERT(CHAR(79),LineData) + RIGHT(CONVERT(CHAR(2), (lineID)),1))
FROM 
	#ASNFlatFile
ORDER BY 
	LineID

	
	      
SET ANSI_PADDING OFF

END






GO
