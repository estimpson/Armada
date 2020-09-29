SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[udf_TempCustomerList]
(	@TruckNumber varchar(50)
,	@PRONumber varchar(35)
)
returns varchar(max)
as
begin
	declare
		@customerList varchar(max) = ''
	
	select
		@customerList = @customerList + CustomerCode + ', '
	from
		dbo.Shipping_DepartingShipperList sdsl
	where
		sdsl.TruckNumber = @TruckNumber
		and coalesce(sdsl.PRONumber, '') = coalesce(@PRONumber, sdsl.PRONumber, '')

	if	@customerList > '' begin
		set
			@customerList = left(@customerList, len(@customerList) - 1)
	end
	
	return @customerList
end
GO
