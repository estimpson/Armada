$PBExportHeader$w_invoice_overwrite.srw
$PBExportComments$prints invoice form with over-writeable address.
forward
global type w_invoice_overwrite from Window
end type
type cb_1 from commandbutton within w_invoice_overwrite
end type
type st_5 from statictext within w_invoice_overwrite
end type
type st_4 from statictext within w_invoice_overwrite
end type
type st_3 from statictext within w_invoice_overwrite
end type
type st_2 from statictext within w_invoice_overwrite
end type
type st_1 from statictext within w_invoice_overwrite
end type
type sle_5 from singlelineedit within w_invoice_overwrite
end type
type sle_4 from singlelineedit within w_invoice_overwrite
end type
type sle_3 from singlelineedit within w_invoice_overwrite
end type
type sle_2 from singlelineedit within w_invoice_overwrite
end type
type sle_1 from singlelineedit within w_invoice_overwrite
end type
end forward

global type w_invoice_overwrite from Window
int X=1051
int Y=468
int Width=2441
int Height=1136
boolean TitleBar=true
string Title="Untitled"
long BackColor=67108864
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
cb_1 cb_1
st_5 st_5
st_4 st_4
st_3 st_3
st_2 st_2
st_1 st_1
sle_5 sle_5
sle_4 sle_4
sle_3 sle_3
sle_2 sle_2
sle_1 sle_1
end type
global w_invoice_overwrite w_invoice_overwrite

on w_invoice_overwrite.create
this.cb_1=create cb_1
this.st_5=create st_5
this.st_4=create st_4
this.st_3=create st_3
this.st_2=create st_2
this.st_1=create st_1
this.sle_5=create sle_5
this.sle_4=create sle_4
this.sle_3=create sle_3
this.sle_2=create sle_2
this.sle_1=create sle_1
this.Control[]={this.cb_1,&
this.st_5,&
this.st_4,&
this.st_3,&
this.st_2,&
this.st_1,&
this.sle_5,&
this.sle_4,&
this.sle_3,&
this.sle_2,&
this.sle_1}
end on

on w_invoice_overwrite.destroy
destroy(this.cb_1)
destroy(this.st_5)
destroy(this.st_4)
destroy(this.st_3)
destroy(this.st_2)
destroy(this.st_1)
destroy(this.sle_5)
destroy(this.sle_4)
destroy(this.sle_3)
destroy(this.sle_2)
destroy(this.sle_1)
end on

type cb_1 from commandbutton within w_invoice_overwrite
int X=1029
int Y=768
int Width=352
int Height=144
int TabOrder=60
string Text="PRINT"
int TextSize=-12
int Weight=700
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_5 from statictext within w_invoice_overwrite
int X=448
int Y=624
int Width=352
int Height=76
boolean Enabled=false
string Text="ADDRESS 3"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_4 from statictext within w_invoice_overwrite
int X=448
int Y=500
int Width=352
int Height=76
boolean Enabled=false
string Text="ADDRESS 2"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_3 from statictext within w_invoice_overwrite
int X=448
int Y=376
int Width=352
int Height=76
boolean Enabled=false
string Text="ADDRESS 1"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_2 from statictext within w_invoice_overwrite
int X=210
int Y=252
int Width=590
int Height=76
boolean Enabled=false
string Text="DESTINATION NAME"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type st_1 from statictext within w_invoice_overwrite
int X=215
int Y=128
int Width=585
int Height=76
boolean Enabled=false
string Text="DESTINATION CODE"
boolean FocusRectangle=false
long TextColor=33554432
long BackColor=67108864
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_5 from singlelineedit within w_invoice_overwrite
int X=887
int Y=608
int Width=1358
int Height=92
int TabOrder=50
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_4 from singlelineedit within w_invoice_overwrite
int X=887
int Y=488
int Width=1358
int Height=92
int TabOrder=40
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_3 from singlelineedit within w_invoice_overwrite
int X=887
int Y=360
int Width=1358
int Height=92
int TabOrder=30
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_2 from singlelineedit within w_invoice_overwrite
int X=887
int Y=232
int Width=1358
int Height=92
int TabOrder=20
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

type sle_1 from singlelineedit within w_invoice_overwrite
int X=887
int Y=100
int Width=1358
int Height=92
int TabOrder=10
BorderStyle BorderStyle=StyleLowered!
boolean AutoHScroll=false
long TextColor=33554432
int TextSize=-10
int Weight=400
string FaceName="Arial"
FontCharSet FontCharSet=Ansi!
FontFamily FontFamily=Swiss!
FontPitch FontPitch=Variable!
end type

