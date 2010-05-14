$PBExportHeader$w_armada_gmkanban.srw
$PBExportComments$armada gmkanban label 4/4
forward
global type w_armada_gmkanban from Window
end type
type sle_1 from singlelineedit within w_armada_gmkanban
end type
type st_3 from statictext within w_armada_gmkanban
end type
type p_1 from picture within w_armada_gmkanban
end type
type cb_1 from commandbutton within w_armada_gmkanban
end type
type st_1 from statictext within w_armada_gmkanban
end type
end forward

global type w_armada_gmkanban from Window
int X=673
int Y=265
int Width=1582
int Height=777
boolean TitleBar=true
string Title="KANBAN NUMBER"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event print_label pbm_custom01
sle_1 sle_1
st_3 st_3
p_1 p_1
cb_1 cb_1
st_1 st_1
end type
global w_armada_gmkanban w_armada_gmkanban

type variables

st_generic_structure iast_parm

String is_kanbannumber
end variables

on print_label;/////////////////////////////////////////////////
//  Declaration
//

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
        	szaddress1, &
			szaddress2, &
			szaddress3, &
			s_blanket_part, &
			szeng

Dec {0} dec_Quantity

///////////////////////////////////////////////
//  Initialization
//
l_Serial = LONG ( iast_Parm.Value1 )


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

		SELECT order_header.customer_part,
				order_header.BLANKET_PART,
				shipper.destination
		INTO :s_Cupart,
			  :s_BLANKET_PART,
			 :s_Destination
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

  SELECT	customer
    INTO	:s_Customer
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
 
	SELECT part.user_defined_1
    INTO :szuser_defined_1
    FROM part  
   WHERE part.part = :s_Part   ;
 
SELECT parameters.company_name, address_1, address_2, address_3
	INTO :szCompany,
		  :szAddress1,
			:szAddress2,
			:szAddress3
	From parameters ;
 
// to get the number of copies of the label 

If iast_Parm.value11 = "" Then 
	s_NumberofLabels = "Q1"
Else
	s_NumberofLabels = "Q" + iast_Parm.value11
End If

c_Esc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

l_Label = PrintOpen ( )

//  Start Printing
PrintSend ( l_Label, c_Esc + "A" + c_Esc + "R" )

//  Part Info
PrintSend ( l_Label, c_Esc + "V058" + c_Esc + "H300" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V078" + c_Esc + "H300" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V020" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc + "$=" + s_cuPart )
PrintSend ( l_Label, c_Esc + "V150" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "P" + s_cuPart + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H300" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H300" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H350" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H860" + c_Esc + "M" + "KANBAN" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H860" + c_Esc + "M" + "(K)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H985" + c_Esc + "$A,110,150,0" + c_Esc +"$=" + UPPER(is_kanbannumber ))
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H860" + c_Esc + "B103095" + "*" +"Q" + UPPER(is_kanbannumber + "*" ))

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H1103" + c_Esc + "M" + "ENG. CHANGE" )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H1103" + c_Esc + "$A,65,65,0" + c_Esc + "$=" + upper(String(szuser_defined_1)) )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H450" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

//PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "LOT/SERIAL" )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H300" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H550" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H1103" + c_Esc + "M" + "INTERNAL PART NO. " )
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H1103" + c_Esc +  "$A,35,45,0" + c_Esc + "$=" + s_blanket_part )

PrintSend ( l_Label, c_Esc + "V785" + c_Esc + "H325" + c_Esc + "M" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )
PrintSend ( l_Label, c_Esc + "V597" + c_Esc + "H251" + c_Esc + "FW03H0220" )
PrintSend ( l_Label, c_Esc + "V347" + c_Esc + "H470" + c_Esc + "FW03H0290" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V030" + c_Esc + "H618" + c_Esc + "FW03V1150" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end on

on open;iast_Parm = Message.PowerObjectParm
end on

on w_armada_gmkanban.create
this.sle_1=create sle_1
this.st_3=create st_3
this.p_1=create p_1
this.cb_1=create cb_1
this.st_1=create st_1
this.Control[]={ this.sle_1,&
this.st_3,&
this.p_1,&
this.cb_1,&
this.st_1}
end on

on w_armada_gmkanban.destroy
destroy(this.sle_1)
destroy(this.st_3)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.st_1)
end on

type sle_1 from singlelineedit within w_armada_gmkanban
int X=654
int Y=281
int Width=810
int Height=93
int TabOrder=30
BorderStyle BorderStyle=StyleShadowBox!
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-11
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;is_kanbannumber =This.text
end on

type st_3 from statictext within w_armada_gmkanban
int X=156
int Y=5
int Width=1390
int Height=129
int TabOrder=10
boolean Enabled=false
string Text="   Monitor Systems, Inc."
boolean FocusRectangle=false
long TextColor=8388608
long BackColor=12632256
int TextSize=-9
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_1 from picture within w_armada_gmkanban
int Width=165
int Height=129
string PictureName="g:\monw32\test\logo2.bmp"
boolean FocusRectangle=false
end type

type cb_1 from commandbutton within w_armada_gmkanban
int X=572
int Y=445
int Width=293
int Height=149
int TabOrder=40
string Text="&OK"
int TextSize=-11
int Weight=700
string FaceName="Arial Rounded MT Bold"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;parent.Triggerevent ("Print_label")
end on

type st_1 from statictext within w_armada_gmkanban
int X=37
int Y=273
int Width=572
int Height=93
int TabOrder=20
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleShadowBox!
string Text="KANBAN NO."
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-12
int Weight=700
string FaceName="Arial Rounded MT Bold"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

