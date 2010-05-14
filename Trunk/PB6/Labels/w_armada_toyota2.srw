$PBExportHeader$w_armada_toyota2.srw
forward
global type w_armada_toyota2 from Window
end type
end forward

global type w_armada_toyota2 from Window
int X=641
int Y=269
int Width=1541
int Height=981
boolean TitleBar=true
string Title="Untitled"
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armada_toyota2 w_armada_toyota2

on open;///////////////////////////////
//Declaration
//
st_generic_structure   ast_parm
ast_Parm = Message.PowerObjectParm

LONG		l_Label, &
			l_Serial, &
			l_position, &
			l_pos_string, & 
         l_ordno, & 
         l_shipper

STRING	s_Esc, &
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
		  s_coname1,  &
		  s_coname2,  &
		  s_pname1,  &
		  s_pname2,  &
		  s_name,  &
		  s_staddress1,  &
		  s_staddress2,  &
		  s_address	
		  
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

  SELECT 	order_header.zone_code,order_header.line_feed_code,order_header.dock_code,
			shipper.destination
		INTO :s_zone,
			 :s_linefeed,
			 :s_dock,	
			 :s_Destination
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :l_Serial  ; 

	SELECT part.name  
    INTO :s_name
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

INTEGER  l_i_break
l_i_break  = Pos ( szcompany, ' ' , 1 )
IF l_i_break > 0  THEN
	s_coname1 = Left ( szcompany, l_i_break - 1 )
	s_coname2 = Mid ( szcompany, l_i_break + 1, Len ( szcompany ) - l_i_break )
ELSE
	s_coname1 = Left ( szcompany, 25 )
	s_coname2 = " "
END IF 

s_pname1 = MID ( s_name, 1,35)
s_pname2 = MID ( s_name, 36,35)

s_staddress1 = MID (s_address, 1,9)
s_staddress2 = MID (s_address, 10,1)

	S_DOCKCODE = MID (S_DOCK,1,3)

// to get the number of copies of the label 

If ast_Parm.value11 = "" Then 
	s_NumberofLabels = "Q1"
Else
	s_NumberofLabels = "Q" + ast_Parm.value11
End If

s_Esc = "~h1B"
//////////////////////////////
//Main Routine
//

l_label = PrintOpen ()

//Start Printing
PrintSend (l_label, s_esc + "A" + s_esc + "%1")
PrintSend (l_label, s_esc + "AX" )

//Supplier
PrintSend (l_label, s_esc + "V1465" + s_esc + "H230" + s_esc + "M" + "SUPPLIER")
PrintSend (l_label, s_esc + "V1390" + s_esc + "H250" + s_esc + "$B,040,090,0" + s_esc + "$=" + s_supplier)
PrintSend (l_label, s_esc + "V1500" + s_esc + "H330" + s_esc + "D103070" + "*" + s_supplier + "*" )

//Quantity
PrintSend (l_label, s_esc + "V1465" + s_esc + "H430" + s_esc + "M" + "QUANTITY")
PrintSend (l_label, s_esc + "V1360" + s_esc + "H440" + s_esc + "$B,060,110,0" + s_esc + "$=" + STRING (dec_quantity))
PrintSend (l_label, s_esc + "V1500" + s_esc + "H540" + s_esc + "B103070" + "*" + STRING(dec_quantity) + "*" )
 
//Serial No.
PrintSend (l_label, s_esc + "V1465" + s_esc + "H635" + s_esc + "M" + "SERIAL NO.")
PrintSend (l_label, s_esc + "V1405" + s_esc + "H660" + s_esc + "$B,040,090,0" + s_esc + "$=" + String (l_serial))
PrintSend (l_label, s_esc + "V1510" + s_esc + "H750" + s_esc + "B103070" + "*" + STRING(l_serial) + "*" )

//Part Number
PrintSend (l_label, s_esc + "V1085" + s_esc + "H230" + s_esc + "M" + "PART NUMBER")
PrintSend (l_label, s_esc + "V1050" + s_esc + "H260" + s_esc + "$B,040,090,0" + s_esc + "$=" + s_cupart)
PrintSend (l_label, s_esc + "V715" + s_esc + "H240" + s_esc + "B103090" + "*" + s_cupart + "*" )

//Kanban
PrintSend (l_label, s_esc + "V1085" + s_esc + "H350" + s_esc + "M" + "KANBAN NUMBER")
PrintSend (l_label, s_esc + "V940" + s_esc + "H350" + s_esc + "$B,110,170,0" + s_esc + "$=" + s_linefeed )

//Dock Code
PrintSend (l_label, s_esc + "V1085" + s_esc + "H500" + s_esc + "M" + "DOCK CODE")
PrintSend (l_label, s_esc + "V920" + s_esc + "H500" + s_esc + "$A,110,170,0" + s_esc + "$=" + s_dockcode)

//Store Address
PrintSend (l_label, s_esc + "V1085" + s_esc + "H680" + s_esc + "M" + "STORE ADDRESS")
PrintSend (l_label, s_esc + "V1010" + s_esc + "H720" + s_esc + "$B,060,110,0" + s_esc + "$=" + UPPER(s_zone))
//PrintSend (l_label, s_esc + "V690" + s_esc + "H680" + s_esc + "$B,110,150,0" + s_esc + "$=" + s_staddress2)

//Manufacture Date
PrintSend (l_label, s_esc + "V500" + s_esc + "H350" + s_esc + "M" + "MANUFACTURE DATE")
PrintSend (l_label, s_esc + "V480" + s_esc + "H380" + s_esc + "$B,040,090,0" + s_esc + "$=" + String (dDate, "mm/dd/yy")) 

//Supplier Name
PrintSend (l_label, s_esc + "V500" + s_esc + "H500" + s_esc + "M" + "SUPPLIER NAME")
PrintSend (l_label, s_esc + "V490" + s_esc + "H510" + s_esc + "$A,040,090,0" + s_esc + "$=" + s_coname1)
PrintSend (l_label, s_esc + "V490" + s_esc + "H580" + s_esc + "$A,040,090,0" + s_esc + "$=" + s_coname2)

//Description
PrintSend (l_label, s_esc + "V500" + s_esc + "H680" + s_esc + "M" + "DESCRIPTION")
PrintSend (l_label, s_esc + "V490" + s_esc + "H690" + s_esc + "$A,040,090,0" + s_esc + "$=" + s_pname1)
PrintSend (l_label, s_esc + "V490" + s_esc + "H760" + s_esc + "$A,040,090,0" + s_esc + "$=" + s_pname2)

//Draw Lines
PrintSend (l_label, s_esc + "N")
PrintSend (l_label, s_esc + "V013" + s_esc + "H345" + s_esc + "FW03V1095")
PrintSend (l_label, s_esc + "V013" + s_esc + "H495" + s_esc + "FW03V1095")
PrintSend (l_label, s_esc + "V013" + s_esc + "H670" + s_esc + "FW03V1095")
PrintSend (l_label, s_esc + "V1110" + s_esc + "H225" + s_esc + "FW03H635")
PrintSend (l_label, s_esc + "V510" + s_esc + "H345" + s_esc + "FW03H520")
PrintSend (l_label, s_esc + "V1110" + s_esc + "H425" + s_esc + "FW03V425")
PrintSend (l_label, s_esc + "V1110" + s_esc + "H630" + s_esc + "FW03V425")

PrintSend (l_label, s_esc + s_NumberofLabels)
PrintSend (l_label, s_esc + "Z")
PrintClose (l_label)
Close (This)


end on

on w_armada_toyota2.create
end on

on w_armada_toyota2.destroy
end on

