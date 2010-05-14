$PBExportHeader$w_kf_stdship.srw
forward
global type w_kf_stdship from Window
end type
end forward

global type w_kf_stdship from Window
int X=673
int Y=265
int Width=1582
int Height=993
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_kf_stdship w_kf_stdship

type variables
St_generic_structure Stparm
end variables

on open;//  Standard Ship label for Kalfact

/////////////////////////////////////////////////
//  Declaration
//
Stparm = Message.PowerObjectParm
//Int iLabel		  // 16-bit Open Handle
Long ll_Label		  // 32-bit Open Handle

String cEsc         // Escape Code
String szLoc        // Location
String szLot        // Material Lot
String szUnit       // Unit Of Measure
String szOperator   // Operator
String szPart, szP
String szDestination
String szSupplier
String szCompany, szEng
String ls_Name[4]
String szAddress1, szAddress2, szAddress3
String szNumberofLabels
String szCustpart
String ls_CustPONo
String ls_Notes
String ls_OrderNo

int    ls_orderno_int

Long   lSerial

Dec {0} dQuantity, nPo

Time tTime

Date dDate

datetime dt_date_time

/////////////////////////////////////////////////
//  Initialization
//

lSerial = Long(Stparm.Value1)
  SELECT part,   
         lot,   
         location,   
         last_date,   
         unit_measure,   
         operator,   
         quantity,   
         last_time, po_number,
			destination
    INTO :szPart,   
         :szLot,   
         :szLoc,   
         :dt_Date_time,   
         :szUnit,   
         :szOperator,   
         :dQuantity,   
         :dt_date_Time, 
			:nPo,
			:szdestination 
    FROM object  
   WHERE serial = :lSerial   ;

ddate = date(dt_date_time)
ttime = time(dt_date_time)

szP        = Stparm.Value2 
szSupplier = StParm.Value3
ls_OrderNo = StParm.Value8
ls_orderno_int = integer(stparm.value8)

  SELECT description_long  
    INTO :ls_notes
    FROM part  
   WHERE part= :szPart   ;

	SELECT company_name, address_1, address_2, address_3
	  INTO :szCompany,
		    :szAddress1,
		    :szAddress2,
		    :szAddress3
	  FROM parameters ;

  SELECT engineering_level  
    INTO :szEng  
    FROM part_mfg  
   WHERE part = :szPart   ;

	SELECT customer_part
	  INTO :szCustpart
	  FROM order_header
	 WHERE blanket_part = :szPart	;

	SELECT customer_po
	  INTO :ls_CustPONo
	  FROM order_header
	 WHERE order_no = :ls_OrderNo_int ;

If Stparm.value11 = "" Then
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If

ls_Name[1] = Mid ( ls_Notes, 1, 30 )
ls_Name[2] = Mid ( ls_Notes, 31, 30 )
ls_Name[3] = Mid ( ls_Notes, 61, 30 )
ls_Name[4] = Mid ( ls_Notes, 91, 30 )

cEsc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

ll_Label = PrintOpen ( )

//  Start Printing
PrintSend ( ll_Label, cEsc + "A" + cEsc + "R" )

//  Part Info
PrintSend ( ll_Label, cEsc + "V027" + cEsc + "H300" + cEsc + "M" + "PART NO" )
PrintSend ( ll_Label, cEsc + "V047" + cEsc + "H300" + cEsc + "M" + "(P)" )
PrintSend ( ll_Label, cEsc + "V006" + cEsc + "H420" + cEsc + "$A,130,130,0" + cEsc + "$=" + szCustpart )
PrintSend ( ll_Label, cEsc + "V139" + cEsc + "H346" + cEsc + "B103095" + "*" + "P" + szCustpart + "*" )

//  Quantity Info
PrintSend ( ll_Label, cEsc + "V263" + cEsc + "H300" + cEsc + "M" + "QUANTITY" )
PrintSend ( ll_Label, cEsc + "V283" + cEsc + "H300" + cEsc + "M" + "(Q)" )
PrintSend ( ll_Label, cEsc + "V245" + cEsc + "H490" + cEsc + "$A,130,130,0" + cEsc +"$=" + String ( dQuantity ) )
PrintSend ( ll_Label, cEsc + "V354" + cEsc + "H346" + cEsc + "B103095" + "*" +"Q" + String ( dQuantity ) + "*" )

//  Supplier Info
PrintSend ( ll_Label, cEsc + "V480" + cEsc + "H300" + cEsc + "M" + "SUPPLIER  " )
PrintSend ( ll_Label, cEsc + "WL1" + szSupplier )
PrintSend ( ll_Label, cEsc + "V500" + cEsc + "H300" + cEsc + "M" + "(V)" )
PrintSend ( ll_Label, cEsc + "V523" + cEsc + "H346" + cEsc + "B103095" + "*" + "V" + szSupplier + "*")

//  Serial Info
PrintSend ( ll_Label, cEsc + "V637" + cEsc + "H300" + cEsc + "M" + "SERIAL # " )
PrintSend ( ll_Label, cEsc + "WL1" + String ( lSerial ) )
PrintSend ( ll_Label, cEsc + "V661" + cEsc + "H300" + cEsc + "M" + "(S)" )
PrintSend ( ll_Label, cEsc + "V683" + cEsc + "H346" + cEsc + "B103095" + "*" + "S" + String( lserial ) + "*" )

//  Description Info
PrintSend ( ll_Label, cEsc + "V255" + cEsc + "H835" + cEsc + "M" + "DESCRIPTION:" )
PrintSend ( ll_Label, cEsc + "V280" + cEsc + "H815" + cEsc + "$A,40,40,0" + cEsc + "$=" + Trim ( ls_Name[1] ) )
PrintSend ( ll_Label, cEsc + "V315" + cEsc + "H815" + cEsc + "$A,40,40,0" + cEsc + "$=" + Trim ( ls_Name[2] ) )
PrintSend ( ll_Label, cEsc + "V350" + cEsc + "H815" + cEsc + "$A,40,40,0" + cEsc + "$=" + Trim ( ls_Name[3] ) )
PrintSend ( ll_Label, cEsc + "V385" + cEsc + "H815" + cEsc + "$A,40,40,0" + cEsc + "$=" + Trim ( ls_Name[4] ) )

//  Lot Info
PrintSend ( ll_Label, cEsc + "V425" + cEsc + "H815" + cEsc + "M" + "LOT #" )
PrintSend ( ll_Label, cEsc + "WL1" + szLot )

//  Date Info
PrintSend ( ll_Label, cEsc + "V485" + cEsc + "H1000" + cEsc + "M" + "DATE  " )
PrintSend ( ll_Label, cEsc + cEsc + "WL1" + String(today()) )

//  Engineering Change Info
PrintSend ( ll_Label, cEsc + "V550" + cEsc + "H1000" + cEsc + "M" + "ENGR. CHANGE  " )
PrintSend ( ll_Label, cEsc + cEsc + "WL1" + szEng )

//  PO Info
PrintSend ( ll_Label, cEsc + "V637" + cEsc + "H1000" + cEsc + "M" + "PO#(A)" + cEsc + "WL1" + ls_CustPONo )
PrintSend ( ll_Label, cEsc + "V683" + cEsc + "H960" + cEsc + "B103095" + "*" + "A" + ls_CustPONo + "*" )

//  Company Info
PrintSend ( ll_Label, cEsc + "L0102" )
PrintSend ( ll_Label, cEsc + "V785" + cEsc + "H310" + cEsc + "S" + szCompany + "  " + szAddress1 + " " + szAddress2 + "  " + szAddress3 )

//  Draw Lines
PrintSend ( ll_Label, cEsc + "N" )
PrintSend ( ll_Label, cEsc + "V623" + cEsc + "H240" + cEsc + "FW02H0230" )
PrintSend ( ll_Label, cEsc + "V460" + cEsc + "H472" + cEsc + "FW02H0157" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H241" + cEsc + "FW02V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H470" + cEsc + "FW02V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H628" + cEsc + "FW02V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H535" + cEsc + "FW02V0460" )
PrintSend ( ll_Label, cEsc + szNumberofLabels )
PrintSend ( ll_Label, cEsc + "Z" )
PrintClose ( ll_Label )
Close ( this )
end on

on w_kf_stdship.create
end on

on w_kf_stdship.destroy
end on

