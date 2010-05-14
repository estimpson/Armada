$PBExportHeader$w_armada_mercury.srw
forward
global type w_armada_mercury from Window
end type
end forward

global type w_armada_mercury from Window
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
global w_armada_mercury w_armada_mercury

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
String sz_order_type
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

  SELECT object.part,   
         object.location,   
         object.unit_measure,   
         object.operator,   
         object.quantity,
			object.shipper
	INTO  :szPart,   
         :szLoc,   
         :szUnit,   
         :szOperator,   
         :dQuantity,
			:sz_obj_shipper   
         FROM object  
   WHERE object.serial = :lSerial   ;

//dDate = Date ( ldt_Date )
//tTime = Time ( ldt_Time )

	select audit_trail.date_stamp
		into :ldt_Date
		from audit_trail 
		where audit_trail.serial = :lserial and 
		audit_trail.type = 'J';

//d_FirstDayOfYear = Date ( Year ( dDate ), 1, 1 )
//i_JulianDate = 10 * ( DaysAfter ( d_FirstDAyOfYear, dDate ) + 1 ) + Mod ( Year ( dDate ), 10 )

szP = Stparm.Value2
  SELECT part.part, 
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

  	SELECT order_header.customer_part,
			order_header.customer_po,
	  		order_header.zone_code,
			order_header.line_feed_code,
			order_header.dock_code,
			order_header.order_type,
			order_header.order_no,
			shipper.destination
		INTO :szCustpart,
			 :sz_custpo,
			 :sz_zone_code,
			 :sz_line_feed_code,
			 :sz_dock_code,
			 :sz_order_type,
			 :sz_order_no,
			 :szDestination
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :lSerial  ; 
			
			if sz_custpo = ""  then
	
				SELECT a.release_no
				  INTO :sz_custpo
				  From shipper_detail, object ,order_detail as a
				 WHERE shipper_detail.order_no = a.order_no AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :lSerial AND
			a.due_date IN 
			( SELECT Min ( b.due_date )
				FROM	order_detail as b
			  WHERE	b.order_no = a.order_no )  ; 

			end if 
			
//		WHERE order_detail.order_no = :sz_order_no and
//						 		order_detail.sequence = 1;

			 

	SELECT edi_setups.supplier_code  
    INTO :szSupplier  
    FROM edi_setups  
   WHERE edi_setups.destination = :szdestination   ;

If Stparm.value11 = "" Then 
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If

szSupplier = Stparm.value3
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
PrintSend ( ll_Label, cEsc + "V040" + cEsc + "H1000" + szLabelname )

//  Part Info
PrintSend ( ll_Label, cEsc + "V040" + cEsc + "H346" + cEsc + "M" + "PART NO" )
PrintSend ( ll_Label, cEsc + "V060" + cEsc + "H346" + cEsc + "M" + "(P)" )
PrintSend ( ll_Label, cEsc + "V020" + cEsc + "H460" + cEsc + "$A,150,150,0" + cEsc + "$=" + UPPER(szcustpart) )
PrintSend ( ll_Label, cEsc + "V151" + cEsc + "H381" + cEsc + "B103095" + "*" + "P" + UPPER(szcustpart) + "*" )

PrintSend ( ll_Label, cEsc + "V263" + cEsc + "H346" + cEsc + "M" + "QUANTITY" )
PrintSend ( ll_Label, cEsc + "V288" + cEsc + "H346" + cEsc + "M" + "(Q)" )
PrintSend ( ll_Label, cEsc + "V233" + cEsc + "H520" + cEsc + "$A,150,150,0" + cEsc +"$=" + String(dQuantity) )
PrintSend ( ll_Label, cEsc + "V359" + cEsc + "H381" + cEsc + "B103095" + "*" +"Q" + String(dQuantity) + "*" )

PrintSend ( ll_Label, cEsc + "V263" + cEsc + "H900" + cEsc + "M" + "PO NUMBER" )
PrintSend ( ll_Label, cEsc + "V288" + cEsc + "H900" + cEsc + "M" + "(A)" )
PrintSend ( ll_Label, cEsc + "V270" + cEsc + "H940" + cEsc + "$A,85,105,0" + cEsc +"$=" + upper(String(sz_custpo)) )
PrintSend ( ll_Label, cEsc + "V359" + cEsc + "H900" + cEsc + "B103095" + "*" +"Q" + upper(String(sz_custpo)) + "*" )

PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H0900" + cEsc + "M" + "DELIVERY TO:" )
PrintSend ( ll_Label, cEsc + "V500" + cEsc + "H0900" + cEsc + "M" + "(D)" )
PrintSend ( ll_Label, cEsc + "V475" + cEsc + "H1100" + cEsc + "WL1" + sz_line_feed_code )
PrintSend ( ll_Label, cEsc + "V518" + cEsc + "H900" + cEsc + "B103095" + "*" + "D" + sz_line_feed_code + "*" )

//PrintSend ( ll_Label, cEsc + "V580" + cEsc + "H0905" + cEsc + "$A,35,40,0" + cEsc + "$=" + sz_dock_code )

PrintSend ( ll_Label, cEsc + "V630" + cEsc + "H0905" + cEsc + "M" + "MFG. DATE" )
PrintSend ( ll_Label, cEsc + "V655" + cEsc + "H0905" + cEsc + "$A,40,40,0" + cEsc + "$=" +STRING(DATE( ldt_Date) ) )
PrintSend ( ll_Label, cEsc + "V705" + cEsc + "H0905" + cEsc + "M" + "INTERNAL PART NO." )
PrintSend ( ll_Label, cEsc + "V720" + cEsc + "H0905" + cEsc + "$A,35,40,0" + cEsc + "$=" + upper(String(szTemp)) )

PrintSend ( ll_Label, cEsc + "V479" + cEsc + "H350" + cEsc + "M" + "SUPPLIER" )
PrintSend ( ll_Label, cEsc + "V504" + cEsc + "H350" + cEsc + "M" + "(V)" )
PrintSend ( ll_Label, cEsc + "V475" + cEsc + "H500" + cEsc + "WL1" + szSupplier )
PrintSend ( ll_Label, cEsc + "V518" + cEsc + "H381" + cEsc + "B103095" + "*" + "V" + szSupplier + "*" )
PrintSend ( ll_Label, cEsc + "V655" + cEsc + "H1145" + cEsc + "$A,40,40,0" + cEsc + "$=" + sz_obj_shipper) 
PrintSend ( ll_Label, cEsc + "V630" + cEsc + "H1145" + cEsc + "M" + "SHIPPER" )


//PrintSend ( ll_Label, cEsc + "V631" + cEsc + "H346" + cEsc + "M" + "LOT/SERIAL" )
PrintSend ( ll_Label, cEsc + "V656" + cEsc + "H346" + cEsc + "M" + "(S)" )
PrintSend ( ll_Label, cEsc + "V625" + cEsc + "H500" + cEsc + "WL1" + String(lSerial))
PrintSend ( ll_Label, cEsc + "V668" + cEsc + "H381" + cEsc + "B103095" + "*" + "S" + String(lSerial) + "*")

PrintSend ( ll_Label, cEsc + "V770" + cEsc + "H325" + cEsc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( ll_Label, cEsc + "N" )
PrintSend ( ll_Label, cEsc + "V537" + cEsc + "H254" + cEsc + "FW03H0509" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H251" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H467" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H618" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H698" + cEsc + "FW03V0510" )
//PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H570" + cEsc + "FW03V0510" )
//PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H519" + cEsc + "FW03V0510" )

PrintSend ( ll_Label, cEsc + szNumberofLabels )
PrintSend ( ll_Label, cEsc + "Z" )
PrintClose ( ll_Label )
Close ( this )


//  		 if  sz_order_type ='N' then
//
//		 	 SELECT order_detail.customer_part , order_detail.order_no
//		 	  INTO :szcustpart,
//					 :sz_order_no  
// 	  		  FROM  order_detail, object, order_header, shipper_detail 
// 	        WHERE order_detail.order_no = order_header.order_no AND
//			        order_detail.part_number = object.part AND
//					  shipper_detail.shipper = object.shipper AND
//					  shipper_detail.part_original = object.part AND
//		      	  object.serial = :lSerial ; 
				 
//		 end if 

end event
on w_armada_mercury.create
end on

on w_armada_mercury.destroy
end on
