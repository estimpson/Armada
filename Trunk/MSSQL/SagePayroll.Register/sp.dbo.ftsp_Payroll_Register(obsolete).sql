alter procedure dbo.ftsp_Payroll_Register
as
select
	chkH.EMPLOYEE, chkH.PEREND, chkH.ENTRYSEQ, chkH.TRANSDATE, chkH.TRANSNUM, chkH.TRANSAMT, emp.FULLNAME, SSN = 'XXX-XX-' + right(rtrim(SSN),4), emp.CLASS1, chkD.CATEGORY, chkD.EARNDED, chkD.LINETYPE, chkD.[LINENO], SHORTDESC = coalesce(ed.SHORTDESC, edTax.SHORTDESC), chkD.HOURS, chkD.ERATE, chkD.EEXTEND, chkD.PLINETYPE
from
	UPCHKH chkH
	join UPCHKD chkD on chkD.EMPLOYEE = chkH.EMPLOYEE and chkD.PEREND = chkH.PEREND and chkD.ENTRYSEQ = chkh.ENTRYSEQ
	join UPEMPL emp on emp.EMPLOYEE = chkD.EMPLOYEE
	left join UPDTLM ed on ed.EARNDED = chkD.EARNDED
	left join UPTXMS edTax on edTax.TAXID = chkD.EARNDED
go

