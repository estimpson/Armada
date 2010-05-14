$PBExportHeader$w_pallet_label_selector.srw
forward
global type w_pallet_label_selector from Window
end type
end forward

global type w_pallet_label_selector from Window
int X=1056
int Y=484
int Width=2569
int Height=1516
boolean TitleBar=true
string Title="Untitled"
long BackColor=67108864
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_pallet_label_selector w_pallet_label_selector

event open;
//	We want to write a pallet label that prints the pallet label in order detail
//	for a pallet staged to a shipper.

//	Declarations.
long	ll_PalletSerial
long	ll_Shipper
long	ll_Suffix
long	ll_OrderNo

string	ls_PalletLabel
string	ls_Part

st_generic_structure	lst_Parm

//	Initialize.
lst_Parm = message.powerobjectparm
ll_PalletSerial = Long ( lst_Parm.Value1 )

//	A.  Get the shipper and 1st child part and suffix for the pallet from object table.
select	Min ( shipper ),
	Min ( part )
into	:ll_Shipper,
	:ls_Part
from	object
where	parent_serial = :ll_PalletSerial  ;

select	Min ( suffix )
into	:ll_Suffix
from	object
where	parent_serial = :ll_PalletSerial and
	part = :ls_Part  ;

//	B.  Get the order from shipper detail.
select	order_no
into	:ll_OrderNo
from	shipper_detail
where	shipper = :ll_Shipper and
	part_original = :ls_Part and
	IsNull ( suffix, -1 ) = IsNull ( :ll_Suffix, -1 )  ;

//	C.  Get the 1st pallet label from order detail.
select	Min ( pallet_label )
into	:ls_PalletLabel
from	order_detail
where	order_no = :ll_OrderNo and
	part_number = :ls_Part and
	IsNull ( suffix, -1 ) = IsNull ( :ll_Suffix, -1 )  ;

//	D.  Print the pallet label.
lst_Parm.value12 = ls_PalletLabel
f_print_label ( lst_Parm )

//	Close
close ( this )
end event
on w_pallet_label_selector.create
end on

on w_pallet_label_selector.destroy
end on

