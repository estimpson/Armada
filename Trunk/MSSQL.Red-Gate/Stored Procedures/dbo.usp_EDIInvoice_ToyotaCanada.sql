SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE PROCEDURE [dbo].[usp_EDIInvoice_ToyotaCanada]  (@shipper INT)
AS
BEGIN
-- Test
-- Exec [dbo].[usp_EDIInvoice_ToyotaCanada] '69450'

/* 
  
    FlatFile Layout for Overlay: TMC_810_D_v3040_TOYOTA CANADA_100608     03-03-14 11

    Fixed Record/Fixed Field (FF)        Max Record Length: 080

    Input filename: DX-FX-FF.080         Output filename: DX-XF-FF.080


    Description                                            Type Start Length Element 

    Header Record '//'                                      //   001   002           

       RESERVED (MANDATORY)('STX12//')                      ID   003   007           

       X12 TRANSACTION ID (MANDATORY X12)                   ID   010   003           

       TRADING PARTNER (MANDATORY)                          AN   013   012           

       DOCUMENT NUMBER (MANDATORY)                          AN   025   030           

       FOR PARTIAL TRANSACTION USE A 'P' (OPTIONAL)         ID   055   001           

       EDIFACT(EXTENDED) TRANSACTION ID (MANDATORY EDIFACT) ID   056   010           

       DOCUMENT CLASS CODE (OPTIONAL)                       ID   066   006           

       OVERLAY CODE (OPTIONAL)                              ID   072   003           

       FILLER('      ')                                     AN   075   006           

       Record Length:                                                  080           

    Record '01'                                             01   001   002           

       INVOICE DATE                                         DT   003   006    1BIG01 

       INVOICE #                                            AN   009   016    1BIG02 

       PO DATE                                              DT   025   006    1BIG03 

       PO #                                                 AN   031   015    1BIG04 

       CURRENCY CODE                                        AN   046   003    1CUR02 

       FILLER('                                ')           AN   049   032           

       Record Length:                                                  080           

    Loop Start (200000 x - End Record '03')                                          

       Record '02'                                          02   001   002           

          TMMC KANBAN #                                     AN   003   004    1IT101 

          QUANTITY INVOICED                                 R    007   012    1IT102 

          UNIT OF MEASURE                                   AN   019   002    1IT103 

          UNIT PRICE                                        R    021   016    1IT104 

          TMMC PART #                                       AN   037   012    1IT107 

          FILLER('                                ')        AN   049   032           

          Record Length:                                               080           

       Record '03' (10 x - End Record '03')                 03   001   002           

          TAX TYPE CODE                                     AN   003   002    1TXI01 

                                          1
    Description                                            Type Start Length Element 

          TAX AMOUNT                                        R    005   017    1TXI02 

          ('                                            ... AN   022   059           

          Record Length:                                               080           

    Record '04'                                             04   001   002           

       TOTAL INVOICE AMOUNT                                 N    003   012    1TDS01 

       ('                                               ... AN   015   066           

       Record Length:                                                  080           

*/

set ANSI_Padding on


--Declare Variables for 810 Flat File

Declare @1BIG01InvoiceDate char(6),
				@1BIG02InvoiceNumber char(16),
				@1BIG04PONumber char(15),
				@1CUR02CurrencyCode char(3) = 'USD',
				@1IT101KanbanNumber char(4), 
				@1IT102QtyInvoiced char(12), 
				@1IT103QtyInvoicedUM char(2) = 'PC' , 
				@1IT104UnitPrice char(16),
				@1IT102QtyInvoicedNumeric numeric(20,6), 
				@1IT104UnitPriceNumeric numeric(20,6),
				@1IT106PartQualifier char(2) = 'BP',
				@1IT107CustomerPart char(12),
				@1TXI01TaxCode char(2),
				@1TXI02TaxAmount char(17),
				@1TDS01InvoiceAmount char(12),
				@PartNumber varchar(25),

				@TradingPartner	char(12),
				@ShipperIDHeader char(30) = @shipper,
				@PartialComplete char(1)  = 'P'

select
		top 1
		@1BIG01InvoiceDate= CONVERT(VARCHAR(25), s.date_shipped, 12) ,
		@1BIG02InvoiceNumber = coalesce(nullif(es.supplier_code,''),'7497A') + coalesce(nullif(d.address_6,''), '12345'), --address 6 needs to be a 5 digit Toyota Plant Code
		@1BIG04PONumber = coalesce(nullif(es.supplier_code,''),'7497A') + coalesce(nullif(s.shipping_dock,''), '5A') + coalesce(nullif(sd.customer_po,''), '12345678'),
		@TradingPartner = es.trading_partner_code

		


	from
		Shipper s
		join
		shipper_detail sd on sd.shipper =  s.id
	join
		dbo.edi_setups es on s.destination = es.destination
	join
		dbo.destination d on es.destination = d.destination
	join
		dbo.customer c on c.customer = s.customer
	
	where
		s.id = @shipper




declare	@InvoiceDetail table (
	KanbanNumber varchar(25),
	PartNumber varchar(25),
	CustomerPart varchar(50),
	QtyShipped int,
	Price numeric(20,6),
	TaxCode varchar(5),
	TaxAmount numeric(20,6))
	
insert	@InvoiceDetail 
(	KanbanNumber,
	PartNumber,
	CustomerPart,
	QtyShipped,
	Price,
	TaxCode,
	TaxAmount
	)
	
select
	
	coalesce(p.drawing_number, 'M700'),
	sd.part_original,
	sd.customer_part,
	sd.qty_packed,
	sd.alternate_price,
	coalesce((case coalesce(sd.taxable,'N') when 'Y' then 'ST' else 'ST' end),'ST'),
	coalesce((case coalesce(sd.taxable,'N') when 'Y' then sd.alternate_price*sd.qty_packed*(d.salestax_rate/100) else 0 end),0)
from
	shipper_detail sd
join
	part p on p.part = sd.part_original
join
	shipper s on s.id = @shipper
join
	order_header oh on oh.order_no =  sd.order_no
join
		destination d on d.destination = s.destination
Where
	sd.shipper = @shipper 


		--Create temporary table to store flat file rows
	
	
	Create	table	#ASNFlatFile (
				LineId	int identity,
				LineData char(79) )


	INSERT	#ASNFlatFile (LineData)
	SELECT	('//STX12//810'
						+  @TradingPartner 
						+  @ShipperIDHeader
						+  'P' )

INSERT	#ASNFlatFile (LineData)
	SELECT	(	'01'
				+		@1BIG01InvoiceDate
				+		@1BIG02InvoiceNumber
				+		@1BIG01InvoiceDate
				+		@1BIG04PONumber
				+		@1CUR02CurrencyCode
						)


declare
	InvoiceLine cursor local for
select
	KanbanNumber,
	PartNumber,
	Customerpart
	,	round(QtyShipped,0)
	,	round(Price,4)
	,	round(QtyShipped,0)
	,	round(Price,4)
	, TaxCode
	, coalesce(TaxAmount,0) 
From
	@InvoiceDetail InvoiceDetail


open
	InvoiceLine

while
	1 = 1 begin
	
	fetch
		InvoiceLine
	into
		@1IT101KanbanNumber,
		@PartNumber,
		@1IT107CustomerPart
	,	@1IT102QtyInvoiced
	, @1IT104UnitPrice
	,	@1IT102QtyInvoicedNumeric
	, @1IT104UnitPriceNumeric
	,	@1TXI01TaxCode
	, @1TXI02TaxAmount
			
			
	if	@@FETCH_STATUS != 0 begin
		break
	end



	Insert	#ASNFlatFile (LineData)
					Select  '02' 									
							+ @1IT101KanbanNumber
							+ @1IT102QtyInvoiced
							+ @1IT103QtyInvoicedUM
							+ @1IT104UnitPrice
							+ @1IT107CustomerPart

	Insert	#ASNFlatFile (LineData)
					Select  '03' 									
							+ @1TXI01TaxCode
							+ @1TXI02TaxAmount
								
end
close
	InvoiceLine	
 
deallocate
	InvoiceLine	

	

--Select @1TDS01InvoiceAmount = substring(convert(varchar(max),round(sum(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)),1,patindex('%.%', convert(varchar(max),round(sum(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)))-1 ) +
--		substring(convert(varchar(max),round(sum(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)),patindex('%.%', convert(varchar(max),round(sum(@1IT102QtyInvoicedNumeric*@1IT104UnitPriceNumeric) ,2)))+1, 2)


Select 
		@1TDS01InvoiceAmount = Sum(round((QtyShipped*Price),2 ) + round(TaxAmount,2) )
From 
		@InvoiceDetail


Insert	#ASNFlatFile (LineData)
					Select  '04' 									
							+ @1TDS01InvoiceAmount




select 
LineData +convert(char(1), (lineID % 2 ))
	
From 
	#ASNFlatFile
order by 
	LineID


	      
set ANSI_Padding OFF	
End
         




















GO
