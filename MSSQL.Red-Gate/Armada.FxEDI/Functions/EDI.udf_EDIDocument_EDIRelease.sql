SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO



Create function [EDI].[udf_EDIDocument_EDIRelease]
(
	@XMLData xml
)
returns varchar(25)
as
begin
--- <Body>
	declare
		@ReturnValue varchar(max)
		
	set @ReturnValue = @XMLData.value('/*[1]/TRN-INFO[1]/@release', 'varchar(25)')
--- </Body>

---	<Return>
	return
		@ReturnValue
end




GO
