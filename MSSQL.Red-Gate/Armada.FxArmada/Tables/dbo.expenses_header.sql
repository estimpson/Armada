CREATE TABLE [dbo].[expenses_header]
(
[expense_report] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[vendor] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expense_report_date] [datetime] NULL,
[reason] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[buy_unit] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_unit] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[gl_date] [datetime] NULL,
[period] [smallint] NULL,
[gl_entry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[batch] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[email_notification] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[invoice_cm] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_cm_date] [datetime] NULL,
[pay_vendor] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[received_date] [datetime] NULL,
[due_date] [datetime] NULL,
[discount_date] [datetime] NULL,
[inv_cm_gl_date] [datetime] NULL,
[inv_cm_period] [smallint] NULL,
[inv_cm_fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[terms] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_cm_batch] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[purchase_order] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[approver] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[approved] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[bank_alias] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_class] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ledger_account_code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[discount_ledger_account_code] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_cm_gl_entry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[hold_inv_cm] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[separate_check] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[direct_deposit] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[check_message] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[intercompany] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_cm_ledger] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_vendor_name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_vendor_name_2] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_address_1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_address_2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_address_3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_city] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_state] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_postal_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pay_country] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[inv_cm_flag] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[expense_amount] [decimal] (18, 6) NULL,
[reimbursed_amount] [decimal] (18, 6) NULL,
[created_by] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[expenses_header] ADD CONSTRAINT [pk_expenses_header] PRIMARY KEY CLUSTERED  ([expense_report]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [expenses_header_invoice] ON [dbo].[expenses_header] ([vendor], [invoice_cm], [inv_cm_flag]) ON [PRIMARY]
GO
