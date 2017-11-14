SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO

create procedure [dbo].[usp_Scheduling_BuildXRt]
	@TranDT datetime = null out
,	@Result integer = null out
---<Debug>
,	@Debug integer = 0
---</Debug>
as
set nocount on
set ansi_warnings off
set	@Result = 999999

--- <Error Handling>
declare
	@CallProcName sysname,
	@TableName sysname,
	@ProcName sysname,
	@ProcReturn integer,
	@ProcResult integer,
	@Error integer,
	@RowCount integer

set	@ProcName = user_name(objectproperty(@@procid, 'OwnerId')) + '.' + object_name(@@procid)  -- e.g. dbo.usp_Test
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

---<Debug>
declare
	@StartDT datetime

set	@StartDT = @TranDT
---</Debug>

---	<ArgumentValidation>

---	</ArgumentValidation>

--- <Body>
truncate table
	FT.BOM

insert
	FT.BOM
(	BOMID
,	ParentPart
,	ChildPart
,	StdQty
,	ScrapFactor
,	SubstitutePart
)
select
	BOMID
,	ParentPart
,	ChildPart
,	StdQty
,	ScrapFactor
,	SubstitutePart
from
	FT.vwBOM

truncate table
	FT.PartRouter

insert
	FT.PartRouter
(	Part
,	BufferTime
,	RunRate
,	CrewSize
)
select
	Part,
	BufferTime,
	RunRate,
	CrewSize
from
	FT.vwPRT

--	I.	Create an empty copy of eXpanded Router table.
--<Debug>
if @Debug & 1 = 1 begin
	print	'I.	Create an empty copy of eXpanded Router table.'
end--</Debug>
create table #XRt
(	ID int identity primary key
,	TopPart varchar(25) not null
,	ChildPart varchar(25) not null
,	BOMID int null
,	Sequence smallint null
,	BOMLevel smallint default (0) not null
,	XQty float default (1) not null
,	XScrap float default (1) not null
,	XBufferTime float default (0) not null
,	XRunRate float default (0) not null
,	Substitute bit default (0)
,	Hierarchy varchar(500) not null
,	Infinite smallint default (0) not null
,	unique (BOMLevel,Infinite,ID)
,	unique (BOMID,TopPart,BOMLevel,Hierarchy,Infinite,ID)
,	unique (TopPart,Hierarchy,ID)
)

--	II.	Populate #eXpanded Router datastructure.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Populate #eXpanded Router datastructure...'
end--</Debug>
--		A.	Load all missing parts.
--<Debug>
if @Debug & 1 = 1 begin
	print	'	A.	Load all parts.'
end--</Debug>
insert
	#XRt
(	TopPart
,	ChildPart
,	Hierarchy
)
select
	Part
,	Part
,	Part
from
	FT.PartRouter PartRouter

while
	@@RowCount > 0 begin
--		B.	Loading children.
--<Debug>
	if @Debug & 1 = 1 begin
		print	'	B.	Loading children.'
	end
--</Debug>
--			1.	Mark infinites.
--<Debug>
	if @Debug & 1 = 1 begin
		print	'		1.	Mark infinites.'
	end
--</Debug>
	update
		xr
	set 
		Infinite = 1
	from
		#XRt xr
	where
		exists
		(	select
				*
			from
				#XRt xr1
			where
				xr.TopPart = xr1.TopPart
				and xr.BOMLevel > xr1.BOMLevel
				and left(xr.Hierarchy, len(xr1.Hierarchy)) = xr1.Hierarchy
				and xr.BOMID = xr1.BOMID
		)

--			2.	Insert children.
--<Debug>
	if @Debug & 1 = 1 begin
		print	'		2.	Insert children.'
	end
---</Debug>
	insert
		#XRt
	(	TopPart, ChildPart, BOMID, BOMLevel, XQty, XScrap, XBufferTime, XRunRate, Substitute, Hierarchy)
	select
		xr.TopPart
	,   BOM.ChildPart
	,   BOM.BOMID
	,   BOMLevel + 1
	,   XQty * StdQty
	,   XScrap * ScrapFactor
	,   XBufferTime + isnull(PartRouter.BufferTime,0)
	,   XRunRate + isnull(PartRouter.RunRate,0)
	,	Substitute = BOM.SubstitutePart
	,   Hierarchy + '/' + convert
		(	varchar
		,	row_number() over (partition by xr.TopPart, BOM.ParentPart order by BOM.ChildPart)
		)
	from
		#XRt xr
		join FT.BOM BOM
			on xr.ChildPart = BOM.ParentPart
		left outer join FT.PartRouter PartRouter
			on BOM.ChildPart = PartRouter.Part
	where
		Infinite = 0
		and BOMLevel =
		(	select
				max(BOMLevel)
			from
				#XRt
		)
end

--<Debug>
if @Debug & 1 = 1 begin
	print	'...@XRt populated.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end--</Debug>

--	II.	Set sequence on #eXpanded Routers.
--<Debug>
if @Debug & 1 = 1 begin
	print	'II.	Set sequence on #eXpanded Routers...'
	select	@StartDT = GetDate ()
end--</Debug>
update
    xr
set 
    Sequence =
	(	select
			count(1)
		from
			#XRt xrC
		where
			xrC.TopPart = xr.TopPart
			and xrC.Hierarchy < xr.Hierarchy
	)
from
    #XRt xr

--<Debug>
if @Debug & 1 = 1 begin
	print	'...Sequence set.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end--</Debug>

--	III.	Write new #eXpanded Routers to permanent table.
if	objectproperty(object_id('FT.XRt_New'), 'IsTable') is not null begin
	drop table FT.XRt_New
end

create table FT.XRt_New
(	ID int not null IDENTITY(1, 1) primary key
,	TopPart varchar(25) null
,	ChildPart varchar(25) null
,	BOMID int null
,	Sequence smallint null
,	BOMLevel smallint not null default (0)
,	XQty float null default (1)
,	XScrap float null default (1)
,	XBufferTime float not null default (0)
,	XRunRate float not null default (0)
,	Substitute bit default(0)
,	Hierarchy varchar(500) null
,	Infinite smallint not null default (0)
,	unique
		(	TopPart
		,	Sequence
		)
)

--<Debug>
if @Debug & 1 = 1 begin
	print	'III.	Write new #eXpanded Routers to permanent table...'
	select	@StartDT = GetDate ()
end--</Debug>
--- <Insert rows="*">
set	@TableName = 'FT.XRt'

insert
	FT.XRt_New
(	TopPart
,   ChildPart
,   BOMID
,   Sequence
,   BOMLevel
,   XQty
,   XScrap
,   XBufferTime
,   XRunRate
,	Substitute
,   Hierarchy
,   Infinite
)
select
	xr.TopPart
,   xr.ChildPart
,   xr.BOMID
,   xr.Sequence
,   xr.BOMLevel
,   xr.XQty
,   xr.XScrap
,   xr.XBufferTime
,   xr.XRunRate
,	xr.Substitute
,   xr.Hierarchy
,   xr.Infinite
from
	#XRt xr
order by
	xr.TopPart
,	xr.Sequence
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
--<Debug>
if @Debug & 1 = 1 begin
	print	'...Written.   ' + Convert (varchar, DateDiff (ms, @StartDT, GetDate ())) + ' ms'
end--</Debug>
--<Debug>
if @Debug & 1 = 1 begin
	print	'Finished.   ' + Convert (varchar, DateDiff (ms, @TranDT, GetDate ())) + ' ms'
end--</Debug>

drop table #XRt

if	objectproperty(object_id('FT.XRt'), 'IsTable') is not null begin
	drop table FT.XRt
end

exec
	sp_rename 'FT.XRt_New', 'XRt'

/*	Index table.*/
create nonclustered index idx_XRt_1 on FT.XRt (BOMLevel, ChildPart, ID)
create nonclustered index idx_XRt_2 on FT.XRt (TopPart, Hierarchy, ID)
create nonclustered index idx_XRt_3 on FT.XRt (ChildPart, BOMLevel, ID)
create nonclustered index idx_XRt_4 on FT.XRt (ChildPart, TopPart, ID)
create nonclustered index idx_XRt_5 on FT.XRt (TopPart, ChildPart, XQty, ID)
create nonclustered index idx_XRt_6 on FT.XRt (TopPart, ChildPart, Sequence, XQty, XScrap, XBufferTime, ID)
--- </Body>

---	<CloseTran AutoCommit=Yes>
if	@TranCount = 0 begin
	commit tran @ProcName
end
---	</CloseTran AutoCommit=Yes>

---	<Return>
set	@Result = 0
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

begin transaction Test

delete
	xr
from
	FT.XRt xr

declare
	@ProcReturn integer
,	@TranDT datetime
,	@ProcResult integer
,	@Error integer

execute
	@ProcReturn = dbo.usp_Scheduling_BuildXRt
	@TranDT = @TranDT out
,	@Result = @ProcResult out
,	@Debug = 1

set	@Error = @@error

select
	@Error, @ProcReturn, @TranDT, @ProcResult
go

select
	*
from
	FT.XRt xr
where
	TopPart = '1217R20B'

--commit
if	@@trancount > 0 begin
	rollback
end
go

set statistics io off
set statistics time off
go

}

Results {
}
*/
GO
