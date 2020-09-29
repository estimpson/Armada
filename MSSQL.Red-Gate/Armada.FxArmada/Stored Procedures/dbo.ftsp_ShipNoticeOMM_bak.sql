SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO





Create PROCEDURE [dbo].[ftsp_ShipNoticeOMM_bak]  (@shipper INT)
AS
BEGIN

--[dbo].[ftsp_ShipNoticeOMM] 295609
/*


    FlatFile Layout for Overlay: OMM_856_D_v3020__01082015    



*/

SET ANSI_PADDING ON
--ASN Header

DECLARE
	@TradingPartner	CHAR(12),
	@ShipperID CHAR(16),
	@ShipperID2 CHAR(8),
	@PartialComplete CHAR(1),
	@PurposeCode CHAR(2) = '00',
	@ASNDate CHAR(6),
	@ASNTime CHAR(4),
	@ShippedDateQual CHAR(3),
	@ShippedDate CHAR(6),
	@ShippedTime CHAR(4),
	@EstArrivalDateQual CHAR(3),
	@EstArrivalDate CHAR(8),
	@EstArrivalTime CHAR(8),
	@TimeZone CHAR(2),
	@Mea01RefID CHAR(2) = 'PD',
	@GrossWeightQualifier CHAR(1) ='G',
	@GrossWeightLbs CHAR(10),
	@NetWeightQualifier CHAR(1) = 'N',
	@NetWeightLbs CHAR(10),
	@WeightUM CHAR(2) = 'LB',
	@CompositeUM CHAR(78),
	@PackagingCode CHAR(5),
	@PackCount CHAR(4),
	@SCAC CHAR(4),
	@TransMode CHAR(2),
	@LocationQualifier CHAR(2),
	@PPCode CHAR(7),
	@EquipDesc CHAR(2),
	@EquipInit CHAR(4),
	@TrailerNumber CHAR(10),
	@REFBMQual CHAR(2),
	@REFPKQual CHAR(2),
	@REFPKQual2 CHAR(3),
	@REFCNQual CHAR(2),
	@REFBMValue CHAR(16),
	@REFPKValue CHAR(16),
	@REFCNValue CHAR(16),
	@FOB CHAR(2),
	@ProNumber CHAR(16),
	@SealNumber CHAR(8),
	@SupplierName CHAR(35),
	@SupplierCode CHAR(17),
	@ShipToName CHAR(35),
	@ShipToID CHAR(17),
	@BilltoCode CHAR(17) = 'OMMC',
	@ShipToQualifier CHAR(2) = 'ST',
	@ShipFromQualifier CHAR(2) = 'SF',
	@SupplierQualifier CHAR(2)= 'SU',	
	@ShipToIDType CHAR(2) = '92',	
	@ShipFromIDType CHAR(2) = '92',
	@SupplierIDType CHAR(2) ='92',
	@AETCResponsibility CHAR(1),
	@AETC CHAR(8),
	@DockCode CHAR(8),
	@PoolCode CHAR(30),
	@EquipInitial CHAR(4),
	@TransitDays INT,
	@SCACQualifier CHAR(2)
	
	SELECT
		@TradingPartner	= es.trading_partner_code ,
		@ShipperID =  s.id,
		@ShipperID2 =  s.id,
		@PartialComplete = 'P' ,
		@PurposeCode = '00',
		@ASNDate = CONVERT(CHAR, GETDATE(), 12) ,
		@ASNTime = LEFT(REPLACE(CONVERT(CHAR, GETDATE(), 108), ':', ''),4),
		@ShippedDateQual = '011',
		@ShippedDate = CONVERT(CHAR, s.date_shipped, 12)  ,
		@ShippedTime =  LEFT(REPLACE(CONVERT(CHAR, date_shipped, 108), ':', ''),4),
		@TimeZone = [dbo].[udfGetDSTIndication](date_shipped),
		@EstArrivalDateQual = '017',
		@GrossWeightLbs = CONVERT(CHAR,CONVERT(INT,s.gross_weight)),
		@NetWeightLbs = CONVERT(CHAR,CONVERT(INT,s.net_weight)),
		@PackagingCode = 'MIX90' ,
		@PackCount = s.staged_objs,
		@SCAC = s.ship_via,
		@SCACQualifier = '2',
		@TransMode = s.trans_mode ,
		@TrailerNumber = COALESCE(NULLIF(s.truck_number,''), CONVERT(VARCHAR(25),s.id)),
		@REFBMQual = 'BM' ,
		@REFPKQual = 'PK',
		@REFPKQual2 = 'PK',
		@REFCNQual = 'CN',
		@REFBMValue = COALESCE(bill_of_lading_number, id),
		@REFPKValue = id,
		@REFCNValue = pro_number,
		@FOB = case when freight_type =  'Collect' then 'CC' when freight_type in  ('Consignee Billing', 'Third Party Billing') then 'TP' when freight_type  in ('Prepaid-Billed', 'PREPAY AND ADD') then 'PA' when freight_type = 'Prepaid' then 'PP' else 'CC' end ,
		@SupplierName = 'Empire Electronics, Inc.' ,
		@SupplierCode = coalesce(es.supplier_code, '10768') ,
		@ShipToName =  left(d.name,30),
		@ShipToID = COALESCE(nullif(es.EDIShipToID,''),nullif(es.parent_destination,''),es.destination),	
		@AETCResponsibility = case when upper(left(aetc_number,2)) = 'CE' then 'A' when upper(left(aetc_number,2)) = 'SR' then 'S' when upper(left(aetc_number,2)) = 'CR' then 'Z' else '' end,
		@AETC =coalesce(s.aetc_number,''),
		@LocationQualifier =case when s.trans_mode in ('A', 'AC','AE') then 'OR'  when isNull(nullif(pool_code,''),'-1') = '-1' then '' else 'PP' end,
		@PoolCode = case when s.trans_mode in ('A', 'AC','AE') then Left(s.pro_number,3)  when s.trans_mode in ('E', 'U') then '' else coalesce(pool_code,'') end,
		@EquipDesc = coalesce( es.equipment_description, 'TL' ),
		@EquipInitial = coalesce( left(truck_number,4), s.ship_via ),
		@SealNumber = coalesce(s.seal_number,''),
		@Pronumber = coalesce(s.pro_number,''),
		@DockCode = coalesce(s.shipping_dock, ''),
		@GrossWeightQualifier = 'G',
		@NetWeightQualifier = 'N',
		@WeightUM = 'LB',
		@CompositeUM = 'LB',
		@TransitDays = case when id_code_type like '%[A-Z]%' then 0 else convert(int, isNull(nullif(id_code_type,''),0)) end 
		
	from
		Shipper s
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	left join
		dbo.bill_of_lading bol on s.bill_of_lading_number = bol_number
	where
		s.id = @shipper
	
	
select  @EstArrivalDate = dateadd(dd, @TransitDays, @shippedDate)
select	@EstArrivalTime = @ShippedTime


Create	table	#ASNFlatFileHeader (
				LineId	int identity (1,1),
				DetailLineID int,
				LineData char(80))

INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('//STX12//856'+  @TradingPartner + @ShipperID + @PartialComplete ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('01'+  @PurposeCode + @ShipperID + @ASNDate + @ASNTime +  @ShippedDate + @ShippedTime + @TimeZone  + @GrossWeightLbs  + @NetWeightLbs),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('02' + @PackagingCode + @PackCount  ),1	
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('03' +  @SCAC + @TransMode +  @PoolCode ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('04' + @REFBMValue + @REFCNValue ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('05' + SPACE(16) + @REFPKValue ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('06' + @SealNumber ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('07' + @SupplierCode + @SupplierCode + SPACE(17) + @ShiptoID ),1
INSERT	#ASNFlatFileHeader (LineData, DetailLineID)
	SELECT	('08' + @ShipToID + @DockCode + @AETCResponsibility + @AETC ),1


 --ASN Detail

DECLARE	@ShipperDetail TABLE (
	PackingSlip VARCHAR(25),
	ShipperID INT,
	CustomerPart VARCHAR(35),
	CustomerPO VARCHAR(35),
	SDQty INT,
	SDAccum INT,
	EngLevel VARCHAR(25),
	PRIMARY KEY (CustomerPart, CustomerPO, PackingSlip)
	)

INSERT @ShipperDetail
			( 
			PackingSlip ,
			ShipperID,
			CustomerPart ,
			CustomerPO ,
			SDQty ,
			SDAccum ,
			EngLevel 
          
        )	
SELECT
	MAX(sd.shipper),
	MAX(sd.shipper),
	sd.Customer_Part,
	COALESCE(sd.Customer_PO,''),
	SUM(sd.alternative_qty),
	MAX(sd.Accum_Shipped),
	MAX(COALESCE(oh.engineering_level,''))
	
FROM
	shipper s
JOIN
	dbo.shipper_detail sd ON s.id  = sd.shipper AND sd.shipper =  @shipper
LEFT JOIN
	order_header oh ON sd.order_no = oh.order_no
WHERE part NOT LIKE 'CUM%'
GROUP BY
sd.Customer_Part,
COALESCE(sd.Customer_PO,'')
		

	
	
	
DECLARE	@ShipperSerials TABLE (
	CustomerPart VARCHAR(35),
	CustomerPO VARCHAR(35),
	PackageType VARCHAR(25),
	PackQty INT,
	Serial INT
	PRIMARY KEY (CustomerPart, Serial)
	)

INSERT @ShipperSerials          
      	
 SELECT
	sd.customer_part,
	sd.customer_po,
	'CTN90',
	at.quantity,
	at.serial 
	
FROM
	audit_trail at
JOIN
		shipper_detail sd ON sd.part_original =  at.part AND  sd.shipper = @shipper
WHERE
	at.type ='S'  AND at.shipper =  CONVERT(VARCHAR(10), @shipper)
AND 
	at.part != 'PALLET' 

	
ORDER BY 1 ASC, 3 ASC, 4 ASC

--Select		*	from		@shipperDetail order by packingslip
--Select		*	from		@shipperserials

--Delcare Variables for ASN Details		
DECLARE	
	@CustomerPartBP CHAR(2) = 'BP',
	@CustomerPartEC CHAR(2) = 'EC',
	@CustomerPart CHAR(30) ,
	@ReturnableContainer CHAR(30) = 'EXP0121109' ,
	@CustomerECL CHAR(3),
	@CustomerPartLoop VARCHAR(35),
	@CustomerPOLoop VARCHAR(35),
	@PackTypeLoop VARCHAR(35),
	@QtyPackedLoop INT,
	@QtyPacked CHAR(12),
	@UM CHAR(2) ='PC' ,
	@AccumShipped CHAR(11),
	@CustomerPO CHAR(13),
	@ContainerCount CHAR(6),
	@PackageType CHAR(5),
	@PackQty CHAR(12),
	@PackQtyLoop INT,
	@SerialQualifier CHAR(3) = 'LS',
	@SerialNumber CHAR(30)
	

CREATE	TABLE	#FlatFileLines (
				LineId	INT IDENTITY(1,1),
				DetailLineID INT,
				LineData CHAR(80)
				 )

DECLARE
	PartPOLine CURSOR LOCAL FOR
SELECT
	        CustomerPart ,
	        CustomerPO ,
	        SDQty ,
	        'EA',
	        SDAccum ,
	        EngLevel
FROM
	@ShipperDetail SD
	ORDER BY
		CustomerPart

OPEN
	PartPOLine
WHILE
	1 = 1 BEGIN
	
	FETCH
		PartPOLine
	INTO
		@CustomerPartLoop ,
		@CustomerPOLoop,
		@QtyPackedLoop,
		@UM,
		@AccumShipped,
		@CustomerECL 
			
	IF	@@FETCH_STATUS != 0 BEGIN
		BREAK
	END
	
	--print @ASNOverlayGroup

	SELECT @CustomerPart = @CustomerPartLoop
	SELECT @CustomerPO =  @CustomerPOLoop
	SELECT @QtyPacked = @QtyPackedLoop
	SELECT @PackQty = MAX(PackQty) FROM @ShipperSerials WHERE CustomerPart = @CustomerPartLoop
	
		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('09'+ @CustomerpartBP + @CustomerPart +  @CustomerECL + @ReturnableContainer + @PackQty /*+  @QtyPacked*/   ),2

		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('10'+  @UM + @AccumShipped   ),2
	
				
										
					
									DECLARE PackSerial CURSOR LOCAL FOR
									SELECT	
										Serial
									FROM
										@ShipperSerials
									WHERE					
										CustomerPart = @CustomerPartLoop AND
										CustomerPO = @CustomerPOLoop
									
									OPEN	PackSerial
									WHILE	1 = 1 
									BEGIN
									FETCH	PackSerial	INTO
									@SerialNumber
					
									IF	@@FETCH_STATUS != 0 BEGIN
									BREAK
									END
									
									INSERT	#FlatFileLines (LineData,  DetailLineID)
									SELECT	('11'+  @SerialNumber   ), 2
					
									END
									CLOSE PackSerial
									DEALLOCATE PackSerial
										
				
		INSERT	#FlatFileLines (LineData, DetailLineID)
		SELECT	('12' +  + @CustomerPO   ),2
						
END
CLOSE	PartPOLine 
DEALLOCATE	PartPOLine
	


CREATE	TABLE
	#ASNResultSet (FFdata  CHAR(80), DetailLineID INT, LineID INT)

INSERT #ASNResultSet
        ( FFdata, DetailLIneID, LineID )

SELECT
	CONVERT(CHAR(80), LineData), DetailLineID, LineID
FROM	
	#ASNFlatFileHeader

INSERT
	#ASNResultSet (FFdata, DetailLineID, LineID)
SELECT
	CONVERT(CHAR(80), LineData) , DetailLineID, LineID
FROM	
	#FlatFileLines
	
SELECT	FFdata
FROM		#ASNResultSet
ORDER BY DetailLineID, LineID ASC

      
SET ANSI_PADDING OFF	
END
         














GO
