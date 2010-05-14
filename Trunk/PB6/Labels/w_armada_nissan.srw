$PBExportHeader$w_armada_nissan.srw
forward
global type w_armada_nissan from Window
end type
type st_2 from statictext within w_armada_nissan
end type
type p_1 from picture within w_armada_nissan
end type
type cb_1 from commandbutton within w_armada_nissan
end type
type st_1 from statictext within w_armada_nissan
end type
type sle_1 from singlelineedit within w_armada_nissan
end type
end forward

global type w_armada_nissan from Window
int X=443
int Y=360
int Width=1550
int Height=872
boolean TitleBar=true
string Title="Nissan_label"
long BackColor=12632256
boolean ControlMenu=true
WindowType WindowType=response!
event print_label pbm_custom01
st_2 st_2
p_1 p_1
cb_1 cb_1
st_1 st_1
sle_1 sle_1
end type
global w_armada_nissan w_armada_nissan

type prototypes

end prototypes

type variables
STRING	is_KanbanNumber
end variables

event print_label;
//  Standard label for job completion

/////////////////////////////////////////////////
//  Declaration
//
st_generic_structure	st_Parm
st_Parm = Message.PowerObjectParm

Long		l_Label, &
			l_Serial

STRING	s_Esc, &
			s_Part, &
			s_Operator, &
			s_CustomerPart, &
			s_Description, &
			s_Quantity, &
			s_Serial, &
			s_Supplier, &
			s_Date, &
			s_Commodity, &
			s_Company, &
			s_Address1, &
			s_Address2, &
			s_Address3, &
			s_NumberOfLabels, &
			s_Location, &
			s_product, &
			s_linefeed, &
			s_userdefined1, &
			szname1, &
			szname2, &
			szname, &
			sz_desc2, &
			s_destination, &
			s_zonecode, &
			s_custom2, &
			s_custom3


Dec {0}	dec_Quantity

Date 		d_Date

datetime dt_date_time

integer i_order
long 	 l_position
long	 l_CONSTMAXS__DESCRIPTIONLENGTH = 13	

/////////////////////////////////////////////////
//  Initialization
//

l_Serial = LONG ( st_Parm.Value1 )

  SELECT	part,
			last_date,
			quantity,
			operator,
         location
    INTO	:s_Part,
			:dt_Date_time,
			:dec_Quantity,
			:s_Operator,
			:s_Location
    FROM	object
   WHERE	serial = :l_Serial  ;

   d_date = date(dt_date_time)

  SELECT	Part.name,
			commodity,
			product_line,
			Part.user_defined_1
    INTO :s_Description,
			:s_Commodity,
			:s_product,
			:s_userdefined1
    FROM	part,Part_characteristics  
   WHERE	part.part = :s_Part ;

  SELECT	order_header.customer_part,
			order_header.line_feed_code,
			order_header.destination,
			order_header.zone_code,
			order_header.custom02,
			order_header.custom03
    INTO	:s_CustomerPart,
			:s_linefeed,
			:s_destination,
			:s_zonecode,
			:s_custom2,
			:s_custom3
    FROM	object, shipper_detail, order_header
   WHERE	object.serial = :l_Serial AND
			shipper_detail.part_original = :s_Part AND
			object.shipper = shipper_detail.shipper AND
			shipper_detail.order_no = order_header.order_no ;

	If SQLCA.SQLCODE <> 0 Then
			SELECT cross_ref
			INTO   :s_customerpart
			FROM   part
			WHERE  part = :s_part ;
	End If

  SELECT	company_name,
			address_1,
			address_2,
			address_3
	 INTO	:s_Company,
			:s_Address1,
			:s_Address2,
			:s_Address3
	 FROM	parameters  ;

	SELECT edi_setups.supplier_code
	INTO   :s_Supplier
	FROM   edi_setups, object, shipper
	WHERE  edi_setups.destination = shipper.destination AND
			 shipper.id = object.shipper AND
			 object.serial = :l_Serial ;

If st_Parm.value11 = "" Then 
	s_NumberofLabels = "Q1"
Else
	s_NumberofLabels = "Q" + st_Parm.value11
End If

// TO PRINT INTO TWO LINES

l_position = Pos ( S_DESCRIPTION, " " ,1 )

DO WHILE ( POS ( S_DESCRIPTION , ' ', l_Position + 1 ) < l_CONSTMAXS__DESCRIPTIONLENGTH ) &  
	and ( POS ( S_DESCRIPTION , ' ', l_Position + 1 ) <> 0 )
	l_Position = Pos ( s_DESCRIPTION, ' ', l_Position + 1)
LOOP

sz_desc2 = MID (s_description, l_position +1, 13) 
szname1 = Left ( s_DESCRIPTION, l_Position )
szname2 = Mid ( s_DESCRIPTION, l_Position + 1 , ( len(s_DESCRIPTION) - l_Position + 1 ) )

szname = MID (s_customerpart,1,15)

s_Serial = STRING ( l_Serial )
s_Quantity = STRING ( dec_Quantity )
s_Esc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

l_Label = PrintOpen ( )

//	Start Printing
PrintSend ( l_Label, S_Esc + "A" + S_Esc + "R" )
PrintSend ( l_Label, s_Esc + "AR" )
PrintSend ( l_Label, s_Esc + "CS2")

//	Part Number
PrintSend ( l_Label, s_Esc + "V052" + s_Esc + "H325" + s_Esc + "S" + "PART NO (P/N) (P)" )
PrintSend ( l_Label, s_Esc + "V030" + s_Esc + "H500" + s_Esc + "$A,130,150,0" + s_Esc + "$=" + UPPER(szname))
PrintSend ( l_Label, s_Esc + "V161" + s_Esc + "H350" + s_Esc + "B103095" + "*" + "P" + szname + "*" )

//	Quantity
PrintSend ( l_Label, s_Esc + "V273" + s_Esc + "H325" + s_Esc + "S" + "QUANTITY (Q)" )
PrintSend ( l_Label, s_Esc + "V235" + s_Esc + "H495" + s_Esc + "$A,130,140,0" + s_Esc+ "$=" + s_Quantity )
PrintSend ( l_Label, s_Esc + "V349" + s_Esc + "H350" + s_Esc + "B103095" + "*" +"Q" + s_Quantity + "*" )

// Issue No
PrintSend ( l_Label, s_Esc + "V273" + s_Esc + "H820" + s_Esc + "S" + "ISSUE NO." )
PrintSend ( l_Label, s_Esc + "V293" + s_Esc + "H820" + s_Esc + "S" + "(I)" )
PrintSend ( l_Label, s_Esc + "V250" + s_Esc + "H925" + s_Esc + "$A,100,110,0" + s_Esc + "$=" + is_KanbanNumber )
PrintSend ( l_Label, s_Esc + "V349" + s_Esc + "H835" + s_Esc + "B103095" + "*" +"Q" + is_KanbanNumber + "*" )

//	Supplier Code
PrintSend ( l_Label, s_Esc + "V459" + s_Esc + "H325" + s_Esc + "S" + "SUPPLIER (V)" )
PrintSend ( l_Label, s_Esc + "V459" + s_Esc + "H500" + s_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, s_Esc + "V506" + s_Esc + "H350" + s_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

//	Serial Number
//PrintSend ( l_Label, s_Esc + "V631" + s_Esc + "H325" + s_Esc + "S" + "LOT/SERIAL(S)" )
PrintSend ( l_Label, s_Esc + "V625" + s_Esc + "H500" + s_Esc + "WL1" + s_Serial )
PrintSend ( l_Label, s_Esc + "V668" + s_Esc + "H350" + s_Esc + "B103095" + "*" + "S" + s_Serial + "*")

//DESCRIPTION
PrintSend ( l_Label, s_Esc + "V459" + s_Esc + "H1040" + s_Esc + "M" + "DESCRIPTION " )
PrintSend ( l_Label, s_Esc + "V485" + s_Esc + "H1040" + s_Esc + "WL1" + szname1 )
PrintSend ( l_Label, s_Esc + "V555" + s_Esc + "H1040" + s_Esc + "WL1" + szname2 )

//DESIGN NOTE & PROJECT
PrintSend ( l_Label, s_Esc + "V625" + s_Esc + "H1040" + s_Esc + "M" + "DESIGN NOTE" )
PrintSend ( l_Label, s_Esc + "V650" + s_Esc + "H1080" + s_Esc + "WL1" + UPPER(s_zonecode))
PrintSend ( l_Label, s_Esc + "V700" + s_Esc + "H1040" + s_Esc + "M" + "PROJECT")
PrintSend ( l_Label, s_Esc + "V720" + s_Esc + "H1080" + s_Esc + "WL1" + s_linefeed)

//	Company Info
PrintSend ( l_Label, s_Esc + "V785" + s_Esc + "H325" + s_Esc + "M" + s_Company + "  " + s_Address1 + " " + s_Address2 + "  " + s_Address3 )

//	Lines
PrintSend ( l_Label, s_Esc + "N" )
PrintSend ( l_Label, s_Esc + "V000" + s_Esc + "H260" + s_Esc + "FW03V1087" )
PrintSend ( l_Label, s_Esc + "V000" + s_Esc + "H450" + s_Esc + "FW03V1087" )
PrintSend ( l_Label, s_Esc + "V000" + s_Esc + "H618" + s_Esc + "FW03V1087" )
PrintSend ( l_Label, s_Esc + "V630" + s_Esc + "H260" + s_Esc + "FW03H0190" )
PrintSend ( l_Label, s_Esc + "V400" + s_Esc + "H450" + s_Esc + "FW03H0328" )

PrintSend ( l_Label, s_Esc + "CS2")

//	Close Label
PrintSend ( l_Label, s_Esc + s_NumberofLabels )
PrintSend ( l_Label, s_Esc + "Z" )
PrintClose ( l_Label )
Close (this)
end event
on w_armada_nissan.create
this.st_2=create st_2
this.p_1=create p_1
this.cb_1=create cb_1
this.st_1=create st_1
this.sle_1=create sle_1
this.Control[]={this.st_2,&
this.p_1,&
this.cb_1,&
this.st_1,&
this.sle_1}
end on

on w_armada_nissan.destroy
destroy(this.st_2)
destroy(this.p_1)
destroy(this.cb_1)
destroy(this.st_1)
destroy(this.sle_1)
end on

type st_2 from statictext within w_armada_nissan
int X=105
int Width=1239
int Height=80
boolean Enabled=false
string Text=" Monitor Systems, Inc."
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-10
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type p_1 from picture within w_armada_nissan
int Width=105
int Height=80
string PictureName="g:\monw32\test\logo45.bmp"
boolean FocusRectangle=false
end type

type cb_1 from commandbutton within w_armada_nissan
int X=622
int Y=576
int Width=384
int Height=152
int TabOrder=20
string Text="&OK"
boolean Default=true
int TextSize=-16
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;Parent.TriggerEvent ( "print_label" )
end on

type st_1 from statictext within w_armada_nissan
int X=101
int Y=240
int Width=613
int Height=92
boolean Enabled=false
boolean Border=true
BorderStyle BorderStyle=StyleLowered!
string Text="Issue Number"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_1 from singlelineedit within w_armada_nissan
int X=782
int Y=228
int Width=622
int Height=100
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=255
long BackColor=16777215
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on modified;is_KanbanNumber = This.Text
end on

