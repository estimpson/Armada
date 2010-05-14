$PBExportHeader$w_armc_general_gmc_label.srw
forward
global type w_armc_general_gmc_label from Window
end type
end forward

global type w_armc_general_gmc_label from Window
int X=672
int Y=264
int Width=1582
int Height=992
boolean TitleBar=true
string Title="w_std_lable_for_fin"
long BackColor=12632256
boolean ControlMenu=true
boolean MinBox=true
boolean MaxBox=true
boolean Resizable=true
end type
global w_armc_general_gmc_label w_armc_general_gmc_label

type variables
St_generic_structure ast_Parm
end variables

event open; /////////////////////////////////////////////////
//  Declaration
//

ast_Parm = Message.PowerObjectParm

LONG		l_Label, &
			l_Serial, &
			l_position, &
			l_pos_string, &
         l_Shipper

DATETIME   s_Effdt

STRING	c_Esc, &
			s_Part, &
			s_CuPart, &
			s_Customer, &
			s_destination, &
			s_Supplier, &
			s_Eng, &
			s_Temp, &
			s_Name1, &
			s_Name2, &
			s_Name3, &
			s_NumberofLabels, &
			s_Suffix, &
         s_cmpname, &
         s_packerno

Dec {0} dec_Quantity

/////////////////////////////////////////////////
//  Initialization
//

l_Serial = LONG ( ast_Parm.Value1 )

  SELECT part,   
         quantity,   
			destination,
         operator,
         last_date,
         shipper
    INTO :s_Part,   
         :dec_Quantity,   
			:s_destination,
         :s_packerno,
         :s_effdt,
         :l_shipper
    FROM object  
   WHERE serial = :l_Serial   ;

  SELECT name  
    INTO :s_Temp 
    FROM part  
   WHERE part = :s_Part   ;

  SELECT supplier_code  
    INTO :s_Supplier  
    FROM edi_setups  
   WHERE destination = :s_destination   ;

  SELECT engineering_level  
    INTO :s_Eng  
    FROM part_mfg  
   WHERE part = :s_Part   ;

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

  SELECT company_name 
    INTO :s_cmpname 
    FROM parameters;
 
// to get the number of copies of the label 

If ast_Parm.value11 = "" Then 
	s_NumberofLabels = "Q1"
Else
	s_NumberofLabels = "Q" + ast_Parm.value11
End If

c_Esc = "~h1B"

/////////////////////////////////////////////////
//  Main Routine
//

l_Label = PrintOpen ( )

//  Start Printing 

PrintSend ( l_Label, c_Esc + "A" + c_Esc + "R" )
PrintSend ( l_Label, c_Esc + "AR" )

//  Part Info

PrintSend ( l_Label, c_Esc + "V040" + c_Esc + "H300" + c_Esc + "M" + "PART NO" )
PrintSend ( l_Label, c_Esc + "V060" + c_Esc + "H300" + c_Esc + "M" + "(P)" )
PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H450" + c_Esc + "$A,150,150,0" + c_Esc + "$=" + s_cuPart )
PrintSend ( l_Label, c_Esc + "V140" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "P" + s_cuPart + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H300" + c_Esc + "M" + "QUANTITY" )
PrintSend ( l_Label, c_Esc + "V288" + c_Esc + "H300" + c_Esc + "M" + "(Q)" )
PrintSend ( l_Label, c_Esc + "V233" + c_Esc + "H500" + c_Esc + "$A,150,150,0" + c_Esc +"$=" + String(dec_Quantity) )
PrintSend ( l_Label, c_Esc + "V359" + c_Esc + "H350" + c_Esc + "B103095" + "*" +"Q" + String(dec_Quantity) + "*" )

PrintSend ( l_Label, c_Esc + "V263" + c_Esc + "H953" + c_Esc + "M" + "DESCRIPTION" )
PrintSend ( l_Label, c_Esc + "V283" + c_Esc + "H953" + c_Esc + "M" + s_TEMP )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H300" + c_Esc + "M" + "SUPPLIER" )
PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H550" + c_Esc + "WL1" + S_SUPPLIER)
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H300" + c_Esc + "M" + "(V)" )
PrintSend ( l_Label, c_Esc + "V475" + c_Esc + "H500" + c_Esc + "WL1" + s_Supplier )
PrintSend ( l_Label, c_Esc + "V518" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "V" + s_Supplier + "*" )

PrintSend ( l_Label, c_Esc + "V479" + c_Esc + "H953" + c_Esc + "M" + "PACKER NUMBER" )
PrintSend ( l_Label, c_Esc + "V504" + c_Esc + "H953" + c_Esc + "M" + s_part)
//PrintSend ( l_Label, c_Esc + "H926" + c_Esc + "V545" + c_Esc + "FW03H0450")

PrintSend ( l_Label, c_Esc + "V635" + c_Esc + "H953" + c_Esc + "M" + "MFG DATE" )
PrintSend ( l_Label, c_Esc + "V670" + c_Esc + "H953" + c_Esc + "M" + String(date(s_effdt)))
PrintSend ( l_Label, c_Esc + "H926" + c_Esc + "V699" + c_Esc + "FW03H0450")
PrintSend ( l_Label, c_Esc + "V710" + c_Esc + "H953" + c_Esc + "M" + "ENGR CHANGE" )
PrintSend ( l_Label, c_Esc + "V734" + c_Esc + "H953" + c_Esc + "M" + s_eng )

PrintSend ( l_Label, c_Esc + "V631" + c_Esc + "H300" + c_Esc + "M" + "SERIAL " )
PrintSend ( l_Label, c_Esc + "V656" + c_Esc + "H300" + c_Esc + "M" + "(S)" )
PrintSend ( l_Label, c_Esc + "V625" + c_Esc + "H550" + c_Esc + "WL1" + String(l_Serial))
PrintSend ( l_Label, c_Esc + "V668" + c_Esc + "H350" + c_Esc + "B103095" + "*" + "S" + String(l_Serial) + "*")
PrintSend ( l_Label, c_Esc + "V775" + c_Esc + "H350" + c_Esc + "M" + s_cmpname )

//  Draw Lines
PrintSend ( l_Label, c_Esc + "N" )

PrintSend ( l_Label, c_Esc + "V497" + c_Esc + "H254" + c_Esc + "FW03H0515" )

PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H251" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H470" + c_Esc + "FW03V1150" )
PrintSend ( l_Label, c_Esc + "V000" + c_Esc + "H618" + c_Esc + "FW03V1150" )

PrintSend ( l_Label, c_Esc + s_NumberofLabels )
PrintSend ( l_Label, c_Esc + "Z" )
PrintClose ( l_Label )
Close ( this )
end event
on w_armc_general_gmc_label.create
end on

on w_armc_general_gmc_label.destroy
end on

