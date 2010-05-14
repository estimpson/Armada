$PBExportHeader$w_armada_gmlean.srw
$PBExportComments$armada gmlean label 6/26
forward
global type w_armada_gmlean from Window
end type
end forward

global type w_armada_gmlean from Window
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
global w_armada_gmlean w_armada_gmlean

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
			szuser_defined_1, &
			s_Temp, &
			s_Name1, &
			s_Name2, &
			s_Name3, &
			s_NumberofLabels, &
			s_Suffix, &
         szcompany, &
         s_linfedcod, &
			szaddress1, &
			szaddress2, &
			szaddress3, &
			s_blanket_part, &
			szeng, &
			sz_dock_code , &
			sz_custom02, &
			sz_part, &
			s_name, &
			sz_plant, &
			s_dest, &
			sz_custom03

Date	dDate  

		Datetime	ldt_last_Date

Dec {0} dec_Quantity

///////////////////////////////////////////////
//  Initialization
//

l_Serial = LONG ( AST_PARM.VALUE1 )

  SELECT part,   
         quantity,   
			destination,
         shipper,
			plant
    INTO :s_Part,   
         :dec_Quantity,   
			:s_destination,
         :l_shipper,
			:sz_plant
    FROM object  
   WHERE serial = :l_Serial   ;

		select audit_trail.date_stamp
		into :ldt_last_Date
		from audit_trail 
		where audit_trail.serial = :l_serial and 
		( audit_trail.type = 'J' or audit_trail.type ='R') ;

 		dDate = Date( ldt_last_Date )

		SELECT order_header.customer_part,
				order_header.line_feed_code,
				order_header.BLANKET_PART,
				order_header.dock_code,
				order_header.custom02,
				shipper.destination,
				order_header.custom03
		INTO :s_Cupart,
			 : s_linfedcod,
			 :s_BLANKET_PART,
			 :sz_dock_code,
			 :sz_custom02, 	
			 :s_Destination,
			 :sz_custom03
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :l_Serial  ; 

  SELECT edi_setups.supplier_code  
    INTO :s_Supplier  
    FROM edi_setups  
   WHERE edi_setups.destination = :s_destination   ;  
SELECT supplier_code  
    INTO :s_Supplier  
    FROM edi_setups  
   WHERE destination = :s_destination   ;

  SELECT	customer,destination
    INTO	:s_Customer,
			:s_dest
    FROM	destination
   WHERE destination = :s_Destination     ;

  SELECT customer_part 
    INTO :s_cupart
    FROM shipper_detail
   WHERE part = :s_part and shipper = :l_shipper;

// in case if it not found in the above table find it in the part master

  if isnull(s_cupart) or s_cupart = ''  then
 	 SELECT cross_ref
  	  INTO :s_cupart  
 	  FROM part  
 	  WHERE part = :s_part;
  end if  

// To get the order number from the shipper detail table 

  SELECT order_no
    INTO :l_ordno
    FROM shipper_detail
   WHERE shipper = :l_shipper and part = :s_part;
 
// to get the line_feed code from the order header table

  SELECT order_header.line_feed_code,
		  order_header.blanket_part	 
    INTO :s_linfedcod,
		  :s_blanket_part 
    FROM order_header
   WHERE order_no = :l_ordno;

	SELECT part.user_defined_1, Part.Part,Part.name
    INTO :szuser_defined_1,
			:sz_part,
			:s_name
    FROM part  
   WHERE part.part = :s_Part   ;
 
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
PrintSend ( l_Label, c_Esc + "V058" + c_Esc + "H300" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V078" + c_Esc + "H300" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V020" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc + "$=" + s_cuPart )
PrintSend ( l_Label, c_Esc + "V150" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "P" + s_cuPart + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H300" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H300" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H500" + c_Esc + "$A,150,150,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H350" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H0845" + c_Esc + "M" + "DLOC" )
PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H0845" + c_Esc + "$A,100,140,0" + c_Esc + "$=" + UPPER(s_linfedcod ))

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H1065" + c_Esc + "M" + "PLANT:" )
PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H1065" + c_Esc + "$A,100,140,0" + c_Esc + "$=" + sz_custom03 )

PrintSend ( l_Label, c_Esc + "V380" + c_Esc + "H845" + c_Esc + "M" + "DOCK CODE:" )
PrintSend ( l_Label, c_Esc + "V380" + c_Esc + "H1010" + c_Esc + "$A,40,55,0" + c_Esc + "$=" + upper(sz_dock_code) )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H450" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "LOT/SERIAL" )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H270" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H520" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H320" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H1073" + c_Esc + "M" + "INTERNAL PART NO. " )
PrintSend ( l_Label, c_Esc + "V654" + c_Esc + "H1073" + c_Esc +  "$A,35,45,0" + c_Esc + "$=" + s_blanket_part )
PrintSend ( l_Label, c_Esc + "V710" + c_Esc + "H1073" + c_Esc + "M" + "MFG. DATE" )
PrintSend ( l_Label, c_Esc + "V730" + c_Esc + "H1073" + c_Esc + "$A,35,45,0" + c_Esc + "$=" + STRING(Ddate))

PrintSend ( l_Label, c_Esc + "V785" + c_Esc + "H325" + c_Esc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V597" + c_Esc + "H251" + c_Esc + "FW03H0220" )
PrintSend ( l_Label, c_Esc + "V377" + c_Esc + "H470" + c_Esc + "FW03H0290" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1150" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_gmlean.create
end on

on w_armada_gmlean.destroy
end on

