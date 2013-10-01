
/*
Create Table.FxArmada.custom.destination_message_file.sql
*/

--use FxArmada
--go

--drop table custom.destination_message_file
if	objectproperty(object_id('custom.destination_message_file'), 'IsTable') is null begin

	create table custom.destination_message_file
	(	destination varchar(20) primary key
	,	message1 varchar(50) null
	,	message2 varchar(50) null
	,	message3 varchar(50) null
	,	message4 varchar(50) null
	,	message5 varchar(50) null
	,	message6 varchar(50) null
	,	message7 varchar(50) null
	,	message8 varchar(50) null
	,	message9 varchar(50) null
	,	message10 varchar(50) null
	)
end
go

truncate table
	custom.destination_message_file
go

insert
	custom.destination_message_file
(	destination
,	message1
,	message2
,	message3
,	message4
,	message5
,	message6
,	message7
,	message8
,	message9
,	message10
)
select
	rtrim(dmf.destination)
,	rtrim(dmf.message1)
,	rtrim(dmf.message10)
,	rtrim(dmf.message2)
,	rtrim(dmf.message3)
,	rtrim(dmf.message4)
,	rtrim(dmf.message5)
,	rtrim(dmf.message6)
,	rtrim(dmf.message7)
,	rtrim(dmf.message8)
,	rtrim(dmf.message9)
from
	rawArmada.dbo.destination_message_file dmf
go

