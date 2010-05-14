$PBExportHeader$w_armada_nummi.srw
forward
global type w_armada_nummi from Window
end type
end forward

global type w_armada_nummi from Window
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
global w_armada_nummi w_armada_nummi

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
			l_weight, &
         l_shipper

STRING	c_Esc, &
			s_Part, &
			s_CuPart, &
			s_Customer, &
			s_destination, &
			s_Supplier, &
			s_Eng, &
			s_Temp, &
			s_Name1, &
			s_Name2, &
			s_Name3, &
			s_NumberofLabels, &
			s_Suffix, &
         s_zone, &
		  SZADDRESS1, &
		  SZADDRESS2, &
		  SZADDRESS3, &
		  SZCOMPANY , &	
		  S_LINEFEED, &
		  S_DOCK	, &
		  S_DOCKCODE, &
		  s_FRS
		  
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

		select audit_trail.date_stamp,audit_trail.weight
		into :ldt_last_Date,
			  :l_weight	
		from audit_trail
				where audit_trail.serial = :l_serial and 
		( audit_trail.type = 'J' or audit_trail.type ='R') ;

 		dDate = Date( ldt_last_Date )
 
//	FOR MFG. JULIAN DATE

//d_FirstDayOfYear = Date ( Year ( dDate ), 1, 1 )
//i_JulianDate = 10 * ( DaysAfter ( d_FirstDayOfYear, dDate ) + 1 ) + Mod ( Year ( dDate ), 10 )

  SELECT 	order_header.zone_code,order_header.line_feed_code,order_header.dock_code,
			shipper.destination,shipper_detail.release_no
		INTO :s_zone,
			 :s_linefeed,
			 :s_dock,	
			 :s_Destination,
			 :s_FRS
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

  SELECT engineering_level
    INTO :s_Eng 
    FROM part_mfg  
   WHERE part = :s_Part   ;

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

	S_DOCKCODE = MID (S_DOCK,1,3)

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
PrintSend ( l_Label, c_Esc + "V040" + c_Esc + "H280" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V060" + c_Esc + "H280" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V010" + c_Esc + "H430" + c_Esc + "$A,155,170,0" + c_Esc + "$=" + s_cuPart )
PrintSend ( l_Label, c_Esc + "V153" + c_Esc + "H280" + c_Esc + "B104095" + "*" + "P" + s_cuPart + "*" )

//QTY
PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H280" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V283" + c_Esc + "H280" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H425" + c_Esc + "$A,120,140,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H280" + c_Esc + "B104095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H735" + c_Esc + "M" + "DOCK CODE" )
PrintSend ( l_Label, c_Esc + "V300" + c_Esc + "H735" + c_Esc + "$A,120,140,0" + c_Esc +"$=" + s_DOCKCODE )

//KANBAN NO.
PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H933" + c_Esc + "M" + "KANBAN NUMBER" )
PrintSend ( l_Label, c_Esc + "V300" + c_Esc + "H939" + c_Esc + "$A,120,140,0" + c_Esc +"$=" + s_linefeed )

//SUPPLIER CODE
PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H280" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V499" + c_Esc + "H280" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H450" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V520" + c_Esc + "H280" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H933" + c_Esc + "M" + "DESCRIPTION" )
PrintSend ( l_Label, c_Esc + "V510" + c_Esc + "H933" + c_Esc + "$A,075,075,0" + c_Esc +"$="  + S_TEMP )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H715" + c_Esc + "M"  + "BOX WGHT LBS" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H740" + c_Esc + "$A,120,140,0" + c_Esc +"$=" + string(l_weight) )

//FRS #
PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "FRS #" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H500" + c_Esc + "$A,115,140,0" + c_Esc +"$="  + String(s_FRS))
PrintSend ( l_Label, c_Esc + "V780" + c_Esc + "H280" + c_Esc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H933" + c_Esc + "M" + "STORE ADDRESS" )
PrintSend ( l_Label, c_Esc + "V635" + c_Esc + "H939" + c_Esc + "$A,115,140,0" + c_Esc +"$="  + UPPER(s_ZONE) )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V527" + c_Esc + "H254" + c_Esc + "FW03H0515" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V720" + c_Esc + "H254" + c_Esc + "FW03H0360")

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_nummi.create
end on

on w_armada_nummi.destroy
end on

