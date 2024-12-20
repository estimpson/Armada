CREATE TABLE [dbo].[sales_analyses]
(
[sales_analysis] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[sales_analysis_description] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[sales_analyses] ADD CONSTRAINT [pk_sales_analyses] PRIMARY KEY CLUSTERED  ([sales_analysis]) ON [PRIMARY]
GO
