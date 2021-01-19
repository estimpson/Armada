use SagePayroll_ARM
go
alter procedure dbo.ftsp_CheckSummary
	@CheckHeader char(33) = null
,	@BeginCheckDate datetime = null
,	@EndCheckDate datetime = null
,	@BeginEmployee char(12) = null
,	@EndEmployee char(12) = null
,	@Class1 char(6) = null
,	@TrialFlag int = 0
as
declare
	@transEmployee char(12) = left(@CheckHeader, 12)
,	@transPerEnd decimal(9,0) = convert(decimal(9,0), substring(@CheckHeader, 13, 9))
,	@transEntrySeq int = convert(int, right(@CheckHeader, 12))

select
	EMPLOYEE = max(chkH.EMPLOYEE)
,	FULLNAME = max(emp.FULLNAME)
,	SSN = 'XXX-XX-' + convert(char(4), max(right(rtrim(SSN),4)))
,	TRANSDATE = convert(datetime, left(max(convert(char(8),chkH.TRANSDATE)), 4) + '-' + substring(max(convert(char(8),chkH.TRANSDATE)),5,2) + '-' + right(max(convert(char(8),chkH.TRANSDATE)),2) )
,	TRANSNUM = max(case when chkH.CHECKSTAT = 3 then chkH.TRANSNUM end)
,	GrossHours = sum(case when chkD.CATEGORY = 2 then chkD.HOURS end)
,	GrossEarned = sum(case when chkD.CATEGORY = 2 then chkD.EEXTEND end)
,	TaxesWithHeld = sum(case when chkD.CATEGORY in (7,8) then chkD.EEXTEND end)
,	Deductions = coalesce(sum(case when chkD.CATEGORY = 4 then chkD.EEXTEND end), 0)
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
	join dbo.UPCHKD chkD
		on chkD.EMPLOYEE = chkH.EMPLOYEE
		and chkD.PEREND = chkH.PEREND
		and chkD.ENTRYSEQ = chkH.ENTRYSEQ
where
	chkH.EMPLOYEE = coalesce(@transEmployee, chkH.Employee)
	and chkH.PEREND = coalesce(@transPerEnd, chkH.PEREND)
	and chkH.ENTRYSEQ = coalesce(@transEntrySeq, chkH.ENTRYSEQ)
	and chkH.TRANSDATE between 
		coalesce(convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112)), chkH.TRANSDATE)
		and coalesce(convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112)), chkH.TRANSDATE)
	and chkH.EMPLOYEE between coalesce(@BeginEmployee, chkH.EMPLOYEE) and coalesce(@EndEmployee, chkH.EMPLOYEE)
	and chkH.CLASS1 = coalesce(@Class1, chkH.CLASS1)
	and chkD.CATEGORY in (2,4,7,8)
	and (	(@TrialFlag = 1 and chkH.PRPOSTSTAT = 1)
			or
			(@TrialFlag = 0 and chkH.PRPOSTSTAT = 2))
go

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = null
,	@EndEmployee = null

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@Class1 = 'OFFICE'

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = '30018'
,	@EndEmployee = '30018'
,	@Class1 = null


exec dbo.ftsp_CheckSummary
	@CheckHeader = '10771       20201107 595         '
,	@BeginCheckDate = null
,	@EndCheckDate = null
,	@BeginEmployee = null
,	@EndEmployee = null

exec dbo.ftsp_CheckSummary
	@CheckHeader = '20007       20201215 238         '
,	@TrialFlag = 1

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = '2020-12-16'
,	@EndCheckDate = '2020-12-16'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@Class1 = null
,	@TrialFlag = 1

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = null
,	@EndCheckDate = null
,	@BeginEmployee = '10002       '
,	@EndEmployee = '10002       '
,	@Class1 = 'PLANT'
,	@TrialFlag = 0

exec dbo.ftsp_CheckSummary
	@CheckHeader = null
,	@BeginCheckDate = '2021-01-06'
,	@EndCheckDate = '2021-01-06'
,	@BeginEmployee = '10018       '
,	@EndEmployee = '10018       '
,	@Class1 = 'PLANT'
,	@TrialFlag = 0
