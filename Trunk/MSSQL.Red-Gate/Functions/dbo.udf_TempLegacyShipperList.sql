SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[udf_TempLegacyShipperList]
(	@TruckNumber varchar(50)
,	@PRONumber varchar(35)
)
returns varchar(max)
as
begin
	declare
		@shipperList varchar(max) = ''
	
	select
		@shipperList = @shipperList + CONVERT(varchar, sdsl.LegacyShipperID) + ', '
	from
		dbo.Shipping_DepartingShipperList sdsl
	where
		sdsl.TruckNumber = @TRuckNumber
		and coalesce(sdsl.PRONumber, '') = coalesce(@PRONumber, sdsl.PRONumber, '')

	if	@shipperList > '' begin
		set
			@shipperList = LEFT(@shipperList, len(@shipperList) - 1)
	end
	
	return @shipperList
end
GO
