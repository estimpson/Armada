SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


Create function [dbo].[fn_GreaterOf]
(	@Value1 numeric(20,6),
	@Value2 numeric(20,6))
returns	numeric(20,6)
as
begin
	declare	@GreaterOfValue numeric (20,6)

	if	isNULL(@Value1,0)>=isNULL(@Value2,0) 
		Select	@GreaterOfValue = isNULL(@Value1,0)
	else
		Select	@GreaterOfValue = isNULL(@Value2,0)
			

	return	@GreaterOfValue
end

GO
