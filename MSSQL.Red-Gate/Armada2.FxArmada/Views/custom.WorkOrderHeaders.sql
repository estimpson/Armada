SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO


create view [custom].[WorkOrderHeaders]
as
select
	WorkOrderNumber = 'xWO_' + convert(varchar, getdate(), 112) + right('0000' +
		convert
		(	varchar
		,	row_number() over (order by pm.part, pm.machine)
		), 4)
,	Status = 0
,	Type = 0
,	MachineCode = pm.machine
,	ToolCode = convert(varchar (50), null)
,	Sequence = row_number() over (partition by pm.machine order by pm.part)
,	DueDT = convert(datetime, null)
,	ScheduledSetupHours = 0.0
,	ScheduledStartDT = convert(datetime, null)
,	ScheduledEndDT = convert(datetime, null)
,	RowID = -row_number() over (order by pm.part, pm.machine)
,	RowCreateDT = getdate()
,	RowCreateUser = suser_name()
,	RowModifiedDT = getdate()
,	RowModifiedUser = suser_name()
from
	dbo.part_machine pm

GO
