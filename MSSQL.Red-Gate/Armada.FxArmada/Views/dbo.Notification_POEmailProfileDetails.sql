SET QUOTED_IDENTIFIER ON
GO
SET ANSI_NULLS ON
GO




CREATE view [dbo].[Notification_POEmailProfileDetails]
as
select
	PONumber = ph.po_number
,	VendorCode = ph.vendor_code
,	EmailTo = coalesce(nepPO.EmailTo, nepVendor.EmailTo)
,	PODefinedEmailTo = case when nepPO.EmailTo is not null then 1 else 0 end
,	VendorDefinedEmailTo = case when nepVendor.EmailTo is not null or nepPO.Emailto is not null then 1 else 0 end
,	EmailCC = coalesce(nepPO.EmailCC, nepVendor.EmailCC)
,	PODefinedEmailCC = case when nepPO.EmailCC is not null then 1 else 0 end
,	VendorDefinedEmailCC = case when nepVendor.EmailCC is not null or nepPO.EmailCC is not null then 1 else 0 end
,	EmailReplyTo = coalesce(nepPO.EmailReplyTo, nepVendor.EmailReplyTo)
,	PODefinedEmailReplyTo = case when nepPO.EmailReplyTo is not null then 1 else 0 end
,	VendorDefinedEmailReplyTo = case when nepVendor.EmailReplyTo is not null or nepPO.EmailReplyTo is not null then 1 else 0 end
,	EmailSubject = coalesce(nepPO.EmailSubject, nepVendor.EmailSubject)
,	PODefinedEmailSubject = case when nepPO.EmailSubject is not null then 1 else 0 end
,	VendorDefinedEmailSubject = case when nepVendor.EmailSubject is not null or nepPO.EmailSubject is not null then 1 else 0 end
,	EmailBody = coalesce(nepPO.EmailBody, nepVendor.EmailBody)
,	PODefinedEmailBody = case when nepPO.EmailBody is not null then 1 else 0 end
,	VendorDefinedEmailBody = case when nepVendor.EmailBody is not null or nepPO.EmailBody is not null then 1 else 0 end
,	EmailAttachmentNames = '\\AZTECDC02\EMailedPOs\' +Upper(ph.vendor_code) + '_'+Coalesce(nullif(ph.blanket_part, ''), 'NormalPO') +'_'+ convert(nvarchar, ph.po_number) + '_' + Convert(varchar(16), getdate(), 112)+ '.pdf'
,	PODefinedEmailAttachmentNames = 1
,	VendorDefinedEmailAttachmentNames = 1
,	EmailFrom = 'DoNotReply@aztecmfgcorp.com'
,	PODefinedEmailFrom = 1
,	VendorDefinedEmailFrom = 1
from
	dbo.po_header ph
	left join dbo.Notification_POEmailProfile npep
		join dbo.Notification_EmailProfiles nepPO
			on nepPO.RowID = npep.ProfileID
		on npep.PONumber = ph.po_number
	left join dbo.Notification_VendorEmailProfile nvep
		join dbo.Notification_EmailProfiles nepVendor
			on nepVendor.RowID = nvep.ProfileID
		on nvep.VendorCode = ph.vendor_code



GO
