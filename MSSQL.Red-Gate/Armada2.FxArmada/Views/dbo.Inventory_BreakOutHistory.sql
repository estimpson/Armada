SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [dbo].[Inventory_BreakOutHistory]
as
select
	FromSerial = atBreakFrom.serial
,	TranDT = atBreakFrom.date_stamp
,	FromPartCode = atBreakFrom.part
,	ToSerial = atBreakTo.serial
,	Quantity = atBreakTo.std_quantity
from
	dbo.audit_trail atBreakFrom
	join dbo.audit_trail atBreakTo
		on atBreakTo.type = 'B'
		and atBreakTo.from_loc not like '%[^-0-9]%'
		and convert(int, atBreakTo.from_loc) = atBreakFrom.serial
		and datediff(second, atBreakTo.date_stamp, atBreakFrom.date_stamp) between 0 and 10
where
	atBreakFrom.type = 'B'
GO
