$PBExportHeader$w_armada_gm_b10.srw
forward
global type w_armada_gm_b10 from Window
end type
end forward

global type w_armada_gm_b10 from Window
int X=832
int Y=356
int Width=1239
int Height=772
boolean TitleBar=true
string Title="Saturn B-10 Label"
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armada_gm_b10 w_armada_gm_b10

type variables
st_generic_structure ast_parm
end variables

event open;ast_Parm = Message.PowerObjectParm

//////////////////////////////////
//  Declaration
//
CHAR	lc_esc = "~h1B"

LONG	ll_serial, &
		ll_order_no, &
		ll_label

STRING	ls_begin_kanban, &
			ls_kanban_number, &
			ls_line11, &
			ls_line12, &
			ls_line13, &
			ls_line14, &
			ls_line15, &
			ls_line16, &
			ls_line17, &
			ls_lot, &
			ls_operator, &
			ls_customer_part, &
			ls_customer_po, &
			ls_supplier_code, &
			ls_eng_level, &
			ls_company, &
			ls_address_1, &
			ls_address_2, &
			ls_address_3, &
			ls_part, &
			ls_number_of_labels, &
			ls_dock_code, &
			ls_name, &
			ls_add_1, &
			ls_add_2, &
			ls_add_3, &
			ls_add_4, &
			ls_add_5, &
			ls_add_6, &
			ls_zone_code, &
			ls_line_feed, &
			ls_custom_1, &
			ls_custom_2, &
			ls_custom_3, &
			ls_part_name, &
			ls_line_11

DATETIME	ldt_date

DEC {0}	ldec_quantity

///////////////////////////////////////////////
//  Initialization

//ast_Parm = Message.PowerObjectParm
ll_serial = Long ( ast_parm.value1 )

//ls_kanban_number = sle_1.text

SELECT   object.part,
			object.quantity, 
			object.lot,
			object.operator,
			object.last_date
  INTO   :ls_part,
			:ldec_quantity,
			:ls_lot,
			:ls_operator,
			:ldt_date
  FROM   object
 WHERE   object.serial = :ll_serial   ;

SELECT	order_header.customer_part,
			order_header.dock_code,
			order_header.zone_code,
			order_header.line_feed_code,
			order_header.custom01,
			order_header.custom02,
			order_header.custom03,
			order_header.engineering_level,
			destination.name,
 			address_1,
			address_2,
			address_3,
			edi_setups.supplier_code,
			order_header.line11,
			order_header.customer_po
	INTO	:ls_customer_part,
			:ls_dock_code,
			:ls_zone_code,
			:ls_line_feed,
			:ls_custom_1,
			:ls_custom_2,
			:ls_custom_3,
			:ls_eng_level,
			:ls_name,
			:ls_add_1,
			:ls_add_2,
			:ls_add_3,
			:ls_supplier_code,
			:ls_line_11,
			:ls_customer_po
     FROM order_header, object, shipper_detail, shipper, destination, edi_setups
	 WHERE order_header.order_no = shipper_detail.order_no  AND
			 shipper.id = shipper_detail.shipper  AND
			 shipper_detail.part_original = object.part  AND
			 object.shipper = shipper.id  AND
			 order_header.destination = destination.destination  and
			 order_header.destination = edi_setups.destination  and
			 object.serial = :ll_serial     ;
			 
SELECT	part.name
  INTO	:ls_part_name
  FROM	part,
  			object
 WHERE	part.part = object.part  AND
 			object.serial = :ll_serial    ;

UPDATE   object
   SET   custom5 = :ls_kanban_number
 WHERE   object.serial = :ll_serial     ;

COMMIT   ;

SELECT	date_stamp
	 INTO	:ldt_Date
    FROM	audit_trail 
   WHERE	serial = :ll_serial AND
			(type = 'J' OR type = 'R')  ;

  SELECT	parameters.company_name, address_1, address_2, address_3
	 INTO	:ls_company,
			:ls_address_1,
			:ls_address_2,
			:ls_address_3
    FROM	parameters ;

IF ast_parm.value11 = "" THEN
   ls_number_of_labels = "Q1"
ELSE
	ls_number_of_labels = "Q" + ast_parm.value11
END IF

/////////////////////////////////////////////////
//  Main Routine
//
ll_label = PrintOpen ( )

PrintSend ( ll_label, lc_esc + "A" + lc_esc + "R" )
PrintSend ( ll_label, lc_esc + "CS2")

//PART INFO
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V40" + lc_esc + "L0102" + lc_esc + "SPART #" )
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V70" + lc_esc + "SCUST (P)" )
PrintSend ( ll_label, lc_esc + "H385" + lc_esc + "V20" + lc_esc + "$A,110,145,0" + lc_esc + "$=" + Upper ( ls_customer_part ) )
PrintSend ( ll_label, lc_esc + "H310" + lc_esc + "V140" + lc_esc + "D103070" + "*P" + ls_customer_part + "*" )

////QUANTITY INFO
PrintSend ( ll_label, lc_esc + "H920" + lc_esc + "V167" + lc_esc + "L0102" + lc_esc + "SQUANTITY:" ) 
PrintSend ( ll_label, lc_esc + "H920" + lc_esc + "V195" + lc_esc + "S(Q)" )
PrintSend ( ll_label, lc_esc + "H1135" + lc_esc + "V100" + lc_esc + "$A,110,145,0" + lc_esc + "$=" + String ( ldec_quantity ) )
PrintSend ( ll_label, lc_esc + "H1010" + lc_esc + "V25" + lc_esc + "D103090" + "*Q" + String ( ldec_quantity ) + "*" )

//PO NO.
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V240" + lc_esc + "L0102" + lc_esc + "SPO #:" )
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V265" + lc_esc + "S(K)" )
PrintSend ( ll_label, lc_esc + "H405" + lc_esc + "V205" + lc_esc + "$A,110,145,0" + lc_esc + "$=" + ls_customer_po )
PrintSend ( ll_label, lc_esc + "H330" + lc_esc + "V325" + lc_esc + "D103090" + "*K" + ls_customer_po + "*" )

//DLOC
PrintSend ( ll_label, lc_esc + "H920" + lc_esc + "V240" + lc_esc + "L0102" + "DLOC:" )
PrintSend ( ll_label, lc_esc + "H930" + lc_esc + "V265" + lc_esc + "$A,100,100,0" + lc_esc + "$=" + ls_zone_code )

//KANBAN
//PrintSend ( ll_label, lc_esc + "H920" + lc_esc + "V355" + lc_esc + "L0102" + lc_esc + "SDLOC:" )
//PrintSend ( ll_label, lc_esc + "H1020" + lc_esc + "V335" + lc_esc + "$A,100,100,0" + lc_esc + "$=" + ls_zone_code )
 
//SERIAL NO
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V440" + lc_esc + "L0102" + lc_esc + "SSERIAL #" )
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V470" + lc_esc + "S(3S)" )
PrintSend ( ll_label, lc_esc + "H425" + lc_esc + "V405" + lc_esc + "$A,110,145,0" + lc_esc + "$=" + String ( ll_serial ) )
PrintSend ( ll_label, lc_esc + "H330" + lc_esc + "V527" + lc_esc + "D103090" + "*3S" + String ( ll_serial ) + "*" )

//ENG CHG
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V640" + lc_esc + "L0102" + lc_esc + "SENG CHANGE:" )
PrintSend ( ll_label, lc_esc + "H435" + lc_esc + "V640" + lc_esc + "L0101" + lc_esc + "OB" + ls_eng_level  )

//SHIP DATE
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V675" + lc_esc + "L0102" + lc_esc + "S" + "MFG. SHIP DATE:" )
PrintSend ( ll_label, lc_esc + "H455" + lc_esc + "V675" + lc_esc + "L0101" + lc_esc + "OB" + String ( ldt_date, "yy/mm/dd") )

//LOT NO.
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V707" + lc_esc + "L0102" + lc_esc + "S" + "LOT NO.:" )
PrintSend ( ll_label, lc_esc + "H385" + lc_esc + "V707" + lc_esc + "L0101" + lc_esc + "OB" + ls_lot )

//INT PART
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V742" + lc_esc + "L0102" + lc_esc + "S" + "INT PART:" )
PrintSend ( ll_label, lc_esc + "H385" + lc_esc + "V742" + lc_esc + "L0101" + lc_esc + "OB" + ls_part )

//PACKER
PrintSend ( ll_label, lc_esc + "H295" + lc_esc + "V785" + lc_esc + "L0102" + lc_esc + "S" + "PACKER:" )
PrintSend ( ll_label, lc_esc + "H385" + lc_esc + "V785" + lc_esc + "L0101" + lc_esc + "OB" + ls_operator )

//PLT/DOCK
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V440" + lc_esc + "L0102" + lc_esc + "S" + "PLT/DOCK:" )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V460" + lc_esc + "$A,75,75,0" + lc_esc + "$=" + ls_dock_code )

//ZONE_CODE,LINE_FEED & CUSTOM03
//PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V485" + lc_esc + "L0101" + lc_esc + "S" + ls_add_1 )
//PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V505" + lc_esc + "L0101" + lc_esc + "S" + ls_add_2 )
//PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V525" + lc_esc + "L0101" + lc_esc + "S" + ls_add_3 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V545" + lc_esc + "L0101" + lc_esc + "M" + ls_custom_1 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V570" + lc_esc + "L0101" + lc_esc + "M" + ls_custom_2 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V595" + lc_esc + "L0101" + lc_esc + "M" + ls_line_11 )

//ZONE_CODE,LINE_FEED & CUSTOM03(FROM ORDER_DETAIL)
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V640" + lc_esc + "L0101" + lc_esc + "M" +  ls_custom_3 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V653" + lc_esc + "$A,50,40,0" + lc_esc + "$=" +  ls_line_feed )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V690" + lc_esc + "L0101" + lc_esc + "OB" + "SUPPLIER ID:" )
PrintSend ( ll_label, lc_esc + "H1140" + lc_esc + "V690" + lc_esc + "L0101" + lc_esc + "OB" + ls_supplier_code )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V715" + lc_esc + "L0103" + lc_esc + "S" + ls_company )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V757" + lc_esc + "L0101" + lc_esc + "M" + ls_address_1 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V780" + lc_esc + "L0101" + lc_esc + "M" + ls_address_2 )
PrintSend ( ll_label, lc_esc + "H860" + lc_esc + "V803" + lc_esc + "M" + ls_address_3 )

//DRAW LINES
//PrintSend ( ll_label, lc_esc + "N" )
PrintSend ( ll_label, lc_esc + "H280" + lc_esc + "V225" + lc_esc + "FW02H1100" ) 
PrintSend ( ll_label, lc_esc + "H905" + lc_esc + "V25" + lc_esc + "FW02V400" ) 
PrintSend ( ll_label, lc_esc + "H280" + lc_esc + "V425" + lc_esc + "FW02H1100" ) 
PrintSend ( ll_label, lc_esc + "H845" + lc_esc + "V427" + lc_esc + "FW02V395" ) 
PrintSend ( ll_label, lc_esc + "H280" + lc_esc + "V627" + lc_esc + "FW02H1100" ) 

PrintSend ( ll_label, lc_esc + ls_number_of_labels )
PrintSend ( ll_label, lc_esc + "Z" )
PrintClose ( ll_label )
Close ( THIS )
end event
on w_armada_gm_b10.create
end on

on w_armada_gm_b10.destroy
end on

