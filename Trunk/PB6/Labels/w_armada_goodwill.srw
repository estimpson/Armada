$PBExportHeader$w_armada_goodwill.srw
forward
global type w_armada_goodwill from Window
end type
end forward

global type w_armada_goodwill from Window
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
global w_armada_goodwill w_armada_goodwill

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
String s_name
String szshipper
Long   lSerial

Dec {0} dQuantity

DATETIME    ldt_Date
DATETIME		ldt_time
DATE			ddate
TIME			ttime


/////////////////////////////////////////////////
//  Initialization
//

lSerial = Long(Stparm.Value1)

  SELECT object.part,   
         object.location,   
         object.unit_measure,   
         object.operator,   
         object.quantity,
			object.shipper,
			object.last_date
	INTO  :szPart,   
         :szLoc,   
         :szUnit,   
         :szOperator,   
         :dQuantity,
			:sz_obj_shipper,
			:ldt_date
    FROM object  
   WHERE object.serial = :lSerial   ;

dDate = Date ( ldt_Date )
tTime = Time ( ldt_Time )

//	select audit_trail.date_stamp
//		into :ldt_Date
//		from audit_trail 
//		where audit_trail.serial = :lserial and 
//		audit_trail.type = 'J';

//d_FirstDayOfYear = Date ( Year ( dDate ), 1, 1 )
//i_JulianDate = 10 * ( DaysAfter ( d_FirstDAyOfYear, dDate ) + 1 ) + Mod ( Year ( dDate ), 10 )

szP = Stparm.Value2
  SELECT part.part, 
		  part.description_short,
			PART.NAME 
    INTO :szTemp, 
			:szDescription ,
		   :S_NAME
    FROM part  
   WHERE part.part = :szPart   ;

SELECT parameters.company_name, address_1, address_2, address_3
	INTO :szCompany,
		  :szAddress1,
			:szAddress2,
			:szAddress3
	From parameters ;
	
SELECT shipper_detail.shipper  
    INTO :szShipper  
    FROM shipper_detail ;

  	SELECT order_header.customer_part,
			isnull(shipper_detail.customer_po,''),
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
PrintSend ( ll_Label, cEsc + "V040" + cEsc + "H300" + cEsc + "M" + "PART NO" )
PrintSend ( ll_Label, cEsc + "V060" + cEsc + "H300" + cEsc + "M" + "(P)" )
PrintSend ( ll_Label, cEsc + "V020" + cEsc + "H440" + cEsc + "$A,150,150,0" + cEsc + "$=" + UPPER(szcustpart) )
PrintSend ( ll_Label, cEsc + "V151" + cEsc + "H300" + cEsc + "B104095" + "*" + "P" + UPPER(szcustpart) + "*" )

PrintSend ( ll_Label, cEsc + "V263" + cEsc + "H300" + cEsc + "M" + "QUANTITY" )
PrintSend ( ll_Label, cEsc + "V283" + cEsc + "H300" + cEsc + "M" + "(Q)" )
PrintSend ( ll_Label, cEsc + "V233" + cEsc + "H490" + cEsc + "$A,150,150,0" + cEsc +"$=" + String(dQuantity) )
PrintSend ( ll_Label, cEsc + "V362" + cEsc + "H300" + cEsc + "B104095" + "*" +"Q" + String(dQuantity) + "*" )

PrintSend ( ll_Label, cEsc + "V263" + cEsc + "H920" + cEsc + "M" + "PO NUMBER" )
PrintSend ( ll_Label, cEsc + "V283" + cEsc + "H920" + cEsc + "M" + "(K)" )
PrintSend ( ll_Label, cEsc + "V270" + cEsc + "H970" + cEsc + "$A,85,105,0" + cEsc +"$=" + upper(String(sz_custpo)) )
PrintSend ( ll_Label, cEsc + "V362" + cEsc + "H900" + cEsc + "B103095" + "*" +"K" + upper(String(sz_custpo)) + "*" )

PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H0920" + cEsc + "$A,35,40,0" + cEsc + "$=" + sz_zone_code)
PrintSend ( ll_Label, cEsc + "V530" + cEsc + "H0920" + cEsc + "$A,35,40,0" + cEsc + "$=" + sz_line_feed_code )
PrintSend ( ll_Label, cEsc + "V580" + cEsc + "H0920" + cEsc + "$A,35,40,0" + cEsc + "$=" + sz_dock_code )
PrintSend ( ll_Label, cEsc + "V580" + cEsc + "H1145" + cEsc + "$A,35,40,0" + cEsc + "$="+ "DOCK CODE" )
PrintSend ( ll_Label, cEsc + "V630" + cEsc + "H0920" + cEsc + "M" + "MFG. DATE" )
PrintSend ( ll_Label, cEsc + "V655" + cEsc + "H0920" + cEsc + "$A,40,40,0" + cEsc + "$=" +STRING(DATE( ldt_Date) ) )
PrintSend ( ll_Label, cEsc + "V655" + cEsc + "H1145" + cEsc + "$A,40,40,0" + cEsc + "$=" + sz_obj_shipper) 
PrintSend ( ll_Label, cEsc + "V630" + cEsc + "H1145" + cEsc + "M" + "SHIPPER" )
PrintSend ( ll_Label, cEsc + "V705" + cEsc + "H0920" + cEsc + "M" + "INT.PART NO." )
PrintSend ( ll_Label, cEsc + "V720" + cEsc + "H0920" + cEsc + "$A,35,40,0" + cEsc + "$=" + upper(String(szTemp)) )
PrintSend ( ll_Label, cEsc + "V705" + cEsc + "H1145" + cEsc + "M" + "DESCRIPTION" )
PrintSend ( ll_Label, cEsc + "V720" + cEsc + "H1145" + cEsc + "$A,35,40,0" + cEsc + "$=" + s_name )

PrintSend ( ll_Label, cEsc + "V479" + cEsc + "H300" + cEsc + "M" + "SUPPLIER" )
PrintSend ( ll_Label, cEsc + "V499" + cEsc + "H300" + cEsc + "M" + "(V)" )
PrintSend ( ll_Label, cEsc + "V475" + cEsc + "H470" + cEsc + "WL1" + szSupplier )
PrintSend ( ll_Label, cEsc + "V520" + cEsc + "H300" + cEsc + "B103095" + "*" + "V" + szSupplier + "*" )

PrintSend ( ll_Label, cEsc + "V631" + cEsc + "H300" + cEsc + "M" + "LOT/SERIAL" )
PrintSend ( ll_Label, cEsc + "V650" + cEsc + "H300" + cEsc + "M" + "(S)" )
PrintSend ( ll_Label, cEsc + "V625" + cEsc + "H470" + cEsc + "WL1" + String(lSerial))
PrintSend ( ll_Label, cEsc + "V670" + cEsc + "H300" + cEsc + "B103095" + "*" + "S" + String(lSerial) + "*")

PrintSend ( ll_Label, cEsc + "V772" + cEsc + "H300" + cEsc + "M" + "Made at Armada Rubber Mfg Co 24586 Armada Ridge Rd Armada, MI 48005 USA" )

//  Draw Lines
PrintSend ( ll_Label, cEsc + "N" )
//PrintSend ( ll_Label, cEsc + "V395" + cEsc + "H618" + cEsc + "FW03H0519" )
PrintSend ( ll_Label, cEsc + "V540" + cEsc + "H254" + cEsc + "FW03H0509" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H251" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H467" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H618" + cEsc + "FW03V1127" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H698" + cEsc + "FW03V0505" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H570" + cEsc + "FW03V0505" )
PrintSend ( ll_Label, cEsc + "V030" + cEsc + "H519" + cEsc + "FW03V0505" )

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

on w_armada_goodwill.create
end on

on w_armada_goodwill.destroy
end on

