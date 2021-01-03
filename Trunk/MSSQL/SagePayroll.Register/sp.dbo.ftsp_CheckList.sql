alter procedure dbo.ftsp_CheckList
	@TransNumber decimal(9,0) = null
,	@BeginCheckDate datetime = null
,	@EndCheckDate datetime = null
,	@BeginEmployee char(12) = null
,	@EndEmployee char(12) = null
,	@Class1 char(6) = null
,	@TrialFlag int = 0
as
select
	chkH.CLASS1
,	chkH.TRANSNUM
,	CheckHeader = chkH.EMPLOYEE + convert(char(9), chkH.PEREND) + convert(char(12), chkH.ENTRYSEQ)
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
where
	chkH.CLASS1 = coalesce(@Class1, chkH.CLASS1)
	and chkH.TRANSNUM = coalesce(@TransNumber, chkH.TRANSNUM)
	and chkH.TRANSDATE between 
		coalesce(convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112)), chkH.TRANSDATE)
		and coalesce(convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112)), chkH.TRANSDATE)
	and chkH.EMPLOYEE between coalesce(@BeginEmployee, chkH.EMPLOYEE) and coalesce(@EndEmployee, chkH.EMPLOYEE)
	and (	(@TrialFlag = 1 and chkH.PRPOSTSTAT = 1)
			or
			(@TrialFlag = 0 and chkH.PRPOSTSTAT = 2))
order by
	chkH.CLASS1
,	emp.FULLNAME
go

exec dbo.ftsp_CheckList
	@TransNumber = null
,	@BeginCheckDate = '2020-11-11'
,	@EndCheckDate = '2020-11-11'
,	@BeginEmployee = null
,	@EndEmployee = null

exec dbo.ftsp_CheckList
	@TransNumber = null
,	@BeginCheckDate = '2020-11-12'
,	@EndCheckDate = null
,	@BeginEmployee = null
,	@EndEmployee = null
,	@Class1 = 'OFFICE'

exec dbo.ftsp_CheckList
	@TransNumber = null
,	@BeginCheckDate = '2020-12-16'
,	@EndCheckDate = '2020-12-16'
,	@BeginEmployee = null
,	@EndEmployee = null
,	@TrialFlag = 1


exec dbo.ftsp_CheckList
	@TransNumber = null
,	@BeginCheckDate = null
,	@EndCheckDate = null
,	@BeginEmployee = '10001       '
,	@EndEmployee = '10001       '
,	@TrialFlag = 0