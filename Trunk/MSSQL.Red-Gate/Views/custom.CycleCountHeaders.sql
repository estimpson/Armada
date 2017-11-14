SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [custom].[CycleCountHeaders]
as
select
	iccch.CycleCountNumber
,	iccch.Status
,	iccch.Type
,	iccch.Description
,	iccch.CountBeginDT
,	iccch.CountEndDT
,	iccch.ExpectedCount
,	iccch.FoundCount
,	iccch.RecoveredCount
,	iccch.QtyAdjustedCount
,	iccch.LocationChangedCount
,	iccch.RowID
,	iccch.RowCreateDT
,	iccch.RowCreateUser
,	iccch.RowModifiedDT
,	iccch.RowModifiedUser
from
	dbo.InventoryControl_CycleCountHeaders iccch
GO
