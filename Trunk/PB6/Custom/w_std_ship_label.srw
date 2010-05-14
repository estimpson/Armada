$PBExportHeader$w_std_ship_label.srw
forward
global type w_std_ship_label from Window
end type
type st_6 from statictext within w_std_ship_label
end type
type sle_destinationname from singlelineedit within w_std_ship_label
end type
type em_labelcount from editmask within w_std_ship_label
end type
type st_5 from statictext within w_std_ship_label
end type
type cb_print from commandbutton within w_std_ship_label
end type
type sle_address3 from singlelineedit within w_std_ship_label
end type
type sle_address2 from singlelineedit within w_std_ship_label
end type
type sle_address1 from singlelineedit within w_std_ship_label
end type
type sle_destinationcode from singlelineedit within w_std_ship_label
end type
type st_4 from statictext within w_std_ship_label
end type
type st_3 from statictext within w_std_ship_label
end type
type st_2 from statictext within w_std_ship_label
end type
type st_1 from statictext within w_std_ship_label
end type
end forward

global type w_std_ship_label from Window
int X=1074
int Y=480
int Width=1701
int Height=1036
boolean TitleBar=true
string Title="Untitled"
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
st_6 st_6
sle_destinationname sle_destinationname
em_labelcount em_labelcount
st_5 st_5
cb_print cb_print
sle_address3 sle_address3
sle_address2 sle_address2
sle_address1 sle_address1
sle_destinationcode sle_destinationcode
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
end type
global w_std_ship_label w_std_ship_label

on open;//  Variable declarations

STRING	ls_destination
STRING	ls_dockcode
STRING	ls_numberoflabels

LONG	ll_shipperid

//  Get the destination from the message.
ls_destination = message.stringparm
MessageBox ( ls_destination, ls_destination )

//  Get the shipper number.
IF NOT IsValid ( w_shipping_dock ) THEN
	MessageBox ( "Warning.", "This label can only be printed from the Shipping Dock." )
	Close ( this )
	Return
END IF
ll_shipperid = w_shipping_dock.iShipper
MessageBox ( String ( ll_shipperid ), String ( ll_shipperid ) )

//  Determine the proper destination code.
SELECT	destination.destination
  INTO	:ls_dockcode
  FROM	shipper_detail,
			order_header,
			destination
 WHERE	shipper_detail.shipper = :ll_shipperid AND
			shipper_detail.order_no = order_header.order_no AND
			order_header.location = destination.destination
GROUP BY destination.destination  ;

IF ls_dockcode > "" THEN
	ls_destination = ls_dockcode
END IF
MessageBox ( ls_destination, ls_destination )

//  Display the address.
SELECT	destination,
			name,
			address_1,
			address_2,
			address_3
  INTO	:sle_destinationcode.text,
			:sle_destinationname.text,
			:sle_address1.text,
			:sle_address2.text,
			:sle_address3.text
  FROM	destination
 WHERE	destination = :ls_destination  ;
end on

on w_std_ship_label.create
this.st_6=create st_6
this.sle_destinationname=create sle_destinationname
this.em_labelcount=create em_labelcount
this.st_5=create st_5
this.cb_print=create cb_print
this.sle_address3=create sle_address3
this.sle_address2=create sle_address2
this.sle_address1=create sle_address1
this.sle_destinationcode=create sle_destinationcode
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.Control[]={this.st_6,&
this.sle_destinationname,&
this.em_labelcount,&
this.st_5,&
this.cb_print,&
this.sle_address3,&
this.sle_address2,&
this.sle_address1,&
this.sle_destinationcode,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1}
end on

on w_std_ship_label.destroy
destroy(this.st_6)
destroy(this.sle_destinationname)
destroy(this.em_labelcount)
destroy(this.st_5)
destroy(this.cb_print)
destroy(this.sle_address3)
destroy(this.sle_address2)
destroy(this.sle_address1)
destroy(this.sle_destinationcode)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
end on

type st_6 from statictext within w_std_ship_label
int X=91
int Y=232
int Width=649
int Height=72
boolean Enabled=false
string Text="Destination Name:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_destinationname from singlelineedit within w_std_ship_label
int X=750
int Y=224
int Width=786
int Height=80
int TabOrder=20
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_labelcount from editmask within w_std_ship_label
int X=951
int Y=608
int Width=247
int Height=100
int TabOrder=60
Alignment Alignment=Right!
string Mask="###"
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_std_ship_label
int X=238
int Y=608
int Width=695
int Height=96
boolean Enabled=false
string Text="Number of Labels:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_print from commandbutton within w_std_ship_label
int X=603
int Y=736
int Width=411
int Height=96
int TabOrder=70
string Text="Print Label"
int TextSize=-11
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

on clicked;//  Declarations
CHAR	lc_esc

LONG	ll_label

INTEGER	li_labelcount
INTEGER	li_numberoflabels

STRING	ls_company
STRING	ls_address1
STRING	ls_address2
STRING	ls_address3

//  Get the company information.
SELECT	company_name,
			address_1,
			address_2,
			address_3
  INTO	:ls_company,
			:ls_address1,
			:ls_address2,
			:ls_address3
  FROM	parameters  ;

//  Get the number of labels to print.
li_numberoflabels = Integer ( em_labelcount.text )

//  Print the labels.
FOR li_labelcount = 1 to li_numberoflabels

	ll_Label = PrintOpen ( )

	lc_esc = "~h1B"

	//	Start Printing
	PrintSend ( ll_Label, lc_esc + "A" + lc_esc + "R" )

	//	Upper Box Data
	PrintSend ( ll_Label, lc_esc + "V080" + lc_esc + "H340" + lc_esc + "M" + "FROM:" )
	PrintSend ( ll_Label, lc_esc + "V100" + lc_esc + "H335" + lc_esc + "$A,36,36,0" + lc_esc + "$=" + ls_company )
	PrintSend ( ll_Label, lc_esc + "V175" + lc_esc + "H335" + lc_esc + "$A,36,36,0" + lc_esc + "$=" + ls_address1 )
	PrintSend ( ll_Label, lc_esc + "V250" + lc_esc + "H335" + lc_esc + "$A,36,36,0" + lc_esc + "$=" + ls_address2 )
	PrintSend ( ll_Label, lc_esc + "V325" + lc_esc + "H335" + lc_esc + "$A,36,36,0" + lc_esc + "$=" + ls_address3 )

	// print label count
	
	Printsend ( ll_Label, lc_esc + "V080" + lc_esc + "H1200" + lc_esc + "s" + string ( li_labelcount ) + " of " + string ( li_numberoflabels ) )

  //	Lower Box Data
  PrintSend ( ll_Label, lc_esc + "V430" + lc_esc + "H340" + lc_esc + "M" + "TO:" )
  PrintSend ( ll_Label, lc_esc + "V460" + lc_esc + "H335" + lc_esc + "$A,60,75,0" + lc_esc + "$=" + sle_destinationname.text )
  PrintSend ( ll_Label, lc_esc + "V535" + lc_esc + "H335" + lc_esc + "$A,60,75,0" + lc_esc + "$=" + sle_address1.text )
  PrintSend ( ll_Label, lc_esc + "V610" + lc_esc + "H335" + lc_esc + "$A,60,75,0" + lc_esc + "$=" + sle_address2.text )
  PrintSend ( ll_Label, lc_esc + "V685" + lc_esc + "H335" + lc_esc + "$A,60,75,0" + lc_esc + "$=" + sle_address3.text )


  //	Draw Lines
  PrintSend ( ll_Label, lc_esc + "N" )

  //	Top Box
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H050" + lc_esc + "FW06V1020" )		   //	Top Horz Line
  PrintSend ( ll_Label, lc_esc + "V1100" + lc_esc + "H050" + lc_esc + "FW06H0336" )		// Left Vert Line
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H050" + lc_esc + "FW06H0330" )		   //	Right Vert Line
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H380" + lc_esc + "FW06V1020" )  		// Bottom Horz Line 

  //	Bottom Box
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H410" + lc_esc + "FW06V1020" )		   //	Top Horz Line
  PrintSend ( ll_Label, lc_esc + "V1100" + lc_esc + "H410" + lc_esc + "FW06H0356" )		//	Left Vert Line
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H410" + lc_esc + "FW06H0350" )		   //	Right Vert Line
  PrintSend ( ll_Label, lc_esc + "V80" + lc_esc + "H760" + lc_esc + "FW06V1020" )		   // Bottom Horz Line

//  PrintSend ( ll_Label, lc_esc + "Q1" )
  PrintSend ( ll_Label, lc_esc + "Z" )
  PrintClose ( ll_Label )

NEXT

Close ( parent )
end on

type sle_address3 from singlelineedit within w_std_ship_label
int X=750
int Y=512
int Width=786
int Height=80
int TabOrder=50
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_address2 from singlelineedit within w_std_ship_label
int X=750
int Y=416
int Width=786
int Height=80
int TabOrder=40
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_address1 from singlelineedit within w_std_ship_label
int X=750
int Y=320
int Width=786
int Height=80
int TabOrder=30
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_destinationcode from singlelineedit within w_std_ship_label
int X=750
int Y=144
int Width=786
int Height=64
int TabOrder=10
boolean AutoHScroll=false
long BackColor=16777215
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_std_ship_label
int X=91
int Y=520
int Width=649
int Height=72
boolean Enabled=false
string Text="Address3:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_std_ship_label
int X=91
int Y=416
int Width=649
int Height=72
boolean Enabled=false
string Text="Address2:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_std_ship_label
int X=91
int Y=320
int Width=649
int Height=72
boolean Enabled=false
string Text="Address1:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_std_ship_label
int X=91
int Y=144
int Width=649
int Height=72
boolean Enabled=false
string Text="Destination Code:"
Alignment Alignment=Right!
boolean FocusRectangle=false
long BackColor=16777215
int TextSize=-11
int Weight=400
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

