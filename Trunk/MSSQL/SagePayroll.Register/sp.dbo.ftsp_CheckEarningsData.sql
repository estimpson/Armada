alter procedure dbo.ftsp_CheckEarningsData
	@CheckHeader char(33) = null
,	@BeginCheckDate datetime = null
,	@EndCheckDate datetime = null
,	@BeginEmployee char(12) = null
,	@EndEmployee char(12) = null
,	@Class1 char(6) = null
,	@IncludeZerosFlag int = 0
,	@TrialFlag int = 0
as
declare
	@transEmployee char(12) = left(@CheckHeader, 12)
,	@transPerEnd decimal(9,0) = convert(decimal(9,0), substring(@CheckHeader, 13, 9))
,	@transEntrySeq int = convert(int, right(@CheckHeader, 12))

select
	chkD.EARNDED
,	SHORTDESC = case when chkD.EARNDED = 'S100' then rtrim(ed.SHORTDESC) + ' (' + rtrim(emp.CLASS1) + ')' else ed.SHORTDESC end
,	HOURS = sum(chkD.HOURS)
,	EEXTEND = sum(chkD.EEXTEND)
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
	join dbo.UPCHKD chkD
		on chkD.EMPLOYEE = chkH.EMPLOYEE
		and chkD.PEREND = chkH.PEREND
		and chkD.ENTRYSEQ = chkH.ENTRYSEQ
	join dbo.UPDTLM ed
		on ed.EARNDED = chkD.EARNDED
where
	chkH.EMPLOYEE = coalesce(@transEmployee, chkH.Employee)
	and chkH.PEREND = coalesce(@transPerEnd, chkH.PEREND)
	and chkH.ENTRYSEQ = coalesce(@transEntrySeq, chkH.ENTRYSEQ)
	and chkH.TRANSDATE between 
		coalesce(convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112)), chkH.TRANSDATE)
		and coalesce(convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112)), chkH.TRANSDATE)
	and chkH.EMPLOYEE between coalesce(@BeginEmployee, chkH.EMPLOYEE) and coalesce(@EndEmployee, chkH.EMPLOYEE)
	and chkH.CLASS1 = coalesce(@Class1, chkH.CLASS1)
	and chkD.CATEGORY = 2
	and (	(@TrialFlag = 1 and chkH.PRPOSTSTAT = 1)
			or
			(@TrialFlag = 0 and chkH.PRPOSTSTAT = 2))
group by
	chkD.EARNDED
,	ed.SHORTDESC
,	case when chkD.EARNDED = 'S100' then rtrim(ed.SHORTDESC) + ' (' + rtrim(emp.CLASS1) + ')' else ed.SHORTDESC end
having
	(@includeZerosFlag = 1 or sum(chkD.EEXTEND) <> 0)
order by
	chkD.EARNDED
go

exec dbo.ftsp_CheckEarningsData
	@CheckHeader = null
,	@BeginCheckDate = '2020-12-16'
,	@EndCheckDate = '2020-12-16'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@IncludeZerosFlag = 1
,	@TrialFlag = 1

exec dbo.ftsp_CheckEarningsData
	@CheckHeader = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@IncludeZerosFlag = 0

exec dbo.ftsp_CheckEarningsData
	@CheckHeader = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@Class1 = 'OFFICE'
,	@IncludeZerosFlag = 0

exec dbo.ftsp_CheckEarningsData
	@CheckHeader = '10771       20201107 595         '
,	@BeginCheckDate = null
,	@EndCheckDate = null
,	@BeginEmployee = null
,	@EndEmployee = null
,	@IncludeZerosFlag = 0
,	@TrialFlag = 0

exec dbo.ftsp_CheckEarningsData
	@CheckHeader = '20007       20201215 238         '
,	@BeginCheckDate = null
,	@EndCheckDate = null
,	@BeginEmployee = null
,	@EndEmployee = null
,	@IncludeZerosFlag = 0
,	@TrialFlag = 1
