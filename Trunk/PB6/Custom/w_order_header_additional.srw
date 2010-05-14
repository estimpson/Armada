$PBExportHeader$w_order_header_additional.srw
forward
global type w_order_header_additional from Window
end type
type dw_1 from datawindow within w_order_header_additional
end type
end forward

global type w_order_header_additional from Window
int X=1723
int Y=672
int Width=3657
int Height=2076
boolean TitleBar=true
string Title="Additional Fields"
long BackColor=82899184
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
event ue_exit ( )
event ue_save ( )
dw_1 dw_1
end type
global w_order_header_additional w_order_header_additional

event ue_exit;
Close(this)

end event

event ue_save;dw_1.AcceptText()
dw_1.Update()
commit;

end event

on w_order_header_additional.create
this.dw_1=create dw_1
this.Control[]={this.dw_1}
end on

on w_order_header_additional.destroy
destroy(this.dw_1)
end on

event activate;if wmainscreen.menuname <> "m_order_header_additional" then &
	wMainScreen.ChangeMenu(m_order_header_additional)

end event

event resize;dw_1.resize(width - 60, height - 140)

end event
type dw_1 from datawindow within w_order_header_additional
int Width=3493
int Height=1884
int TabOrder=10
string DataObject="d_order_header_additional"
BorderStyle BorderStyle=StyleLowered!
boolean HScrollBar=true
boolean VScrollBar=true
boolean LiveScroll=true
end type

event constructor;
SetTransObject(SQLCA)
Retrieve(w_blanket_order.iOrder)

end event

