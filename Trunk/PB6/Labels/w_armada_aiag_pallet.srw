$PBExportHeader$w_armada_aiag_pallet.srw
forward
global type w_armada_aiag_pallet from Window
end type
end forward

global type w_armada_aiag_pallet from Window
int X=672
int Y=264
int Width=1591
int Height=1012
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armada_aiag_pallet w_armada_aiag_pallet

type variables
St_generic_structure Stparm
end variables

event open;//  Standard label for job completion

/////////////////////////////////////////////////
//  Declaration
//
Stparm = Message.PowerObjectParm

//Int iLabel		  // 16-bit Open Handle
Long ll_Label		  // 32-bit Open Handle

String cEsc         // Escape Code
String szLoc        // Location
String szUnit       // Unit Of Measure
String szOperator   // Operator
String szPart, szP
String szDescription
String szdestination
String szSupplier
String szCompany 
String szTemp
String szName1
String szName2
String szName3
String szAddress1, szAddress2, szAddress3
String szNumberofLabels
String szLabelname
String sz_custpo
String szcustpart
String sz_zone_code
String sz_line_feed_code
String sz_dock_code
String sz_order_no
String sz_release_no
String sz_obj_shipper
Long   lSerial

Dec {0} dQuantity

DATETIME    ldt_Date


/////////////////////////////////////////////////
//  Initialization
//

lSerial = Long(Stparm.Value1)

   SELECT sum(object_b.quantity)
	INTO	:dQuantity  
    FROM  object object_b, object object_a 
   WHERE (object_a.part  = 'PALLET' ) AND
         (object_a.serial = object_b.parent_serial ) AND
			(object_a.serial = :lSerial)  ; 

SELECT parameters.company_name, address_1, address_2, address_3
	INTO :szCompany,
		  :szAddress1,
			:szAddress2,
			:szAddress3
	From parameters ;

	SELECT order_header.customer_part,
			 order_header.destination
	INTO   :szCustpart,
			 :szdestination
	FROM   order_header, shipper_detail, shipper, object
	WHERE  order_header.order_no = shipper_detail.order_no AND
			 shipper.id = shipper_detail.shipper AND
			 shipper_detail.shipper = object.shipper AND
			object.part = 'PALLET' AND
			 object.serial = :lSerial  ; 

//szSupplier = Stparm.value3
	
	SELECT edi_setups.supplier_code  
    INTO :szSupplier  
    FROM edi_setups,order_header,shipper  
   WHERE edi_setups.destination = order_header.destination AND
			edi_setups.destination = :szdestination   ;

If Stparm.value11 = "" Then 
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If

szName1 = Mid ( szTemp, 1, 20 )
szName2 = Mid ( szTemp, 21, 20 )
szName3 = Mid ( szTemp, 41, 20 )

cEsc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

ll_Label = PrintOpen ( )

//  Start Printing
PrintSend ( ll_Label, cEsc + "A" + cEsc + "R" )
PrintSend ( ll_Label, cEsc + "AR" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H1000" + szLabelname )

PrintSend ( ll_Label, cEsc + "V025" + cEsc + "H300" + cEsc + "$A,180,220,0" + cEsc + "$=" + "MASTER LABEL" )

//  Part Info
PrintSend ( ll_Label, cEsc + "V235" + cEsc + "H300" + cEsc + "M" + "PART NO" )
PrintSend ( ll_Label, cEsc + "V255" + cEsc + "H300" + cEsc + "M" + "(P)" )
PrintSend ( ll_Label, cEsc + "V215" + cEsc + "H430" + cEsc + "$A,120,120,0" + cEsc + "$=" + UPPER(szcustpart) )
PrintSend ( ll_Label, cEsc + "V315" + cEsc + "H300" + cEsc + "B103095" + "*" + "P" + UPPER(szcustpart) + "*" )

//QTY
PrintSend ( ll_Label, cEsc + "V440" + cEsc + "H300" + cEsc + "M" + "QUANTITY" )
PrintSend ( ll_Label, cEsc + "V460" + cEsc + "H300" + cEsc + "M" + "(Q)" )
PrintSend ( ll_Label, cEsc + "V420" + cEsc + "H450" + cEsc + "$A,95,105,0" + cEsc +"$=" + String(dQuantity) )
PrintSend ( ll_Label, cEsc + "V520" + cEsc + "H300" + cEsc + "B103095" + "*" +"Q" + String(dQuantity) + "*" )

//SUPPLIER
PrintSend ( ll_Label, cEsc + "V440" + cEsc + "H900" + cEsc + "M" + "SUPPLIER" )
PrintSend ( ll_Label, cEsc + "V460" + cEsc + "H900" + cEsc + "M" + "(V)" )
PrintSend ( ll_Label, cEsc + "V443" + cEsc + "H950" + cEsc + "$A,75,95,0" + cEsc +"$=" + UPPER(szSupplier) )
PrintSend ( ll_Label, cEsc + "V520" + cEsc + "H900" + cEsc + "B103095" + "*" +"V" + szSupplier + "*" )

//SERIAL
PrintSend ( ll_Label, cEsc + "V631" + cEsc + "H300" + cEsc + "M" + "SERIAL" )
PrintSend ( ll_Label, cEsc + "V650" + cEsc + "H300" + cEsc + "M" + "(4S)" )
PrintSend ( ll_Label, cEsc + "V625" + cEsc + "H400" + cEsc + "WL1" + String(lSerial))
PrintSend ( ll_Label, cEsc + "V668" + cEsc + "H300" + cEsc + "B103095" + "*" + "4S" + String(lSerial) + "*")

PrintSend ( ll_Label, cEsc + "V770" + cEsc + "H280" + cEsc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( ll_Label, cEsc + "N" )
PrintSend ( ll_Label, cEsc + "V537" + cEsc + "H425" + cEsc + "FW03H0330" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H221" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H425" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H618" + cEsc + "FW03V1127" )

PrintSend ( ll_Label, cEsc + szNumberofLabels )
PrintSend ( ll_Label, cEsc + "Z" )
PrintClose ( ll_Label )
Close ( this )




end event
on w_armada_aiag_pallet.create
end on

on w_armada_aiag_pallet.destroy
end on

