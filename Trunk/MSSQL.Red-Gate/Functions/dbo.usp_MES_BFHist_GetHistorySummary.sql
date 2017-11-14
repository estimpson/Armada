SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create function [dbo].[usp_MES_BFHist_GetHistorySummary]
(	@FromDT datetime
,	@ToDT datetime
)
returns @BFHist_Summary table
(	PartProduced varchar(25)
,	WorkOrderNumber varchar(50)
,	JobID int
,	QtyPerBox numeric(20,6)
,	BoxesProduced int
,	MissingComponentCount int
,	MissingDescription varchar(max)
)
as
begin
--- <Body>
	--insert
	--	@BFHist_Summary
	--(	PartProduced
	--,	WorkOrderNumber
	--,	JobID
	--,	QtyPerBox
	--,	BoxesProduced
	--,	MissingComponentCount
	--,	MissingDescription
	--)	
	--select
	--	bh.PartProduced
	--,	bh.WorkOrderNumber
	--,	JobID = wod.RowID
	--,	QtyPerBox = max(bh.QtyProduced)
	--,	BoxesProduced = count(distinct bh.SerialProduced)
	--,	MissingComponentCount = count(distinct case when bd.QtyOverage > 0 then bd.PartConsumed end)
	--,	MissingDescription = --Fx.ToList(case when bd.QtyOverage > 0 then bd.PartConsumed + ' (' + convert(varchar, bd.QtyOverage) + ')' end)
	--		(	select
	--				Fx.ToList(case when bd2.QtyOverage > 0 then bd2.PartConsumed + ' (' + replace(ltrim(rtrim(replace(replace(ltrim(rtrim(replace(bd2.QtyOverage, '0', ' '))), ' ', '0'), '.', ' '))), ' ', '.') + ')' end)
	--			from
	--				(	select
	--						bh2.WorkOrderNumber
	--					,	bd2.PartConsumed
	--					,	QtyOverage = sum(bd2.QtyOverage)
	--					from
	--						dbo.BackflushHeaders bh2
	--						join dbo.BackflushDetails bd2
	--							on bd2.BackflushNumber = bh2.BackflushNumber
	--					where
	--						bh2.TranDT between @FromDT and @ToDT
	--					group by
	--						bh2.WorkOrderNumber
	--					,	bd2.PartConsumed
	--				) bd2
	--			where
	--				bd2.WorkOrderNumber = bh.WorkOrderNumber
	--		)
	--from
	--	dbo.BackflushHeaders bh
	--		join dbo.WorkOrderDetails wod
	--			on wod.WorkOrderNumber = bh.WorkOrderNumber
	--			and wod.Line = bh.WorkOrderDetailLine
	--	join dbo.BackflushDetails bd
	--		on bd.BackflushNumber = bh.BackflushNumber
	--where
	--	bh.TranDT between @FromDT and @ToDT
	--group by
	--	bh.PartProduced
	--,	bh.WorkOrderNumber
	--,	wod.RowID
	--order by
	--	1, 2

	declare
		@WOConsumptionShortages table
	(	WorkOrderNumber varchar(50)
	,	PartConsumed varchar(25)
	,	QtyOverage numeric(20,6)
	,	RunoutDT datetime
	);

	with bd
	(	WorkOrderNumber
	,	BackflushNumber
	,	TranDT
	,	Line
	,	PartConsumed
	,	SerialConsumed
	,	QtyAvailable
	,	QtyIssue
	,	QtyOverage
	,	PartConsumptionLine
	)
	as
	(	select
			bh2.WorkOrderNumber
		,	bd2.BackflushNumber
		,	bh2.TranDT
		,	bd2.Line
		,   bd2.PartConsumed
		,   bd2.SerialConsumed
		,   bd2.QtyAvailable
		,   bd2.QtyIssue
		,   bd2.QtyOverage
		,	PartConsumptionLine = row_number() over (partition by bh2.WorkOrderNumber, bd2.PartConsumed order by bh2.TranDT)
		from
			dbo.BackflushHeaders bh2
			join dbo.BackflushDetails bd2
				on bd2.BackflushNumber = bh2.BackflushNumber
		where
			bh2.TranDT between @FromDT and @ToDT
	)
	insert
		@WOConsumptionShortages
	(	WorkOrderNumber
	,	PartConsumed
	,	QtyOverage
	,	RunoutDT
	)
	select
		bd.WorkOrderNumber
	,	bd.PartConsumed
	,   sum(bd.QtyOverage)
	,   min(bd.TranDT)
	from
		(	select
				bd1.*
			,	MissedAllocationInstance = sum(case when bd1.QtyOverage > 0 and coalesce(bd2.QtyOverage, 0) = 0 then 1 else 0 end) over (partition by bd1.WorkOrderNumber, bd1.PartConsumed order by bd1.PartConsumptionLine)
			from
				bd bd1
				left join bd bd2
					on bd1.WorkOrderNumber = bd2.WorkOrderNumber
					and bd1.PartConsumed = bd2.PartConsumed
					and bd1.PartConsumptionLine = bd2.PartConsumptionLine + 1
		) bd
	group by
		bd.WorkOrderNumber
	,	bd.PartConsumed
	,	bd.MissedAllocationInstance
	having
		sum(bd.QtyOverage) > 0
	order by
		bd.WorkOrderNumber
	,	bd.PartConsumed
	,	bd.MissedAllocationInstance

	insert
		@BFHist_Summary
	(	PartProduced
	,	WorkOrderNumber
	,	JobID
	,	QtyPerBox
	,	BoxesProduced
	,	MissingComponentCount
	,	MissingDescription
	)	
	select
		bh.PartProduced
	,	bh.WorkOrderNumber
	,	JobID = wod.RowID
	,	QtyPerBox = max(bh.QtyProduced)
	,	BoxesProduced = count(distinct bh.SerialProduced)
	,	MissingComponentCount = count(distinct case when bd.QtyOverage > 0 then bd.PartConsumed end)
	,	MissingDescription = --Fx.ToList(case when bd.QtyOverage > 0 then bd.PartConsumed + ' (' + convert(varchar, bd.QtyOverage) + ')' end)
			--(	select
			--		Fx.ToList(case when bd2.QtyOverage > 0 then bd2.PartConsumed + ' @' + convert(varchar, bd2.RunoutDT, 13) + ' (' + replace(ltrim(rtrim(replace(replace(ltrim(rtrim(replace(bd2.QtyOverage, '0', ' '))), ' ', '0'), '.', ' '))), ' ', '.') + ')' end)
			--	from
			--		@WOConsumptionShortages bd2
			--	where
			--		bd2.WorkOrderNumber = bh.WorkOrderNumber
			--		and bd2.QtyOverage > 0
			--)
		case when wcs.QtyOverage > 0 then wcs.PartConsumed + ' @' + convert(varchar, wcs.RunoutDT, 13) + ' (' + replace(ltrim(rtrim(replace(replace(ltrim(rtrim(replace(wcs.QtyOverage, '0', ' '))), ' ', '0'), '.', ' '))), ' ', '.') + ')' end
	from
		dbo.BackflushHeaders bh
			join dbo.WorkOrderDetails wod
				on wod.WorkOrderNumber = bh.WorkOrderNumber
				and wod.Line = bh.WorkOrderDetailLine
		join dbo.BackflushDetails bd
			on bd.BackflushNumber = bh.BackflushNumber
		left join @WOConsumptionShortages wcs
			on bh.WorkOrderNumber = wcs.WorkOrderNumber
			and bd.PartConsumed = wcs.PartConsumed
	where
		bh.TranDT between @FromDT and @ToDT
	group by
		bh.PartProduced
	,	bh.WorkOrderNumber
	,	wod.RowID
	,	wcs.PartConsumed, wcs.QtyOverage, wcs.RunoutDT
	order by
		1, 2
--- </Body>

---	<Return>
	return
end
GO
