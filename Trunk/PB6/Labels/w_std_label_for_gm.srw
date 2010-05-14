$PBExportHeader$w_std_label_for_gm.srw
forward
global type w_std_label_for_gm from Window
end type
end forward

global type w_std_label_for_gm from Window
int X=673
int Y=265
int Width=1559
int Height=993
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_std_label_for_gm w_std_label_for_gm

type variables
St_generic_structure Stparm
end variables

on open;//  Standard label for job completion

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
String szPart
String szDes, szSupplier
String szCompany
String szTemp
String szName1
String szName2
String szName3
String szNumberofLabels

Long   lSerial

Dec {0} dQuantity

Time tTime

Date dDate

Datetime dt_date_time

/////////////////////////////////////////////////
//  Initialization
//

//lSerial = Message.DoubleParm
lSerial = Long(Stparm.Value1)
  SELECT object.part,   
         object.lot,   
         object.location,   
         object.last_date,   
         object.unit_measure,   
         object.operator,   
         object.quantity,   
         object.last_time  
    INTO :szPart,   
         :szLot,   
         :szLoc,   
         :dt_Date_time,   
         :szUnit,   
         :szOperator,   
         :dQuantity,   
         :dt_date_Time  
    FROM object  
   WHERE object.serial = :lSerial   ;
Ddate = date(dt_date_time)
ttime = time(dt_date_time)

  SELECT part.name,  
    		part.description_short
	INTO :szTemp,
			:szDes	  
    FROM part  
   WHERE part.part = :szPart   ;

  SELECT parameters.company_name  
    INTO :szCompany  
    FROM parameters  ;

If Stparm.value11 = "" Then
	szNumberofLabels = "Q1"
Else
	szNumberofLabels = "Q" + Stparm.value11
End If
 	
szPart = Stparm.Value2
szSupplier = Stparm.Value3
szName1 = Mid ( szTemp, 1, 20 )
szName2 = Mid ( szTemp, 21, 20 )
szName3 = Mid ( szTemp, 41, 20 )

cEsc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

ll_Label = PrintOpen ( )

//  Start Printing
PrintSend ( ll_Label, cEsc + "A" + cEsc + "R" )

//  Part Info
PrintSend ( ll_Label, cEsc + "V070" + cEsc + "H346" )
PrintSend ( ll_Label, cEsc + "M" + "PART NO." )
PrintSend ( ll_Label, cEsc + "V083" + cEsc + "H350" + cEsc +"$A,200,100,0" + cEsc + "$=" + szPart )
PrintSend ( ll_Label, cEsc + "V181" + cEsc + "H406" )
PrintSend ( ll_Label, cEsc + "B102095" + "*"  + szPart + "*" )

//	 Quantity Info
PrintSend ( ll_Label, cEsc + "V313" +cEsc + "H346" )
PrintSend ( ll_Label, cEsc + "M" + "QUANTITY" )
PrintSend ( ll_Label, cEsc + "V320" +cEsc + "H350" )
PrintSend ( ll_Label, cEsc + "$A,150,100,0" + cEsc + "$=" + String ( dQuantity ) )
PrintSend ( ll_Label, cEsc + "V409" + cEsc + "H391" )
PrintSend ( ll_Label, cEsc + "B102095" + "*"  + String ( dQuantity ) + "*" )


//	Serial Number
PrintSend ( ll_Label, cEsc + "V681" + cEsc + "H346" )
PrintSend ( ll_Label, cEsc + "M" + "SERIAL #" )
PrintSend ( ll_Label, cEsc + "WB1" + String ( lSerial ) )
PrintSend ( ll_Label, cEsc + "V708" + cEsc + "H391" )
PrintSend ( ll_Label, cEsc + "B102085" + "*" + "S" + String ( lSerial ) + "*" )

PrintSend ( ll_Label, cEsc + "V313" + cEsc + "H820" + cEsc + "M" + "DESCRIPTION" )
PrintSend ( ll_Label, cEsc + "V350" + cEsc + "H850" + cEsc + "WL1" + szDes )
PrintSend ( ll_Label, cEsc + "V529" + cEsc + "H350" + cEsc + "M" + "SUPPLIER" )
PrintSend ( ll_Label, cEsc + "V750" + cEsc + "H960" + cEsc + "M" + "ENG. CHANG" )

PrintSend ( ll_Label, cEsc + "V810" + cEsc + "H346" + cEsc + "M" + szCompany )
PrintSend ( ll_Label, cEsc + "V708" + cEsc + "H960" + cEsc + "M" + "DATE" + " " + String ( Today ( ) ) )
//PrintSend ( ll_Label, cEsc + "V529" + cEsc + "H965" + cEsc + "M" + "time" + szHour + ":" + szMinute )
//PrintSend ( ll_Label, cEsc + "V619" + cEsc + "H965" + cEsc + "M" + "OPERATOR" + " " + szOperator )


PrintSend ( ll_Label, cEsc + "N" )
//PrintSend ( ll_Label, cEsc + "V098" + cEsc + "H063" + cEsc + "FW0606V1157H0764" )
PrintSend ( ll_Label, cEsc + "V485" + cEsc + "H522" + cEsc + "FW06H0299" )
PrintSend ( ll_Label, cEsc + "V627" + cEsc + "H294" + cEsc + "FW06H0230" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H291" + cEsc + "FW06V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H520" + cEsc + "FW06V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H668" + cEsc + "FW06V1127" )
PrintSend ( ll_Label, cEsc + "V000" + cEsc + "H742" + cEsc + "FW06V490" )
PrintSend ( ll_Label, cEsc + szNumberofLabels )
PrintSend ( ll_Label, cEsc + "Z" )

PrintClose ( ll_Label )

Close ( this ) 
end on

on w_std_label_for_gm.create
end on

on w_std_label_for_gm.destroy
end on

