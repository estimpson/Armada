SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

CREATE procedure [dbo].[usp_InventoryControl_CycleCount_GetScanProgress]
	@CycleCountNumber varchar(50)
,	@Part varchar(25)
as
set nocount on
set ansi_warnings off

--- <Body>
select
	ExpectedCount = convert(int, sum(co.ExpectedCount))
,	FoundCount = convert(int, sum(co.FoundCount))
from
	(	select
			ExpectedCount = max(case when iccco.Status != -2 then 1 else 0 end)
		,	FoundCount = max(case when iccco.Status > 0 then 1 else 0 end)
		from
			dbo.InventoryControl_CycleCountObjects iccco
		where
			iccco.CycleCountNumber = @CycleCountNumber
			and Part = @Part
		group by
			iccco.Serial
	) co
--- </Body>


GO
