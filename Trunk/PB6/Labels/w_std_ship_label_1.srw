$PBExportHeader$w_std_ship_label_1.srw
forward
global type w_std_ship_label_1 from Window
end type
type st_1 from statictext within w_std_ship_label_1
end type
type em_1 from editmask within w_std_ship_label_1
end type
type cb_1 from commandbutton within w_std_ship_label_1
end type
end forward

shared variables

end variables

global type w_std_ship_label_1 from Window
int X=672
int Y=264
int Width=1582
int Height=576
boolean TitleBar=true
string Title="Destination Label"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
st_1 st_1
em_1 em_1
cb_1 cb_1
end type
global w_std_ship_label_1 w_std_ship_label_1

on w_std_ship_label_1.create
this.st_1=create st_1
this.em_1=create em_1
this.cb_1=create cb_1
this.Control[]={this.st_1,&
this.em_1,&
this.cb_1}
end on

on w_std_ship_label_1.destroy
destroy(this.st_1)
destroy(this.em_1)
destroy(this.cb_1)
end on

type st_1 from statictext within w_std_ship_label_1
int X=18
int Y=48
int Width=974
int Height=112
boolean Enabled=false
string Text="NUMBER OF LABELS"
Alignment Alignment=Center!
boolean FocusRectangle=false
long BackColor=12632256
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type em_1 from editmask within w_std_ship_label_1
int X=1024
int Y=32
int Width=475
int Height=112
int TabOrder=10
Alignment Alignment=Center!
BorderStyle BorderStyle=StyleLowered!
string Mask="#####"
int TextSize=-14
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type cb_1 from commandbutton within w_std_ship_label_1
int X=530
int Y=176
int Width=457
int Height=224
int TabOrder=20
string Text="&OK"
boolean Default=true
int TextSize=-20
int Weight=700
string FaceName="Arial"
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

event clicked;//Script : Clicked for CB_1 for w_std_ship_label

///////////////////////////////////////////////////////////////////
//	   Declaration
//

//Int iLabel		  // 16-bit Open Handle
Long  ll_Label		  // 32-bit Open Handle
Long	l_l_serial

String cEsc					                     
String szCompany			                     
String szDestination		                     
String szAddress1, szAddress2, szAddress3		
String szAddress4, szAddress5, szAddress6		
String szDest				                     
String szNumberofLabels                      
String sz_name
String sz_id
String s_plant_code
String s_dock_code
String s_location
String	s_order_no
String	s_plant

st_generic_structure Stparm

Int l_i_no
Int l_i_count

DATE	d_date

d_date = TODAY ()

////////////////////////////////////////////////////////////////////
//		Initialization
//

szDest	= Message.StringParm
Stparm = Message.PowerObjectParm

SELECT	parameters.company_name, address_1, address_2, address_3
  INTO	:szCompany,
			:szAddress1,
			:szAddress2,
			:szAddress3
  FROM 	parameters ;

SELECT 	destination.name,   
         destination.address_1,   
         destination.address_2,   
         destination.address_3, 
			destination.destination
  INTO 	:szDestination,   
         :szAddress4,   
         :szAddress5,   
         :szAddress6,
			:s_plant_code
  FROM 	destination  
 WHERE 	destination.destination = :szDest   ;
	
SELECT	MAX ( shipper_detail.order_no ),
			order_header.dock_code,
			order_header.plant,
			shipper.destination
  INTO	:s_order_no,
  			:s_dock_code,
  			:s_plant_code,
			:s_plant
  FROM	order_header,
  			shipper_detail, 
			shipper
 WHERE	order_header.order_no = shipper_detail.order_no AND
			shipper_detail.shipper = shipper.id AND
			order_header.destination = :szDest	
GROUP BY order_header.dock_code,
			order_header.plant,
			shipper.destination	;
			
cEsc = "~h1B"

s_location = s_plant + s_dock_code

//////////////////////////////////////////////////
//	Main Routine
//

l_i_no = Integer ( em_1.text )

FOR l_i_count = 1 TO l_i_no

	ll_Label = PrintOpen ( )

	//	Start Printing
	PrintSend ( ll_Label, cEsc + "A" + cEsc + "R" )

	//  Print Plant Code Information
	PrintSend ( ll_label, cEsc + "V050" + cesc + "H250" + cEsc + "M" + "PLANT CODE" )
	PrintSend ( ll_label, cEsc + "V090" + cEsc + "H300" + cESc + "$A,100,100,0" + cEsc + "$=" + s_plant )

	//  Print Dock Code Information
	PrintSend ( ll_label, cEsc + "V050" + cEsc + "H1050" + cEsc + "M" + "DOCK LOC" )
	PrintSend ( ll_label, cEsc + "V090" + cEsc + "H1150" + cEsc + "$A,100,100,0" + cEsc + "$=" + s_dock_code )
	
	//  Print The Location information
	PrintSend ( ll_label, cEsc + "V220" + cEsc + "H250" + cEsc + "M" + "LOCATION" )
	PrintSend ( ll_label, cESc + "V240" + cEsc + "H250" + cEsc + "M" + "(1L)" )
	PrintSend ( ll_label, cEsc + "V220" + cEsc + "H400" + cEsc + "WL1" + s_location )
	PrintSend ( ll_label, cEsc + "V310" + cEsc + "H325" + cEsc + "B103170" + "*" + "1L" + s_location + "*" )
	
	// print label count
	Printsend ( ll_Label, cEsc + "V050" + cEsc + "H1350" + cEsc + "S" + string ( l_i_count ) + " of " + string( l_i_no ) )

  	//  Print Ship Date
	PrintSend ( ll_label, cEsc + "V540" + cEsc + "H1170" + cEsc + "M" + "SHIP DATE" )
	PrintSend ( ll_label, cEsc + "V640" + cEsc + "H1200" + cEsc + "$A,50,50,0" + cEsc + "$=" + STRING ( d_date ) )
	  
	//	Lower Box Data
  	PrintSend ( ll_Label, cEsc + "V540" + cEsc + "H250" + cEsc + "M" + "SHIP TO:" )
  	PrintSend ( ll_Label, cEsc + "V560" + cEsc + "H350" + cEsc + "$A,35,35,0" + cEsc + "$=" + szDestination )
  	PrintSend ( ll_Label, cEsc + "V610" + cEsc + "H350" + cEsc + "$A,35,35,0" + cEsc + "$=" + szAddress4 )
  	PrintSend ( ll_Label, cEsc + "V660" + cEsc + "H350" + cEsc + "$A,35,35,0" + cEsc + "$=" + szAddress5 )
  	PrintSend ( ll_Label, cEsc + "V710" + cEsc + "H350" + cEsc + "$A,35,35,0" + cEsc + "$=" + szAddress6 )


  	//	Draw Lines
   PrintSend ( ll_label, cEsc + "V535" + cEsc + "H190" + cEsc + "FW02H1200" )
	PrintSend ( ll_label, cEsc + "V215" + cEsc + "H190" + cEsc + "FW02H1200" )
	PrintSend ( ll_label, cEsc + "V535" + cEsc + "H1160" + cEsc + "FW02V265" )
	PrintSend ( ll_label, cEsc + "V040" + cEsc + "H1040" + cEsc + "FW02V177" )

  
	PrintSend ( ll_Label, cEsc + "Q1" )
	PrintSend ( ll_Label, cEsc + "Z" )
	PrintClose ( ll_Label )
NEXT

Close (parent)

end event

