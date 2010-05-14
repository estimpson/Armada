$PBExportHeader$w_armada_ford.srw
$PBExportComments$/armada ford label 7/15
forward
global type w_armada_ford from Window
end type
end forward

global type w_armada_ford from Window
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
global w_armada_ford w_armada_ford

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
			s_Temp, &
			s_Name1, &
			s_Name2, &
			s_Name3, &
			s_NumberofLabels, &
			s_Suffix, &
         szcompany, &
        	szaddress1, &
			szaddress2, &
			szaddress3, &
			s_blanket_part, &
			szeng,&
			S_LINE_FEED_CODE, &
			S_DOCK_CODE, &
			SZ_TEMP, &
			sz_bef, &
			sz_aft , &
			SZ_DOCKCODE ,&
			sz_obj_shipper,&
			SZ_LINFEED

Dec {0} dec_Quantity

int i_len, i_cur, i_ctr

DATETIME    ldt_Date


///////////////////////////////////////////////
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
   WHERE serial = :l_Serial   ;

select audit_trail.date_stamp
		into :ldt_Date
		from audit_trail 
		where audit_trail.serial = :l_serial and 
		(audit_trail.type = 'J' or audit_trail.type = 'R') ;

		SELECT order_header.customer_part,
				order_header.line_feed_code,
				order_header.DOCK_CODE,
				shipper.destination
		INTO :s_Cupart,
			 : s_line_feed_code,
			 :s_DOCK_CODE,
			 :s_Destination
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :l_Serial  ; 

  SELECT edi_setups.supplier_code,
		  edi_setups.destination	  
    INTO :s_Supplier,
		  :s_destination  
    FROM edi_setups  
   WHERE edi_setups.destination = :s_destination   ;  

  SELECT customer_part 
    INTO :s_cupart
    FROM shipper_detail
   WHERE part = :s_part and shipper = :l_shipper;
	
	
	SELECT object.shipper
	INTO  :sz_obj_shipper   
         FROM object  
   WHERE object.serial = :l_Serial   ;


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

// TO PRINT PART NO. - EXTREME right portion

sz_temp = trim(s_cupart)
i_len = len(sz_temp)

if i_len > 0  then
	for i_cur = 1 to i_len	
		 if (mid(sz_temp,i_cur,1) = ' ') then	
			 i_ctr = i_cur
		 end if 
	next 
end if
if i_ctr = 0 then 
	sz_bef = sz_temp
   SZ_AFT = ''
elseif i_ctr > 1 then 
	sz_bef = left(sz_temp,i_ctr)
	sz_aft = mid(sz_temp,(i_ctr + 1),i_len)
elseif i_ctr > 0 then 
	sz_bef = LEFT(sz_temp,i_ctr) 
	sz_aft = mid(sz_temp,(i_ctr + 1),i_len)
end if 

c_Esc = "~h1B"

 SZ_DOCKCODE = MID (s_dock_code,0,4)
 SZ_LINFEED = MID (s_line_feed_code,0,6)

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
PrintSend ( l_Label, c_Esc + "V100" + c_Esc + "H450" + c_Esc + "WL1" + sz_bef )
PrintSend ( l_Label, c_Esc + "V150" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "P" + UPPER( sz_bef) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H300" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H300" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H350" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H0943" + c_Esc + "M" + "PART NO." )
PrintSend ( l_Label, c_Esc + "V283" + c_Esc + "H0943" + c_Esc + "M" + "(C)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H1075" + c_Esc +"$A,110,140,0" + c_Esc + "$=" + UPPER(sz_aft) )
if len(sz_aft) > 0 then
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H0963" + c_Esc + "B103095" + "*" + "C" + UPPER(sz_aft) + "*" )
end if

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H943" + c_Esc + "M" + "'R' CODE" )
PrintSend ( l_Label, c_Esc + "V485" + c_Esc + "H943" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(SZ_DOCKCODE))
PrintSend ( l_Label, c_Esc + "V585" + c_Esc + "H948" + c_Esc + "$A,30,25,0" + c_Esc + "$=" + STRING(DATE( ldt_Date) ) )
PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H1168" + c_Esc + "M" + "LINE FEED" )
PrintSend ( l_Label, c_Esc + "V485" + c_Esc + "H1155" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(SZ_LINFEED))

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V485" + c_Esc + "H450" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V525" + c_Esc + "H275" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )
PrintSend ( l_Label, c_Esc + "V440" + c_Esc + "H0943" + c_Esc + "$A,40,40,0" + c_Esc + "$=" + sz_obj_shipper) 
PrintSend ( l_Label, c_Esc + "V450" + c_Esc + "H1100" + c_Esc + "M" + "SHIPPER" )


//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "LOT/SERIAL" )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H300" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H450" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H943" + c_Esc + "M" + "SHIP TO:(D)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H1115" + c_Esc + "WL1" + S_DESTINATION )
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H943" + c_Esc + "B103095" + "*" + "S" + S_DESTINATION + "*")
PrintSend ( l_Label, c_Esc + "V770" + c_Esc + "H1143" + c_Esc + "OB" + "FORD MOTOR" )


PrintSend ( l_Label, c_Esc + "V780" + c_Esc + "H325" + c_Esc + "S" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V1250" + c_Esc + "H525" + c_Esc + "OB" + s_part )
PrintSend ( l_Label, c_Esc + "V500" + c_Esc + "H251" + c_Esc + "FW03H0510" )
PrintSend ( l_Label, c_Esc + "V290" + c_Esc + "H470" + c_Esc + "FW03H0150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1150" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_ford.create
end on

on w_armada_ford.destroy
end on

