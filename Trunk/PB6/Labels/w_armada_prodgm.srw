$PBExportHeader$w_armada_prodgm.srw
forward
global type w_armada_prodgm from Window
end type
end forward

shared variables

end variables

global type w_armada_prodgm from Window
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
global w_armada_prodgm w_armada_prodgm

type variables
St_generic_structure ast_Parm
end variables

event open;////////////////////////////////////////////
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
			s_CuPart,&
			s_NumberofLabels, &
			szcompany, &
         s_cupo, &
			szaddress1, &
			szaddress2, &
			szaddress3, &
			s_shipper
			
Dec {0} dec_Quantity

///////////////////////////////////////////////
//  Initialization
//

l_Serial = LONG ( ast_Parm.Value1 )

  SELECT part,   
         quantity,   
			shipper
	 INTO :s_Part,   
         :dec_Quantity,   
			:l_shipper
			
    FROM object  
   WHERE serial = :l_Serial   ;

		SELECT order_header.customer_part,
				order_header.customer_po,
				shipper.id
		INTO :s_Cupart,
			  : s_cupo,
			  :l_shipper
	  FROM order_header, shipper_detail, shipper, object
	 WHERE order_header.order_no = shipper_detail.order_no AND
			 shipper.id = shipper_detail.shipper AND
			 shipper_detail.shipper = object.shipper AND
			 shipper_detail.part_original = object.part AND
			 object.serial = :l_Serial  ; 
 
  SELECT customer_part 
    INTO :s_cupart
    FROM shipper_detail
   WHERE part = :s_part and shipper = :l_shipper;

// in case if it not found in the above table find it in the part master

  if isnull(s_cupart) or s_cupart = ''  then
 	 SELECT cross_ref
  	  INTO  :s_cupart  
 	  FROM  part  
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

c_Esc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

l_Label = PrintOpen ( )

//  Start Printing
PrintSend ( l_Label, c_Esc + "A" + c_Esc + "%1" )
PrintSend ( l_Label, c_Esc + "AR" )

//  Part Info
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H100" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H120" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V970" + c_Esc + "H70" + c_Esc + "$A,150,150,0" + c_Esc + "$=" + UPPER(s_cuPart) )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H200" + c_Esc + "B103095" + "*" + "P" + s_cuPart + "*" )

//QTY
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H350" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H370" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V1000" + c_Esc + "H360" + c_Esc + "$A,130,100,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H450" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

//CUSTOMER PO
PrintSend ( l_Label, c_Esc + "V700" + c_Esc + "H350" + c_Esc + "M" + "CUSTOMER PO #" )
PrintSend ( l_Label, c_Esc + "V700" + c_Esc + "H370" + c_Esc + "M" + "(A)" )
PrintSend ( l_Label, c_Esc + "V600" + c_Esc + "H360" + c_Esc + "$A,130,100,0" + c_Esc +"$=" +  s_cupo )
PrintSend ( l_Label, c_Esc + "V700" + c_Esc + "H450" + c_Esc + "B103095" + "*" + "A" +  s_cupo + "*" )

//SHIPPER NO
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H570" + c_Esc + "M" + "SHIPPER NO." )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H590" + c_Esc + "M" + "(11K)" )
PrintSend ( l_Label, c_Esc + "V850" + c_Esc + "H550" + c_Esc + "$A,130,100,0" + c_Esc +"$=" + STRING(l_shipper) )
PrintSend ( l_Label, c_Esc + "V1100" + c_Esc + "H650" + c_Esc + "B103095" + "*" + "11K" + STRING(l_shipper) + "*")

PrintSend ( l_Label, c_Esc + "V1050" + c_Esc + "H760" + c_Esc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H311" + c_Esc + "FW03V1100" )
PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H560" + c_Esc + "FW03V1100" )
PrintSend ( l_Label, c_Esc + "V740" + c_Esc + "H311" + c_Esc + "FW03H0250" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armada_prodgm.create
end on

on w_armada_prodgm.destroy
end on

