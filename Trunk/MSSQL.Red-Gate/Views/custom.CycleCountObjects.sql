SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create view [custom].[CycleCountObjects]
as
select
	iccco.CycleCountNumber
,	iccco.Line
,	iccco.Serial
,	iccco.ParentSerial
,	iccco.Status
,	iccco.Type
,	iccco.Part
,	iccco.OriginalQuantity
,	iccco.CorrectedQuantity
,	iccco.Unit
,	iccco.OriginalLocation
,	iccco.CorrectedLocation
,	iccco.RowCommittedDT
,	iccco.RowID
,	iccco.RowCreateDT
,	iccco.RowCreateUser
,	iccco.RowModifiedDT
,	iccco.RowModifiedUser
from
	dbo.InventoryControl_CycleCountObjects iccco
GO
