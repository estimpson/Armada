$PBExportHeader$w_armada_ford_new.srw
forward
global type w_armada_ford_new from Window
end type
end forward

global type w_armada_ford_new from Window
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
global w_armada_ford_new w_armada_ford_new

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
			SZ_LINFEED,&
			ls_MaterialIssuer,&
			ls_DestinationCode,&
			ls_DockCode,&
			ls_DestAdd1,&
			ls_DestAdd2,&
			ls_DestAdd3,&
			ls_DestCode
							
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
			 :ls_DockCode,
			 :s_Destination
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			shipper.id = shipper_detail.shipper AND
			shipper_detail.shipper = object.shipper AND
			shipper_detail.part_original = object.part AND
			object.serial = :l_Serial  ; 

  SELECT supplier_code,
		   destination,
		   material_issuer
    INTO :s_Supplier,
		  :ls_DestinationCode,
		  :ls_MaterialIssuer
    FROM edi_setups  
   WHERE destination = :s_destination   ;  

  SELECT customer_part 
    INTO :s_cupart
    FROM shipper_detail
   WHERE part = :s_part and shipper = :l_shipper;
	
	//	Pulling Assembly Plant Code from Destination //
	
	ls_DestCode = mid (ls_DestinationCode, 3, 2)
	
	Select	address_1,
				address_2,
				address_3
	Into		:ls_DestAdd1,
				:ls_DestAdd2,
				:ls_DestAdd3
	From		destination
	Where 	destination = :s_destination  ;
	
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

sz_temp = righttrim(s_cupart)
i_len = len(sz_temp)

if i_len > 0  then
	for i_cur = 1 to i_len	
		 if (mid(sz_temp,i_cur,1) = ' ' OR mid(sz_temp,i_cur,1) = '-') then	
			 i_ctr = i_cur
		 end if 
	next 
end if

if i_ctr <= 1 then 
	sz_bef = sz_temp
   SZ_AFT = ''
else
	sz_bef = left(sz_temp,i_ctr - 1)
	sz_aft = mid(sz_temp,(i_ctr + 1))
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
PrintSend ( l_Label, c_Esc + "V020" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc + "$=" + sz_bef )
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
PrintSend ( l_Label, c_Esc + "V485" + c_Esc + "H943" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(ls_DockCode))
PrintSend ( l_Label, c_Esc + "V585" + c_Esc + "H948" + c_Esc + "$A,30,25,0" + c_Esc + "$=" + STRING(DATE( ldt_Date) ) )
PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H1168" + c_Esc + "M" + "LINE FEED" )
PrintSend ( l_Label, c_Esc + "V485" + c_Esc + "H1155" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(SZ_LINFEED))

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H450" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "LOT/SERIAL" )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H300" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H450" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H833" + c_Esc + "S" + "SHIP TO:" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H1318" + c_Esc + "S" + "DOCK ID" )
PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H1018" + c_Esc + "M" + "(D)" )
PrintSend ( l_Label, c_Esc + "V665" + c_Esc + "H1018" + c_Esc + "M" + ls_DestCode )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H833" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(ls_MaterialIssuer))
PrintSend ( l_Label, c_Esc + "V624" + c_Esc + "H1068" + c_Esc + "B103095" + "*" + "D" + ls_DestCode + "*")
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H1318" + c_Esc + "$A,75,85,0" + c_Esc + "$=" + UPPER(ls_DockCode))
PrintSend ( l_Label, c_Esc + "V725" + c_Esc + "H833" + c_Esc + "$A,35,50,0" + c_Esc + "$=" + "FORD MOTOR" )
PrintSend ( l_Label, c_Esc + "V729" + c_Esc + "H1068" + c_Esc + "S" + ls_DestAdd1 )
PrintSend ( l_Label, c_Esc + "V749" + c_Esc + "H1068" + c_Esc + "S" + ls_DestAdd2 )
PrintSend ( l_Label, c_Esc + "V769" + c_Esc + "H1068" + c_Esc + "S" + ls_DestAdd3 )


PrintSend ( l_Label, c_Esc + "V789" + c_Esc + "H325" + c_Esc + "S" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V1175" + c_Esc + "H525" + c_Esc + "OB" + s_part )
PrintSend ( l_Label, c_Esc + "V500" + c_Esc + "H251" + c_Esc + "FW03H0367" )
PrintSend ( l_Label, c_Esc + "V290" + c_Esc + "H470" + c_Esc + "FW03H0150" )
PrintSend ( l_Label, c_Esc + "V600" + c_Esc + "H618" + c_Esc + "FW03H0143" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1100" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1100" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1100" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_ford_new.create
end on

on w_armada_ford_new.destroy
end on

