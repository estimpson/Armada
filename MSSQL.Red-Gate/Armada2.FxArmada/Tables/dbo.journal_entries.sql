CREATE TABLE [dbo].[journal_entries]
(
[fiscal_year] [varchar] (5) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ledger] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[gl_entry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[period] [smallint] NULL,
[balance_name] [varchar] (40) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[je_description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[entry_date] [datetime] NULL,
[entry_type] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[je_committed] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[related_gl_entry] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_date] [datetime] NULL,
[document_amount] [decimal] (18, 6) NULL,
[ledger_amount] [decimal] (18, 6) NULL,
[status] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[approved] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[batch] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[transaction_type] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[document_source] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[created_by] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[journal_entries] ADD CONSTRAINT [pk_journal_entries] PRIMARY KEY CLUSTERED  ([fiscal_year], [ledger], [gl_entry]) ON [PRIMARY]
GO
