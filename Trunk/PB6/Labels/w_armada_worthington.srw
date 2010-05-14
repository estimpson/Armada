$PBExportHeader$w_armada_worthington.srw
forward
global type w_armada_worthington from Window
end type
end forward

global type w_armada_worthington from Window
int X=672
int Y=264
int Width=1582
int Height=992
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armada_worthington w_armada_worthington

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

Int f_length
Int s_length

String cEsc         // Escape Code
String szLoc        // Location
String szLot        // Material Lot
String szUnit       // Unit Of Measure
String szOperator   // Operator
String szPart
String szDescription
String szdestination
String szSupplier
String szCompany, szEng
String szTemp
String szName1
String szName2
String szName3
String szAddress1, szAddress2, szAddress3
String szNumberofLabels
String s_CustomerPart
String S_CUPART
String szsecond
String szfirst
String s_linefeed
String s_dockcode
String s_zonecode
String s_supplier
String s_custom
Long   lSerial
Long 	 lposition

Dec {0} dQuantity, nPo

Time tTime

Date dDate

datetime dt_date_time

/////////////////////////////////////////////////
//  Initialization
//

//lSerial = Message.DoubleParm
lSerial = Long(Stparm.Value1)
  SELECT object.part,   
         object.lot,   
         object.location,   
         object.last_date,   
         object.unit_measure,   
         object.operator,   
         object.quantity,   
         object.last_time, po_number,
			object.destination
    INTO :szPart,   
         :szLot,   
         :szLoc,   
         :dt_Date_time,   
         :szUnit,   
         :szOperator,   
         :dQuantity,   
         :dt_date_Time, 
			:nPo,
			:szdestination 
    FROM object  
   WHERE object.serial = :lSerial   ;

   ddate = date(dt_date_time)
   ttime = time(dt_date_time)

  SELECT order_header.customer_part,
			order_header.line_feed_code,
			order_header.dock_code, 
			order_header.zone_code, 
			order_header.custom02
		INTO :s_cupart,
			  :s_linefeed,
			  :s_dockcode,
			  :s_zonecode,
			  :s_custom	
	 FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper =object.origin AND
			shipper_detail.part_original = object.part AND
			object.serial = :lSerial  ; 	

// in case if it not found in the above table find it in the part master

//  if s_cupart = '' or isnull(s_cupart) then
// 	 SELECT cross_ref
//  	  INTO :s_cupart  
// 	  FROM part  
// 	  WHERE part = :szpart;
//  end if  
 
 SELECT part.name,
			part.description_short
    INTO :szTemp,
			:szDescription 
   FROM part  
   WHERE part.part = :szPart   ;

SELECT parameters.company_name, address_1, address_2, address_3
	INTO :szCompany,
		  :szAddress1,
			:szAddress2,
			:szAddress3
	From parameters ;

  SELECT part_mfg.engineering_level  
    INTO :szEng  
    FROM part_mfg  
   WHERE part_mfg.part = :szPart   ;

If Stparm.value11 = "" Then
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If

//szSupplier = Stparm.Value3

szName1 = Mid ( szTemp, 1, 10 )
szName2 = Mid ( szTemp, 11, 10 )
szName3 = Mid ( szTemp, 21, 10 )

cEsc = "~h1B"

lposition = 8 //Pos ( sztemp, " " ,10 )
f_length  = len ( sztemp )

IF f_length < 15 THEN
	szFirst = sztemp
   szSecond = ""
ELSE
	szFirst   = Left ( sztemp, 8 )
	s_length  = len ( szFirst )
	szSecond  = Mid ( sztemp, 9 , f_length - s_length )
END IF

/////////////////////////////////////////////////
//  Main Routine
//

ll_Label = PrintOpen ( )

//  Start Printing

PrintSend ( ll_label, cEsc + "A" )
PrintSend ( ll_Label, cEsc + "R" )
PrintSend ( ll_Label, cEsc + "AR" )

//  Part Info
PrintSend ( ll_Label, cEsc + "V057" + cEsc + "H200" + cEsc + "M" + "PDM #" )
//PrintSend ( ll_Label, cEsc + "V077" + cEsc + "H200" + cEsc + "M" + "(P)" )
PrintSend ( ll_Label, cEsc + "V026" + cEsc + "H310" + cEsc + "$A,110,130,0" + cEsc + "$=" + UPPER(s_custom) )
PrintSend ( ll_Label, cEsc + "V159" + cEsc + "H200" + cEsc + "B103095" + "*" + "P" + s_custom + "*" )

//QTY
PrintSend ( ll_Label, cEsc + "V275" + cEsc + "H200" + cEsc + "M" + "QUANTITY" )
//PrintSend ( ll_Label, cEsc + "V295" + cEsc + "H200" + cEsc + "M" + "(Q)" )
PrintSend ( ll_Label, cEsc + "V273" + cEsc + "H390" + cEsc + "$A,110,110,0" + cEsc +"$=" + String ( dQuantity ) )
PrintSend ( ll_Label, cEsc + "V369" + cEsc + "H200" + cEsc + "B103095" + "*" +"Q" + String ( dQuantity ) + "*" )

//SUPPLIER
PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H200" + cEsc + "M" + "SUPPLIER  " )
PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H330" + cEsc + "L0202" + cEsc + "WL1" + String( szsupplier ) )
//PrintSend ( ll_Label, cEsc + "V500" + cEsc + "H200" + cEsc + "M" + "(V)" )
//PrintSend ( ll_Label, cEsc + "V523" + cEsc + "H200" + cEsc + "B103095" + "*" + "V" + "s_supplier" + "*")

//SERIAL
PrintSend ( ll_Label, cEsc + "V637" + cEsc + "H200" + cEsc + "L0101" + cEsc + "M" + "SERIAL # " )
PrintSend ( ll_Label, cEsc + "V657" + cEsc + "H250" + cEsc + "L0202" + cEsc +  "WL1" + String ( lSerial ) )
//PrintSend ( ll_Label, cEsc + "V661" + cEsc + "H200" + cEsc + "M" + "(S)" )
//PrintSend ( ll_Label, cEsc + "V683" + cEsc + "H246" + cEsc + "B103095" + "*" + "S" + String( lserial ) + "*" )

//PLT ROUTING
PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H840" + cEsc + "L0101" + cEsc +  "M" + "ZONE CODE" )
PrintSend ( ll_Label, cEsc + "V495" + cEsc + "H840" + cEsc + "WL1" +  UPPER(S_zonecode) )
PrintSend ( ll_label, cEsc + "V560" + cEsc + "H840" + cEsc + "M" + "DOCK CODE" 	)
PrintSend ( ll_label, cEsc + "V570" + cEsc + "H840" + cEsc + "WL1" + String(s_dockcode) )

//DATE
PrintSend ( ll_Label, cEsc + "V657" + cEsc + "H840" + cEsc + "M" + "MFG DATE" )
PrintSend ( ll_Label, cEsc + "V657" + cEsc + "H1000" + cEsc + "WB1" + STRING(dDate) )
PrintSend ( ll_Label, cEsc + "V275" + cEsc + "H735" + cEsc + "M" + "PART # AND DESCRIPTION" )
PrintSend ( ll_Label, cEsc + "V305" + cEsc + "H1050" + cEsc + "WL1" + szfirst )
PrintSend ( ll_Label, cEsc + "V365" + cEsc + "H1050" + cEsc + "WL1" + szsecond )
PrintSend ( ll_label, cEsc + "V305" + cEsc + "H735" + cEsc + "WL1" + STRING(s_cupart) )

//ENG CHANGE
PrintSend ( ll_Label, cEsc + "V705" + cEsc + "H840" + cEsc + "M" + "LINE FEED CODE" )
PrintSend ( ll_Label, cEsc + "V705" + cEsc + "H1000" + cEsc + "WL1" + String(s_linefeed) )
PrintSend ( ll_Label, cEsc + "V785" + cEsc + "H255" + cEsc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
//PrintSend ( ll_Label, cEsc + "A" )
PrintSend ( ll_Label, cEsc + "V270" + cEsc + "H190" + cEsc + "FW02H1175" )
PrintSend ( ll_Label, cEsc + "V475" + cEsc + "H190" + cEsc + "FW02H1175" )
PrintSend ( ll_Label, cEsc + "V632" + cEsc + "H190" + cEsc + "FW02H1175" )
PrintSend ( ll_Label, cEsc + "V270" + cEsc + "H725" + cEsc + "FW02V208" )
PrintSend ( ll_Label, cEsc + "V475" + cEsc + "H830" + cEsc + "FW02V300" )
PrintSend ( ll_Label, cEsc + "V700" + cEsc + "H835" + cEsc + "FW02H530" )
PrintSend ( ll_label, cEsc + "V554" + cEsc + "H835" + cEsc + "FW02H530" )
PrintSend ( ll_Label, cEsc + szNumberofLabels )
PrintSend ( ll_Label, cEsc + "Z" )
PrintClose ( ll_Label )
Close ( this )
end event
on w_armada_worthington.create
end on

on w_armada_worthington.destroy
end on

