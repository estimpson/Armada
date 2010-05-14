$PBExportHeader$w_armada_chrysler_032403.srw
forward
global type w_armada_chrysler_032403 from Window
end type
end forward

global type w_armada_chrysler_032403 from Window
int X=672
int Y=268
int Width=1586
int Height=992
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armada_chrysler_032403 w_armada_chrysler_032403

type variables
St_generic_structure ast_Parm
end variables

event open;/////////////////////////////////////////////////
//  Declaration
//

ast_Parm = Message.PowerObjectParm

LONG		l_Label, &
			l_Serial, &
			l_position, &
			l_pos_string, & 
         l_ordno, & 
         l_shipper

STRING	c_Esc, &
			s_Part, &
			s_CuPart, &
			s_Customer, &
			s_destination, &
			s_Supplier, &
			s_Eng, &
			s_Temp, &
			s_Dock, &
			s_Name1, &
			s_Name2, &
			s_Name3, &
			s_NumberofLabels, &
			s_Suffix, &
         s_zone, &
		  SZADDRESS1, &
		  SZADDRESS2, &
		  SZADDRESS3, &
		  SZCOMPANY 
		  
		Date	dDate  

		Datetime	ldt_last_Date

//INTEGER i_julianDate
//
	Dec {0} dec_Quantity
//
//DATETIME ldt_Date, &
//		  ldt_Time
//
//time tTime
//
	 
//			d_FirstDayofYear 	
/////////////////////////////////////////////////
//  Initialization
//

l_Serial = LONG ( ast_Parm.Value1 )

  SELECT part,   
         quantity,   
		  destination,
          shipper
    INTO :s_Part,   
         :dec_Quantity,   
		  :s_destination,
         :l_shipper 
		  
    FROM object  
   where serial = :l_Serial   ;

		select audit_trail.date_stamp
		into :ldt_last_Date
		from audit_trail 
		where audit_trail.serial = :l_serial and 
		( audit_trail.type = 'J' or audit_trail.type ='R') ;

 		dDate = Date( ldt_last_Date )
 
//	FOR MFG. JULIAN DATE

//d_FirstDayOfYear = Date ( Year ( dDate ), 1, 1 )
//i_JulianDate = 10 * ( DaysAfter ( d_FirstDayOfYear, dDate ) + 1 ) + Mod ( Year ( dDate ), 10 )

  SELECT 	order_header.zone_code,
			shipper.destination, 
			order_header.engineering_level,
			order_header.dock_code
		INTO :s_zone,
			 :s_Destination,
			 :s_Eng,
			 :s_Dock
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :l_Serial  ; 

	SELECT part.name  
    INTO :s_Temp 
    FROM part  
   WHERE part = :s_Part ;

  SELECT supplier_code  
    INTO :s_Supplier  
    FROM edi_setups  
   WHERE destination = :s_destination   ;

//  SELECT engineering_level
//    INTO :s_Eng 
//    FROM part_mfg  
//   WHERE part = :s_Part   ;

  SELECT	customer
    INTO	:s_Customer
    FROM	destination
   WHERE destination = :s_Destination     ;

  SELECT customer_part 
    INTO :s_cupart
    FROM shipper_detail
   WHERE part = :s_part and shipper = :l_shipper;

// in case if it not found in the above table find it in the part master

  if s_cupart < '' or isnull(s_cupart) then
 	 SELECT cross_ref
  	  INTO :s_cupart  
 	  FROM part  
 	  WHERE part = :s_part;
  end if  

  SELECT parameters.company_name, address_1, address_2, address_3
	INTO :szCompany,
		  :szAddress1,
			:szAddress2,
			:szAddress3
	From parameters ;

// to get the number of copies of the label 

If ast_Parm.value11 = "" Then 
	s_NumberofLabels = "Q1"
Else
	s_NumberofLabels = "Q" + ast_Parm.value11
End If

c_Esc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

l_Label = PrintOpen ( )

//  Start Printing
PrintSend ( l_Label, c_Esc + "A" + c_Esc + "R" )
PrintSend ( l_Label, c_Esc + "AR" )

//  Part Info
PrintSend ( l_Label, c_Esc + "V040" + c_Esc + "H300" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V060" + c_Esc + "H300" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V010" + c_Esc + "H450" + c_Esc + "$A,155,170,0" + c_Esc + "$=" + s_cuPart )
PrintSend ( l_Label, c_Esc + "V155" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "P" + s_cuPart + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H300" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H300" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H500" + c_Esc + "$A,150,150,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H350" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H943" + c_Esc + "M" + "DESCRIPTION" )
PrintSend ( l_Label, c_Esc + "V310" + c_Esc + "H943" + c_Esc + "OB" + S_TEMP )
PrintSend ( l_Label, c_Esc + "V365" + c_Esc + "H943" + c_Esc + "M" + "MFG. DATE " )
PrintSend ( l_Label, c_Esc + "V410" + c_Esc + "H943" + c_Esc + "OB" + string(dDate) )
PrintSend ( l_Label, c_Esc + "V365" + c_Esc + "H1200" + c_Esc + "M" + "CHANGE LETTER" )
PrintSend ( l_Label, c_Esc + "V410" + c_Esc + "H1200" + c_Esc + "WL1" + STRING(s_Eng ) )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H500" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H953" + c_Esc + "M" + "ZONE CODE" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H953" + c_Esc + "$A,150,150,0" + c_Esc +"$="  + S_ZONE)

//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "LOT/SERIAL" )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H300" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H550" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V780" + c_Esc + "H325" + c_Esc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H943" + c_Esc + "M" + "INTERNAL PART NO." )
//PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H953" + c_Esc + "M" + "PART NO." )
PrintSend ( l_Label, c_Esc + "V670" + c_Esc + "H949" + c_Esc + "WL1" + s_part )
//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H1200" + c_Esc + "M" + "DOCK CODE" )
PrintSend ( l_Label, c_Esc + "V670" + c_Esc + "H1200" + c_Esc + "WL1" + STRING(s_dock ) )


//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V497" + c_Esc + "H254" + c_Esc + "FW03H0515" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H354" + c_Esc + "FW03V0460")
PrintSend ( l_Label, c_Esc + "V245" + c_Esc + "H354" + c_Esc + "FW03H0115")

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_chrysler_032403.create
end on

on w_armada_chrysler_032403.destroy
end on

