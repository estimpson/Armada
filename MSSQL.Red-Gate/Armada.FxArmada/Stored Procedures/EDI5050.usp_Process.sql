SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO
CREATE procedure [EDI5050].[usp_Process]
	@TranDT datetime = null out
,	@Result integer = null out
,	@Testing int = 1
--<Debug>
,	@Debug integer = 0
--</Debug>
as
set nocount on
set ansi_warnings on
set	@Result = 999999

--<Debug>
declare	@ProcStartDT datetime
declare	@StartDT datetime
if @Debug & 1 = 1 begin
	set	@StartDT = GetDate ()
	print	'START.   ' + Convert (varchar (50), @StartDT)
	set	@ProcStartDT = GetDate ()
end
--</Debug>

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. EDI5050.usp_Test
--- </Error Handling>

--- <Tran Required=Yes AutoCreate=Yes TranDTParm=Yes>
declare
	@TranCount smallint

set	@TranCount = @@TranCount
if	@TranCount = 0 begin
	begin tran @ProcName
end
else begin
	save tran @ProcName
end
set	@TranDT = coalesce(@TranDT, GetDate())
--- </Tran>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
--<Debug>
if @Debug & 1 = 1 begin
	print	'Determine the current 830s and 862s.'
	print	'	Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Determine the current 830s and 862s. */
/*		Active are all 862s for a Ship To / Ship From / last Document DT / last Imported Version (for Document Number / Control Number).*/
declare
	@Current862s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(50)
,	AuxShipToCode varchar(50)
,	ShipFromCode varchar(50)
,	ConsigneeCode varchar(50)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
,	BlanketOrderNo numeric(8,0)
)

insert
	@Current862s
(	RawDocumentGUID
,	ReleaseNo
,	ShipToCode
,	AuxShipToCode
,	ShipFromCode
,	ConsigneeCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	NewDocument
,	BlanketOrderNo
)
select
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,	AuxShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
,	BlanketOrderNo
from
	EDI5050.CurrentShipSchedules ()

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.'
end
--</Debug>
/*		Active are last Imported version of last Doc Number of last Document DT for every combination
		of ShipTo, ShipFrom, InterCompany, and CustomerPart.  */
declare
	@Current830s table
(	RawDocumentGUID uniqueidentifier
,	ReleaseNo varchar(50)
,	ShipToCode varchar(50)
,	AuxShipToCode varchar(50)
,	ShipFromCode varchar(50)
,	ConsigneeCode varchar(50)
,	CustomerPart varchar(35)
,	CustomerPO varchar(35)
,	CustomerModelYear varchar(35)
,	NewDocument int
,	BlanketOrderNo numeric(8,0)
)

insert
	@Current830s
(	RawDocumentGUID
,	ReleaseNo
,	ShipToCode
,	AuxShipToCode
,	ShipFromCode
,	ConsigneeCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	NewDocument
,	BlanketOrderNo
)
select
	RawDocumentGUID
,	ReleaseNo
,   ShipToCode
,	AuxShipToCode
,   ShipFromCode
,   ConsigneeCode
,   CustomerPart
,   CustomerPO
,	CustomerModelYear
,   NewDocument
,	BlanketOrderNo
from
	EDI5050.CurrentPlanningReleases ()

--<Debug>
if @Debug & 1 = 1 begin
	print	'...determined.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

/*		If the current 862s and 830s are already "Active", done. */
if	not exists
	(	select
			*
		from
			@Current862s cd
		where
			cd.NewDocument = 1
	)
	and not exists
	(	select
			*
		from
			@Current830s cd
		where
			cd.NewDocument = 1
	)
	and @Testing = 0 begin
	set @Result = 100
	rollback transaction @ProcName
	return
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Mark "Active" 862s and 830s.'
	set	@StartDT = GetDate ()
end
--- <Update rows="*">
set	@TableName = 'EDI5050.SchipSchedules'

update
	ss
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI5050.ShipSchedules', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI5050.ShipSchedules', 'Status', 'Replaced'))
		end
from
	EDI5050.ShipSchedules ss
	left join @Current862s c
		on ss.RawDocumentGUID = c.RawDocumentGUID 
		and ss.ShipToCode = c.ShipToCode
		and ss.CustomerPart = c.CustomerPart
		and coalesce(ss.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(ss.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
where
	ss.Status in
	(	0 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDI5050.ShipScheduleHeaders'

update
	ssh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDI5050.ShipSchedules ss
				where
					ss.RawDocumentGUID = ssh.RawDocumentGUID
					and ss.Status = 1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDI5050.ShipScheduleHeaders ssh
where
	ssh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Update rows="*">
set	@TableName = 'EDI5050.PlanningReleases'

update
	PR
set
	Status =
		case
			when c.RawDocumentGUID is not null
				then 1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active'))
			else 2 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Replaced'))
		end
from
	EDI5050.PlanningReleases PR
	left join @Current830s c
		on PR.RawDocumentGUID = c.RawDocumentGUID
		and PR.ShipToCode = c.ShipToCode
		and PR.CustomerPart = c.CustomerPart
		and coalesce(PR.CustomerPO, '') = coalesce(c.CustomerPO, '')
		and coalesce(PR.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')

where
	PR.Status in
	(	0 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>

--- <Update rows="*">
set	@TableName = 'EDI5050.PlanningHeaders'

update
	fh
set
	Status =
	case
		when exists
			(	select
					*
				from
					EDI5050.PlanningReleases fr
				where
					fr.RawDocumentGUID = fh.RawDocumentGUID
					and fr.Status = 1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active')
			) then 1 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Active'))
		else 2 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Replaced'))
	end
from
	EDI5050.PlanningHeaders fh
where
	fh.Status in
	(	0 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'New'))
	,	1 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Active'))
	)

select
	@Error = @@Error,
	@RowCount = @@Rowcount

if	@Error != 0 begin
	set	@Result = 999999
	RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
	rollback tran @ProcName
	return
end
--- </Update>
--<Debug>
if @Debug & 1 = 1 begin
	print	'...marked.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

if	@Testing > 1 begin
	if	not exists
		(	select
				*
			from
				EDI5050.ShipScheduleHeaders fh
			where
				fh.Status in (0, 1)
		)
		select
			'ShipScheduleHeaders - empty'
	else
		select
			'ShipScheduleHeaders'
		,	*
		from
			EDI5050.ShipScheduleHeaders fh
		where
			fh.Status in (0, 1)
		
	if	not exists
		(	select
				*
			from
				EDI5050.PlanningHeaders fh
			where
				fh.Status in (0, 1)
		)
		select
			'PlanningHeaders - empty'
	else
		select
			'PlanningHeaders'
		,	*
		from
			EDI5050.PlanningHeaders fh
		where
			fh.Status in (0, 1)

	if	not exists
		(	select
				*
			from
				@Current862s c
		)
		select
			'@Current862s - empty'
	else
		select
			'@Current862s'
		,	*
		from
			@Current862s c

	if	not exists
		(	select
				*
			from
				@Current830s c
		)
		select
			'@Current830s - empty'
	else
		select
			'@Current830s'
		,	*
		from
			@Current830s c
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'Write new releases.'
	print	'	Calculate raw releases from active 862s and 830s.'
	set	@StartDT = GetDate ()
end
--</Debug>
/*	Write new releases. */
/*		Calculate raw releases from active 862s and 830s. */
declare
	@RawReleases table
(	RowID int not null IDENTITY(1, 1) primary key
,	Status int default(0)
,	ReleaseType int
,	OrderNo int
,	Type tinyint
,	ReleaseDT datetime
,	BlanketPart varchar(25)
,	CustomerPart varchar(35)
,	ShipToID varchar(20)
,	CustomerPO varchar(20)
,	ModelYear varchar(4)
,	OrderUnit char(2)
,	QtyShipper numeric(20,6)
,	Line int
,	ReleaseNo varchar(30)
,	DockCode varchar(30) null
,	LineFeedCode varchar(30) null
,	ReserveLineFeedCode varchar(30) null
,	QtyRelease numeric(20,6)
,	StdQtyRelease numeric(20,6)
,	ReferenceAccum numeric(20,6)
,	CustomerAccum numeric(20,6)
,	RelPrior numeric(20,6)
,	RelPost numeric(20,6)
,	NewDocument int
,	unique
	(	OrderNo
	,	NewDocument
	,	RowID
	)
,	unique
	(	OrderNo
	,	RowID
	,	RelPost
	,	QtyRelease
	,	StdQtyRelease
	)
,	unique
	(	OrderNo
	,	Type
	,	RowID
	)
)

insert
	@RawReleases
(	ReleaseType
,	OrderNo
,	Type
,	ReleaseDT
,	BlanketPart
,	CustomerPart
,	ShipToID
,	CustomerPO
,	ModelYear
,	OrderUnit
,	ReleaseNo
,	QtyRelease
,	StdQtyRelease
,	ReferenceAccum
,	CustomerAccum
,	NewDocument
)
/*		Add releases due today when behind and no release for today exists. */
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = ft.fn_TruncDate('dd', getdate())
,	BlanketPart = min(bo.PartCode)
,	CustomerPart = min(bo.CustomerPart)
,	ShipToID = min(bo.ShipToCode)
,	CustomerPO = min(bo.CustomerPO)
,	ModelYear = min(bo.ModelYear)
,	OrderUnit = min(bo.OrderUnit)
,	ReleaseNo = 'Accum Demand'
,	QtyRelease = 0
,	StdQtyRelease = 0
,	ReferenceAccum = max
		(	case
				bo.ReferenceAccum 
				when 'N'
					then coalesce(convert(int,bo.AccumShipped),0)
				when 'C' 
					then coalesce(convert(int,fa.LastAccumQty),0)
				else
					coalesce(convert(int,bo.AccumShipped),0)
			end
		)
,	CustomerAccum = max
		(	case
				bo.AdjustmentAccum 
				when 'N' 
					then coalesce(convert(int,bo.AccumShipped),0)
				when 'P' 
					then coalesce(convert(int,faa.PriorCUM),0)
				else
					coalesce(convert(int,fa.LastAccumQty),0)
			end
		)
,	NewDocument = c.NewDocument
from
	@Current862s c
	join EDI5050.ShipScheduleHeaders fh
		on fh.RawDocumentGUID = c.RawDocumentGUID
	join EDI5050.ShipSchedules fr
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and coalesce(fr.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fr.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fr.CustomerPO, '') = c.CustomerPO
		and coalesce(fr.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.ShipScheduleAccums fa
		on fa.RawDocumentGUID = c.RawDocumentGUID
		and fa.ShipToCode = c.ShipToCode
		and coalesce(fa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fa.CustomerPO, '') = c.CustomerPO
		and coalesce(fa.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = c.RawDocumentGUID
		and faa.ShipToCode = c.ShipToCode
		and coalesce(faa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(faa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(faa.CustomerPO, '') = c.CustomerPO
		and coalesce(faa.CustomerModelYear, '') = c.CustomerModelYear
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = c.BlanketOrderNo
where
	not exists
	(	select
			*
		from
			EDI5050.ShipSchedules ss
		where
			ss.status = 1 and
			ss.RawDocumentGUID = c.RawDocumentGUID and
			ss.RawDocumentGUID = fr.RawDocumentGUID
			and ss.CustomerPart = fr.CustomerPart
			and ss.ShipToCode = fr.ShipToCode
			and	ss.ReleaseDT = ft.fn_TruncDate('dd', getdate())
	)
	and fh.Status = 1 --(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'Active'))
	and	c.RawDocumentGUID = fr.RawDocumentGUID
group by
	bo.BlanketOrderNo
,	fh.RawDocumentGUID
,	bo.ReferenceAccum
,	bo.AdjustmentAccum
,	c.NewDocument
having
	case
		bo.AdjustmentAccum 
		when 'N' 
			then min(coalesce(convert(int,bo.AccumShipped),0))
		when 'P' 
			then min(coalesce(convert(int,faa.PriorCUM),0))
		else
			min(coalesce(convert(int,fa.LastAccumQty),0))
	end >
	case
		bo.ReferenceAccum 
		when 'N' 
			then min(coalesce(convert(int,bo.AccumShipped),0))
		when 'C' 
			then min(coalesce(convert(int,fa.LastAccumQty),0))
		else
			min(coalesce(convert(int,bo.AccumShipped),0))
	end

/*		862s. */
union all
select
	ReleaseType = 1
,	OrderNo = bo.BlanketOrderNo
,	Type = 1
,	ReleaseDT = dateadd(dd, bo.ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo = case when fr.SupplierCode = 'A055P' and fr.Userdefined5 is not null then fr.Userdefined5 else fr.ReleaseNo end
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum =
		case
			bo.ReferenceAccum 
			when 'N'
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'C' 
				then coalesce(convert(int,fa.LastAccumQty),0)
			else
				coalesce(convert(int,bo.AccumShipped),0)
		end
,	CustomerAccum =
		case
			bo.AdjustmentAccum 
			when 'N' 
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'P' 
				then coalesce(convert(int,faa.PriorCUM),0)
			else
				coalesce(convert(int,fa.LastAccumQty),0)
		end
,	NewDocument = c.NewDocument
from
	@Current862s c
	join EDI5050.ShipScheduleHeaders fh
		on fh.RawDocumentGUID = c.RawDocumentGUID
	join EDI5050.ShipSchedules fr
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and coalesce(fr.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fr.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fr.CustomerPart, '') = c.CustomerPart
		and coalesce(fr.CustomerPO, '') = c.CustomerPO
		and coalesce(fr.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.ShipScheduleAccums fa
		on fa.RawDocumentGUID = c.RawDocumentGUID
		and fa.ShipToCode = c.ShipToCode
		and coalesce(fa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fa.CustomerPart, '') = c.CustomerPart
		and coalesce(fa.CustomerPO, '') = c.CustomerPO
		and coalesce(fa.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.ShipScheduleAuthAccums faa
		on faa.RawDocumentGUID = c.RawDocumentGUID
		and faa.ShipToCode = c.ShipToCode
		and coalesce(faa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(faa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(faa.CustomerPart, '') = c.CustomerPart
		and coalesce(faa.CustomerPO, '') = c.CustomerPO
		and coalesce(faa.CustomerModelYear, '') = c.CustomerModelYear
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = c.BlanketOrderNo
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDI5050.ShipScheduleHeaders', 'Status', 'Active'))

/*		830s. */
union all
select
	ReleaseType = 2
,	OrderNo = bo.BlanketOrderNo
,	Type =
		case 
			when bo.PlanningFlag = 'P'
				then 2
			when bo.PlanningFlag = 'F'
				then 1
			when bo.planningFlag = 'A' and fr.ScheduleType not in ('C', 'A', 'Z')
				then 2
			else
				1
		end
,	ReleaseDT = dateadd(dd, bo.ReleaseDueDTOffsetDays, fr.ReleaseDT)
,	BlanketPart = bo.PartCode
,	CustomerPart = bo.CustomerPart
,	ShipToID = bo.ShipToCode
,	CustomerPO = bo.CustomerPO
,	ModelYear = bo.ModelYear
,	OrderUnit = bo.OrderUnit
,	ReleaseNo =
		case
			when fr.suppliercode = 'A0144'
				then fr.Userdefined5
			when
				fr.suppliercode in ('ARM701', 'ARM101')
				and fr.Userdefined5 is not null
				then fr.UserDefined5
			else
				fr.ReleaseNo
		end
,	QtyRelease = fr.ReleaseQty
,	StdQtyRelease = fr.ReleaseQty
,	ReferenceAccum =
		case
			bo.ReferenceAccum 
			when 'N'
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'C' 
				then coalesce(convert(int,fa.LastAccumQty),0)
			else
				coalesce(convert(int,bo.AccumShipped),0)
		end
,	CustomerAccum =
		case
			bo.AdjustmentAccum 
			when 'N' 
				then coalesce(convert(int,bo.AccumShipped),0)
			when 'P' 
				then coalesce(convert(int,faa.PriorCUM),0)
			else
				coalesce(convert(int,fa.LastAccumQty),0)
		end
,	NewDocument = c.NewDocument
from
	@Current830s c
	join EDI5050.PlanningHeaders fh
		on fh.RawDocumentGUID = c.RawDocumentGUID
	join EDI5050.PlanningReleases fr
		on fr.RawDocumentGUID = c.RawDocumentGUID
		and fr.ShipToCode = c.ShipToCode
		and coalesce(fr.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fr.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fr.CustomerPart, '') = c.CustomerPart
		and coalesce(fr.CustomerPO, '') = c.CustomerPO
		and coalesce(fr.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.PlanningAccums fa
		on fa.RawDocumentGUID = c.RawDocumentGUID
		and fa.ShipToCode = c.ShipToCode
		and coalesce(fa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(fa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(fa.CustomerPart, '') = c.CustomerPart
		and coalesce(fa.CustomerPO, '') = c.CustomerPO
		and coalesce(fa.CustomerModelYear, '') = c.CustomerModelYear
	left join EDI5050.PlanningAuthAccums faa
		on faa.RawDocumentGUID = c.RawDocumentGUID
		and faa.ShipToCode = c.ShipToCode
		and coalesce(faa.AuxShipToCode, '') = c.AuxShipToCode
		and coalesce(faa.ShipFromCode, '') = c.ShipFromCode
		and coalesce(faa.CustomerPart, '') = c.CustomerPart
		and coalesce(faa.CustomerPO, '') = c.CustomerPO
		and coalesce(faa.CustomerModelYear, '') = c.CustomerModelYear
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = c.BlanketOrderNo
where
	fh.Status = 1 --(select dbo.udf_StatusValue('EDI5050.PlanningHeaders', 'Status', 'Active'))
	and fr.Status = 1 --(select dbo.udf_StatusValue('EDI5050.PlanningReleases', 'Status', 'Active'))
	--and coalesce(nullif(fr.Scheduletype,''),'4') in ('4')
order by
	2,1,4

if	@Testing > 1 begin

	if	not exists
		(	select
				*
			from
				@RawReleases rr
		)
		select
			'@RawReleases-Init - empty'
	else
		select
			'@RawReleases-Init'
		,	*
		from
			@RawReleases rr
end

/*		Calculate orders to update. */
update
	rr
set
	NewDocument =
	(	select
			max(NewDocument)
		from
			@RawReleases rr2
		where
			rr2.OrderNo = rr.OrderNo
	)
from
	@RawReleases rr

if	@Testing = 0 begin
	delete
		rr
	from
		@RawReleases rr
	where
		rr.NewDocument = 0
end

update
	@RawReleases
set
	RelPost = CustomerAccum + coalesce (
	(	select
			sum (StdQtyRelease)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and ReleaseType = rr.ReleaseType
			and	RowID <= rr.RowID), 0)
from
	@RawReleases rr

/*		Calculate running cumulatives. */
update
	rr
set
	RelPost = case when rr.ReferenceAccum > rr.RelPost then rr.ReferenceAccum else rr.RelPost end
from
	@RawReleases rr


update
	rr
set
	RelPrior = coalesce (
	(	select
			max(RelPost)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID < rr.RowID), ReferenceAccum)
from
	@RawReleases rr

	--For Armada Only..Update Release Number with Accum Increase if customer's accum causes the qty to be increased
update
	rr
set
	releaseNo = 'Accum Increase'
from
	@RawReleases rr
where
		RelPost-RelPrior > QtyRelease

update
	rr
set
	QtyRelease = RelPost - RelPrior
,	StdQtyRelease = RelPost - RelPrior
from
	@RawReleases rr

update
	rr
set
	Status = -1
from
	@RawReleases rr
where
	QtyRelease <= 0

/* Move Planning Release dates beyond last Ship Schedule Date that has a quantity due*/
update
	rr
set
	ReleaseDT = dateadd(dd,1,(select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1and Status>-1))
from
	@RawReleases rr
where
	rr.ReleaseType = 2
	and rr.ReleaseDT <= (select max(ReleaseDT) from @RawReleases where OrderNo = rr.OrderNo and ReleaseType = 1 and Status>-1)

/*	Calculate order line numbers and committed quantity. */
update
	rr
set	Line =
	(	select
			count(*)
		from
			@RawReleases
		where
			OrderNo = rr.OrderNo
			and	RowID <= rr.RowID
			and Status = 0
	)
,	QtyShipper = shipSchedule.qtyRequired
from
	@RawReleases rr
	left join
	(	select
			orderNo = sd.order_no
		,	qtyRequired = sum(qty_required)
		from
			dbo.shipper_detail sd
			join dbo.shipper s
				on s.id = sd.shipper
		where 
			s.type is null
			and s.status in ('O', 'A', 'S')
		group by
			sd.order_no
	) shipSchedule
		on shipSchedule.orderNo = rr.OrderNo
where
	rr.status = 0

--<Debug>
if @Debug & 1 = 1 begin
	print	'	...calculated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>

--<Debug>
if @Debug & 1 = 1 begin
	print	'	Replace order detail.'
	set	@StartDT = GetDate ()
end
--</Debug>

if	@Testing > 1 begin

	if	not exists
		(	select
				*
			from
				@RawReleases rr
		)
		select
			'@RawReleases-Final - empty'
	else
		select
			'@RawReleases-Final'
		,	*
		from
			@RawReleases rr
end

/*		Replace order detail. */
if	@Testing = 0 begin

	if	objectproperty(object_id('dbo.order_detail_deleted'), 'IsTable') is not null begin
		drop table dbo.order_detail_deleted
	end
	select
		*
	into
		dbo.order_detail_deleted
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	order by
		order_no
	,	due_date
	,	sequence
	
	--- <Delete rows="*">
	set	@TableName = 'dbo.order_detail'
	
	delete
		od
	from
		dbo.order_detail od
	where
		od.order_no in (select OrderNo from @RawReleases)
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error deleting from table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Delete>
	
	--- <Insert rows="*">
	set	@TableName = 'dbo.order_detail'
	
	insert
		dbo.order_detail
	(	order_no, sequence, part_number, product_name, type, quantity
	,	status, notes, unit, due_date, release_no, destination
	,	customer_part, row_id, flag, ship_type, packline_qty, packaging_type
	,	weight, plant, week_no, std_qty, our_cum, the_cum, price
	,	alternate_price, committed_qty
	)
	select
		order_no = rr.OrderNo
	,	sequence = rr.Line + coalesce((select max (sequence) from order_detail where order_no = rr.OrderNo), 0)
	,	part_number = rr.BlanketPart
	,	product_name = (select name from dbo.part where part = rr.BlanketPart)
	,	type = case rr.Type when 1 then 'F' when 2 then 'P' end
	,	quantity = rr.RelPost - rr.relPrior
	,	status = ''
	,	notes = 'Processed Date : '+ convert(varchar, getdate(), 120) + ' ~ ' + case rr.Type when 1 then 'EDI Processed Release' when 2 then 'EDI Processed Release' end
	,	unit = (select unit from order_header where order_no = rr.OrderNo)
	,	due_date = rr.ReleaseDT
	,	release_no = rr.ReleaseNo
	,	destination = rr.ShipToID
	,	customer_part = rr.CustomerPart
	,	row_id = rr.Line + coalesce((select max (row_id) from order_detail where order_no = rr.OrderNo), 0)
	,	flag = 1
	,	ship_type = 'N'
	,	packline_qty = 0
	,	packaging_type = bo.PackageType
	,	weight = (rr.RelPost - rr.relPrior) * bo.UnitWeight
	,	plant = (select plant from order_header where order_no = rr.OrderNo)
	,	week_no = datediff(wk, (select fiscal_year_begin from parameters), rr.ReleaseDT) + 1
	,	std_qty = rr.RelPost - rr.relPrior
	,	our_cum = rr.RelPrior
	,	the_cum = rr.RelPost
	,	price = (select price from order_header where order_no = rr.OrderNo)
	,	alternate_price = (select alternate_price from order_header where order_no = rr.OrderNo)
	,	committed_qty = coalesce
		(	case
				when rr.QtyShipper > rr.RelPost - bo.AccumShipped then rr.RelPost - rr.relPrior
				when rr.QtyShipper > rr.RelPrior - bo.AccumShipped then rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
			end
		,	0
		)
	from
		@RawReleases rr
		join EDI5050.BlanketOrders bo
			on bo.BlanketOrderNo = rr.OrderNo
	where
		rr.Status = 0
	order by
		1, 2
	
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
	
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error inserting into table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Insert>
	
	--- <Update rows="*">
	set	@TableName = 'dbo.order_header'
		
	update
		oh
	set
		custom01 = rtrim(prs.UserDefined1)
	,	dock_code = rtrim(prs.UserDefined1)
	,	line_feed_code = rtrim(prs.UserDefined2)
	,	zone_code = rtrim(prs.UserDefined3)

	from
		dbo.order_header oh
	join
			EDI5050.blanketOrders bo
	on
			bo.BlanketOrderNo = oh.order_no
	join
			(Select * From @Current830s) cpr 
		on
			cpr.CustomerPart = bo.customerpart and
			cpr.ShipToCode = bo.EDIShipToCode and
			(	bo.CheckCustomerPOPlanning = 0
						or bo.CustomerPO = cpr.CustomerPO
			)
				and	(	bo.CheckModelYearPlanning= 0
						or bo.ModelYear830 = cpr.CustomerModelYear
			)
		join
			EDI5050.PlanningSupplemental prs
	on
			prs.RawDocumentGUID = cpr.RawDocumentGUID and
			prs.CustomerPart = cpr.CustomerPart and
			coalesce(prs.CustomerPO,'') = cpr.CustomerPO and
			prs.CustomerModelYear = cpr.CustomerModelYear  and
			prs.ShipToCode = cpr.ShipToCode
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Update>
		
	--- <Update rows="*">
	set	@TableName = 'dbo.order_header'
		
	update
		oh
	set
		custom01 = rtrim(sss.UserDefined1)
	,	dock_code = rtrim(sss.UserDefined1)
	,	line_feed_code = rtrim(sss.UserDefined2)
	,	zone_code = rtrim(sss.UserDefined3)
	,	line11 = rtrim(sss.UserDefined11)
	,	line12 = rtrim(sss.UserDefined12)
	,	line13 = rtrim(sss.UserDefined13)
	,	line14 = rtrim(sss.UserDefined14)
	,	line15 = rtrim(sss.UserDefined15)
	,	line16 = rtrim(sss.UserDefined16)
	,	line17 = rtrim(sss.UserDefined17)
	from
		dbo.order_header oh
	join
			EDI5050.blanketOrders bo
	on
			bo.BlanketOrderNo = oh.order_no
	join
			(Select * From @Current862s) css 
		on
			css.CustomerPart = bo.customerpart and
			css.ShipToCode = bo.EDIShipToCode and
			(	bo.CheckCustomerPOShipSchedule = 0
						or bo.CustomerPO = css.CustomerPO
			)
				and	(	bo.CheckModelYearShipSchedule = 0
						or bo.ModelYear862 = css.CustomerModelYear
			)
		join
			EDI5050.ShipScheduleSupplemental sss
	on
			sss.RawDocumentGUID = css.RawDocumentGUID and
			sss.CustomerPart = css.CustomerPart and
			coalesce(sss.CustomerPO,'') = css.CustomerPO and
			sss.CustomerModelYear = css.CustomerModelYear  and
			sss.ShipToCode = css.ShipToCode
		
	select
		@Error = @@Error,
		@RowCount = @@Rowcount
		
	if	@Error != 0 begin
		set	@Result = 999999
		RAISERROR ('Error updating table %s in procedure %s.  Error: %d', 16, 1, @TableName, @ProcName, @Error)
		rollback tran @ProcName
		return
	end
	--- </Update>
end
--end
else begin
	if	@Testing > 1 begin
		if	not exists
			(	select
					*
				from
					@RawReleases
			)
			select
				'raw releases - empty'
		else
			select
				'raw releases'
			,	Type
			,	OrderNo
			,	BlanketPart
			,	CustomerPart
			,	ShipToID
			,	CustomerPO
			,	ModelYear
			,	OrderUnit
			,	QtyShipper
			,	Line
			,	ReleaseNo
			,	QtyRelease
			,	StdQtyRelease
			,	ReferenceAccum
			,	RelPrior
			,	RelPost
			,	ReleaseDT
			from
				@RawReleases
			order by
				OrderNo
			,	RowID
		

		if	not exists
			(	select
					*
				from
					dbo.order_detail od
				where
					od.order_no in (select OrderNo from @RawReleases)
			)
			select
				'to be deleted - empty'
		else
			select
				'to be deleted'
			,	od.*
			from
				dbo.order_detail od
			where
				od.order_no in (select OrderNo from @RawReleases)
			order by
				order_no
			,	due_date
	end
		
		
	/*	to be inserted*/
	if	not exists
		(	select
				*
			from
				@RawReleases rr
				join EDI5050.BlanketOrders bo
					on bo.BlanketOrderNo = rr.OrderNo
		)
		select
			'to be inserted - empty'
	else
		select
			'to be inserted'
		,	order_no = rr.OrderNo
		,	sequence = rr.Line
		,	part_number = rr.BlanketPart
		,	product_name = (select name from dbo.part where part = rr.BlanketPart)
		,	type = case rr.Type when 1 then 'F' when 2 then 'P' end
		,	quantity = rr.RelPost - rr.relPrior
		,	status = ''
		,	notes = 'Processed Date : '+ convert(varchar, getdate(), 120) + ' ~ ' + case rr.Type when 1 then 'EDI Processed Release' when 2 then 'EDI Processed Release' end
		,	unit = (select unit from order_header where order_no = rr.OrderNo)
		,	due_date = rr.ReleaseDT
		,	release_no = rr.ReleaseNo
		,	destination = rr.ShipToID
		,	customer_part = rr.CustomerPart
		,	row_id = rr.Line
		,	flag = 1
		,	ship_type = 'N'
		,	packline_qty = 0
		,	packaging_type = bo.PackageType
		,	weight = (rr.RelPost - rr.relPrior) * bo.UnitWeight
		,	plant = (select plant from order_header where order_no = rr.OrderNo)
		,	week_no = datediff(wk, (select fiscal_year_begin from parameters), rr.ReleaseDT) + 1
		,	std_qty = rr.RelPost - rr.relPrior
		,	our_cum = rr.RelPrior
		,	the_cum = rr.RelPost
		,	price = (select price from order_header where order_no = rr.OrderNo)
		,	alternate_price = (select alternate_price from order_header where order_no = rr.OrderNo)
		,	committed_qty = coalesce
			(	case
					when rr.QtyShipper > rr.RelPost - bo.AccumShipped then rr.RelPost - rr.relPrior
					when rr.QtyShipper > rr.RelPrior - bo.AccumShipped then rr.QtyShipper - (rr.RelPrior - bo.AccumShipped)
				end
			,	0
			)
		from
			@RawReleases rr
			join EDI5050.BlanketOrders bo
				on bo.BlanketOrderNo = rr.OrderNo
		order by
			1, 2
end
--<Debug>
if @Debug & 1 = 1 begin
	print	'	...replaced.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end
--</Debug>
--- </Body>

--<Debug>
if @Debug & 1 = 1 begin
	print	'FINISHED.   ' + Convert (varchar, DateDiff (ms, @ProcStartDT, GetDate ())) + ' ms'
end
--</Debug>

--- <Closetran AutoRollback=Yes>
if	@TranCount = 0 begin
	rollback tran @ProcName
end
--- </Closetran>

/* Start E-Mail Alerts and Exceptions*/
declare
	@EDIOrdersAlert table
(	TradingPartner varchar(30) null
,	DocumentType varchar(30) null	--'PR - Planning Release; SS - ShipSchedule'
,	AlertType varchar(100) null
,	ReleaseNo varchar(100) null
,	ShipToCode varchar(100) null
,	AuxShipToCode varchar(100) null
,	ConsigneeCode varchar(100) null
,	ShipFromCode varchar(100) null
,	CustomerPart varchar(100) null
,	CustomerPO varchar(100) null
,	CustomerModelYear varchar null
,	Description varchar(max)
)
		
insert
	@EDIOrdersAlert
(	TradingPartner
,	DocumentType
,	AlertType
,	ReleaseNo
,	ShipToCode
,	AuxShipToCode
,	ConsigneeCode
,	ShipFromCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	Description
)

--Missing blanket orders
select
	TradingPartner = coalesce((select max(TradingPartner) from FxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID), '')
,	DocumentType = 'SS'
,	AlertType = ' Exception'
,	ReleaseNo = coalesce(a.ReleaseNo, '')
,	ShipToCode = a.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode = coalesce(a.ConsigneeCode, '')
,	ShipFromCode = coalesce(a.ShipFromCode, '')
,	CustomerPart = coalesce(a.CustomerPart, '')
,	CustomerPO = coalesce(a.CustomerPO, '')
,	CustomerModelYear = coalesce(a.CustomerModelYear, '')
,	Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current862s a
where
	(	@Testing > 0
		or coalesce(a.newDocument,0) = 1
	)
	and a.BlanketOrderNo is null
union
select
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Exception'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = a.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Please Add Blanket Order to Fx and Reprocess EDI'
from
	@Current830s a
Where
	(	@Testing > 0
		or coalesce(a.newDocument,0) = 1
	)
	and a.BlanketOrderNo is null
union

--Orders Processed
select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current862s a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo
where
	(	@Testing > 0
		or coalesce(a.newDocument,0) = 1
	)
union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' OrderProcessed'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'EDI Processed for Fx Blanket Sales Order No: ' + convert(varchar(15), bo.BlanketOrderNo)
from
	@Current830s a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo

--Accums Reporting
union
Select 
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'SS'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(ssa.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(ssa.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(ssaa.PriorCUM,0))
from
	@Current862s a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo
	left join
		EDI5050.ShipScheduleAccums ssa on 
		ssa.RawDocumentGUID = a.RawDocumentGUID and
		ssa.ShipToCode = a.ShipToCode and
		ssa.CustomerPart = a.CustomerPart and
		coalesce(ssa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDI5050.ShipScheduleAuthAccums ssaa on 
		ssaa.RawDocumentGUID = a.RawDocumentGUID and
		ssaa.ShipToCode = a.ShipToCode and
		ssaa.CustomerPart = a.CustomerPart and
		coalesce(ssaa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(ssaa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
where
	(	@Testing > 0
		or coalesce(a.newDocument,0) = 1
	)
	and coalesce(bo.AccumShipped,0) != coalesce(ssa.LastAccumQty,0)
union
select
	TradingPartner = Coalesce((Select max(TradingPartner) from fxEDI.EDI.EDIDocuments where GUID = a.RawDocumentGUID) ,'')
,	DocumentType = 'PR'
,	AlertType =  ' Accum Notice'
,	ReleaseNo =  Coalesce(a.ReleaseNo,'')
,	ShipToCode = bo.ShipToCode
,	AuxShipToCode = a.AuxShipToCode
,	ConsigneeCode =  coalesce(a.ConsigneeCode,'')
,	ShipFromCode = coalesce(a.ShipFromCode,'')
,	CustomerPart = Coalesce(a.CustomerPart,'')
,	CustomerPO = Coalesce(a.CustomerPO,'')
,	CustomerModelYear = Coalesce(a.CustomerModelYear,'')
,   Description = 'Customer Accum Received != Fx Accum Shipped for BlanketOrder No ' 
					+ convert(varchar(15), bo.BlanketOrderNo) 
					+ '  Customer Accum: ' 
					+ convert(varchar(15), coalesce(pra.LastAccumQty,0))
					+ '  Our Accum Shipped: '
					+ convert(varchar(15), coalesce(bo.AccumShipped,0))
					+ '  Customer Last Recvd Qty: ' 
					+ convert(varchar(15), coalesce(pra.LastQtyReceived,0))
					+ '  Our Last Shipped Qty: '
					+ convert(varchar(15), coalesce(bo.LastShipQty,0))
					+ '  Customer Prior Auth Accum: ' 
					+ convert(varchar(15), coalesce(praa.PriorCUM,0))
from
	@Current830s  a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo
	left join
		EDI5050.PlanningAccums pra on 
		pra.RawDocumentGUID = a.RawDocumentGUID and
		pra.ShipToCode = a.ShipToCode and
		pra.CustomerPart = a.CustomerPart and
		coalesce(pra.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(pra.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
 	left join
		EDI5050.PlanningAuthAccums praa on 
		praa.RawDocumentGUID = a.RawDocumentGUID and
		praa.ShipToCode = a.ShipToCode and
		praa.CustomerPart = a.CustomerPart and
		coalesce(praa.CustomerPO,'') = coalesce(a.customerPO,'') and
		coalesce(praa.CustomerModelYear,'') = coalesce(a.customerModelYear,'')
where
	(	@Testing > 0
		or coalesce(a.newDocument,0) = 1
	)
	and coalesce(bo.AccumShipped,0) != coalesce(pra.LastAccumQty,0)

order by 1,2,5,4,7

if	@Testing > 1 begin

	if	not exists
		(	select
				*
			from
				@EDIOrdersAlert eoa
		)
		select
			'@EDIOrdersAlert - empty'
	else
		select
			'@EDIOrdersAlert'
		,	*
		from
			@EDIOrdersAlert eoa
end

--Update Order Header with Customer's Accum Received ---Armada Only
update
	oh
set
	oh.raw_cum = coalesce(ssa.LastAccumQty, 0)
from
	@Current862s a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo
	left join EDI5050.ShipScheduleAccums ssa
		on ssa.RawDocumentGUID = a.RawDocumentGUID
		and ssa.ShipToCode = a.ShipToCode
		and ssa.CustomerPart = a.CustomerPart
		and coalesce(ssa.CustomerPO, '') = coalesce(a.CustomerPO, '')
		and coalesce(ssa.CustomerModelYear, '') = coalesce(a.CustomerModelYear, '')
	left join EDI5050.ShipScheduleAuthAccums ssaa
		on ssaa.RawDocumentGUID = a.RawDocumentGUID
		and ssaa.ShipToCode = a.ShipToCode
		and ssaa.CustomerPart = a.CustomerPart
		and coalesce(ssaa.CustomerPO, '') = coalesce(a.CustomerPO, '')
		and coalesce(ssaa.CustomerModelYear, '') = coalesce(a.CustomerModelYear, '')
	join dbo.order_header oh
		on oh.order_no = bo.BlanketOrderNo
where
	coalesce(a.NewDocument, 0) = 1

update
	oh
set
	oh.fab_cum = coalesce(pra.LastAccumQty, 0)
from
	@Current830s a
	join EDI5050.BlanketOrders bo
		on bo.BlanketOrderNo = a.BlanketOrderNo
	left join EDI5050.PlanningAccums pra
		on pra.RawDocumentGUID = a.RawDocumentGUID
		and pra.ShipToCode = a.ShipToCode
		and pra.CustomerPart = a.CustomerPart
		and coalesce(pra.CustomerPO, '') = coalesce(a.CustomerPO, '')
		and coalesce(pra.CustomerModelYear, '') = coalesce(a.CustomerModelYear, '')
	left join EDI5050.PlanningAuthAccums praa
		on praa.RawDocumentGUID = a.RawDocumentGUID
		and praa.ShipToCode = a.ShipToCode
		and praa.CustomerPart = a.CustomerPart
		and coalesce(praa.CustomerPO, '') = coalesce(a.CustomerPO, '')
		and coalesce(praa.CustomerModelYear, '') = coalesce(a.CustomerModelYear, '')
	join dbo.order_header oh
		on oh.order_no = bo.BlanketOrderNo
where
	coalesce(a.NewDocument, 0) = 1

select
	TradingPartner
,	DocumentType
,	AlertType
,	ReleaseNo
,	ShipToCode
,	AuxShipToCode
,	ConsigneeCode
,	ShipFromCode
,	CustomerPart
,	CustomerPO
,	CustomerModelYear
,	Description
into
	#EDIAlerts
from
	@EDIOrdersAlert

select
	TradingPartner
,	DocumentType	--'PR - Planning Release; SS - ShipSchedule'
,	AlertType
,	ReleaseNo
,	ShipToCode
,	AuxShipToCode
,	ConsigneeCode
,	CustomerPart
,	CustomerPO
,	Description
into
	#EDIAlertsEmail
from
	@EDIOrdersAlert

if	@Testing > 1 begin

	if	not exists
		(	select
				*
			from
				#EDIAlerts ea
		)
		select
			'#EDIAlerts - empty'
	else
		select
			'#EDIAlerts'
		,	*
		from
			#EDIAlerts ea

	if	not exists
		(	select
				*
			from
				#EDIAlertsEmail eae
		)
		select
			'#EDIAlertsEmail - empty'
	else
		select
			'#EDIAlertsEmail'
		,	*
		from
			#EDIAlertsEmail eae
end

if exists (select * from #EDIAlerts)
begin
	declare
		@html	nvarchar(max)
	,	@EmailTableName sysname = N'#EDIAlertsEmail'

	exec FT.usp_TableToHTML
		@tableName = @EmailTableName
	,	@orderBy = N'AlertType'
	,	@html = @html output
	,	@includeRowNumber = 0
	,	@camelCaseHeaders = 1

	declare
		@EmailBody	nvarchar(max)
	,	@EmailHeader nvarchar(max) = N'EDI Processing for EDI5050'

	select
		@EmailBody	= N'<H1>' + @EmailHeader + N'</H1>' + @html

	--print @emailBody

	exec msdb.dbo.sp_send_dbmail
		@profile_name = 'FxArmadaMail1'					-- sysname
	,	@recipients = 'czurawski@armadarubber.com'		-- varchar(max)
	,	@copy_recipients = 'estimpson@fore-thought.com' -- varchar(max)
	,	@subject = @EmailHeader
	,	@body = @EmailBody
	,	@body_format = 'HTML'
	,	@importance = 'High'

	insert
		EDIAlerts.ProcessedReleases
	(	EDIGroup
	,	TradingPartner
	,	DocumentType	--'PR - Planning Release; SS - ShipSchedule'
	,	AlertType
	,	ReleaseNo
	,	ShipToCode
	,	ConsigneeCode
	,	ShipFromCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerModelYear
	,	Description
	)
	select
		'EDI5050'
	,	TradingPartner
	,	DocumentType
	,	AlertType
	,	ReleaseNo
	,	ShipToCode + coalesce(' | ' + nullif(nullif(AuxShipToCode, ShipToCode), ''), '')
	,	ConsigneeCode
	,	ShipFromCode
	,	CustomerPart
	,	CustomerPO
	,	CustomerModelYear
	,	Description
	from
		#EDIAlerts
	union
	select
		'EDI5050'
	,	TradingPartner = coalesce((
								select
										max(TradingPartner)
									from
										FxEDI.EDI.EDIDocuments
									where
										GUID = a.RawDocumentGUID
								)
								, ''
								)
	,	DocumentType = 'SS'
	,	AlertType = 'Exception Quantity Due'
	,	ReleaseNo = coalesce(a.ReleaseNo, '')
	,	ShipToCode = a.ShipToCode + coalesce(' | ' + nullif(nullif(a.AuxShipToCode, a.ShipToCode), ''), '')
	,	ConsigneeCode = coalesce(a.ConsigneeCode, '')
	,	ShipFromCode = coalesce(a.ShipFromCode, '')
	,	CustomerPart = coalesce(a.CustomerPart, '')
	,	CustomerPO = coalesce(a.CustomerPO, '')
	,	CustomerModelYear = coalesce(a.CustomerModelYear, '')
	,	Description = 'Qty Due : ' + convert(varchar(max), c.ReleaseQty) + ' on - '
					+ convert(varchar(max), c.ReleaseDT)
	from
		@Current862s a
		join EDI5050.ShipSchedules c
			on c.RawDocumentGUID = a.RawDocumentGUID
			and a.CustomerPart = c.CustomerPart
			and a.ShipToCode = c.ShipToCode
			and a.AuxShipToCode = coalesce(c.AuxShipToCode, '')
			and coalesce(a.CustomerPO, '') = coalesce(c.CustomerPO, '')
			and coalesce(a.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
	where
		coalesce(a.NewDocument, 0) = 1
		and a.BlanketOrderNo is null
union
	select
		'EDI5050'
	,	TradingPartner = coalesce((
								select
										max(TradingPartner)
									from
										FxEDI.EDI.EDIDocuments
									where
										GUID = a.RawDocumentGUID
								)
								, ''
								)
	,	DocumentType = 'PR'
	,	AlertType = 'Exception Quantity Due'
	,	ReleaseNo = coalesce(a.ReleaseNo, '')
	,	ShipToCode = a.ShipToCode + coalesce(' | ' + nullif(nullif(a.AuxShipToCode, a.ShipToCode), ''), '')
	,	ConsigneeCode = coalesce(a.ConsigneeCode, '')
	,	ShipFromCode = coalesce(a.ShipFromCode, '')
	,	CustomerPart = coalesce(a.CustomerPart, '')
	,	CustomerPO = coalesce(a.CustomerPO, '')
	,	CustomerModelYear = coalesce(a.CustomerModelYear, '')
	,	Description = 'Qty Due : ' + convert(varchar(max), c.ReleaseQty) + ' on - '
					+ convert(varchar(max), c.ReleaseDT)
	from
		@Current830s a
		join EDI5050.PlanningReleases c
			on c.RawDocumentGUID = a.RawDocumentGUID
			and a.CustomerPart = c.CustomerPart
			and a.ShipToCode = c.ShipToCode
			and coalesce(a.CustomerPO, '') = coalesce(c.CustomerPO, '')
			and coalesce(a.CustomerModelYear, '') = coalesce(c.CustomerModelYear, '')
	where
		coalesce(a.NewDocument, 0) = 1
		and a.BlanketOrderNo is null
end
/* End E-Mail and Exceptions */

---	<Return>
set
	@Result = 0
return
	@Result
--- </Return>

/*
Example:
Initial queries
{

}

Test syntax
{

set statistics io on
set statistics time on
go

begin transaction
go

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = EDI5050.usp_Process
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Testing = 0


set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

commit transaction
--rollback transaction

go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
