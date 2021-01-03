declare
	@BeginCheckDate datetime = '2020-11-11'
,	@EndCheckDate datetime = '2020-11-11'


select
	chkH.EMPLOYEE
,	chkH.PEREND
,	chkH.ENTRYSEQ
,	chkH.TRANSDATE
,	chkH.TRANSNUM
,	chkH.TRANSAMT
,	emp.FULLNAME
,	SSN = 'XXX-XX-' + right(rtrim(emp.SSN), 4)
,	emp.CLASS1
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
where
	chkH.TRANSDATE between 
		convert(decimal(8, 0), convert(char(8), coalesce(@BeginCheckDate, chkH.TRANSDATE), 112))
		and convert(decimal(8, 0), convert(char(8), coalesce(@EndCheckDate, chkH.TRANSDATE), 112))
order by
	chkH.CLASS1
,	emp.FULLNAME


select
	chkD.EARNDED
,	SHORTDESC = ed.SHORTDESC
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
	chkH.TRANSDATE between 
		convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112))
		and convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112))
	and chkD.CATEGORY = 2
group by
	chkD.EARNDED
,	ed.SHORTDESC

select
	chkD.EARNDED
,	SHORTDESC = ed.SHORTDESC
,	EEXTEND = sum(chkD.EEXTEND)
,	SubGroup = case when chkD.EARNDED like 'TA%' then 0 when chkD.EARNDED like 'PT%' then 1 when chkD.EARNDED like 'HS%' then 2 else 3 end
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
	chkH.TRANSDATE between 
		convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112))
		and convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112))
	and chkD.CATEGORY = 4
group by
	chkD.EARNDED
,	ed.SHORTDESC

select
	chkD.EARNDED
,	SHORTDESC = edTax.SHORTDESC
,	EEXTEND = sum(chkD.EEXTEND)
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
	join dbo.UPCHKD chkD
		on chkD.EMPLOYEE = chkH.EMPLOYEE
		and chkD.PEREND = chkH.PEREND
		and chkD.ENTRYSEQ = chkH.ENTRYSEQ
	join dbo.UPTXMS edTax
		on edTax.TAXID = chkD.EARNDED
where
	chkH.TRANSDATE between 
		convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112))
		and convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112))
	and chkD.CATEGORY in (7,8)
group by
	chkD.CATEGORY
,	chkD.EARNDED
,	edTax.SHORTDESC
order by
	chkD.CATEGORY
,	chkD.EARNDED

select
	chkH.EMPLOYEE
,	chkH.PEREND
,	chkH.ENTRYSEQ
,	chkH.TRANSDATE
,	chkH.TRANSNUM
,	chkH.TRANSAMT
,	emp.FULLNAME
,	SSN = 'XXX-XX-' + right(rtrim(emp.SSN), 4)
,	emp.CLASS1
,	chkD.CATEGORY
,	chkD.EARNDED
,	chkD.LINETYPE
,	chkD.[LINENO]
,	SHORTDESC = coalesce(ed.SHORTDESC, edTax.SHORTDESC)
,	chkD.HOURS
,	chkD.ERATE
,	chkD.EEXTEND
,	chkD.PLINETYPE
from
	dbo.UPCHKH chkH
	join dbo.UPEMPL emp
		on emp.EMPLOYEE = chkH.EMPLOYEE
	join dbo.UPCHKD chkD
		on chkD.EMPLOYEE = chkH.EMPLOYEE
		and chkD.PEREND = chkH.PEREND
		and chkD.ENTRYSEQ = chkH.ENTRYSEQ
	left join dbo.UPDTLM ed
		on ed.EARNDED = chkD.EARNDED
	left join dbo.UPTXMS edTax
		on edTax.TAXID = chkD.EARNDED
where
	chkH.TRANSDATE between 
		convert(decimal(8, 0), convert(char(8), @BeginCheckDate, 112))
		and convert(decimal(8, 0), convert(char(8), @EndCheckDate, 112))