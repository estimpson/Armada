SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[udf_TempShipToList]
(	@TruckNumber varchar(50)
,	@PRONumber varchar(35)
)
returns varchar(max)
as
begin
	declare
		@shipToList varchar(max) = ''
	
	select
		@shipToList = @shipToList + ShipToCode + ', '
	from
		dbo.Shipping_DepartingShipperList sdsl
	where
		sdsl.TruckNumber = @TruckNumber
		and coalesce(sdsl.PRONumber, '') = coalesce(@PRONumber, sdsl.PRONumber, '')

	if	@shipToList > '' begin
		set
			@shipToList = left(@shipToList, len(@shipToList) - 1)
	end
	
	return @shipToList
end
GO
