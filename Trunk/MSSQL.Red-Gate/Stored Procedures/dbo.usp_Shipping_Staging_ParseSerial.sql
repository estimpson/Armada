SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


CREATE procedure [dbo].[usp_Shipping_Staging_ParseSerial]
	@SerialString varchar(30)
as

-- Get the length of the most recent serial number created
declare @MaxSerialLength int
select
	@MaxSerialLength = len(max(serial))
from
	object


-- Parse out a serial number from the string based on the max serial's length
declare @Serial int
select
	@Serial = serial 
from 
	dbo.object
where 
	convert(varchar, serial) = right(@SerialString, @MaxSerialLength)


-- Serial's may have recently rolled over into the millions, so
--   attempt to parse for an older serial
if (@Serial is null) begin
	select
		@Serial = serial 
	from 
		dbo.object
	where 
		convert(varchar, serial) = right(@SerialString, @MaxSerialLength - 1)
end


-- Return result
select
	serial
from
	dbo.object
where
	serial = @Serial
GO
