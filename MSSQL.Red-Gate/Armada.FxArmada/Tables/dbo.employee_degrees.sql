CREATE TABLE [dbo].[employee_degrees]
(
[employee] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[entry_date] [datetime] NOT NULL,
[degree] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[institution] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[area_of_study] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[date_graduated] [datetime] NULL,
[degree_comment] [text] COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[degree_identity] [int] NOT NULL IDENTITY(1, 1),
[highest_degree] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[employee_degrees] ADD CONSTRAINT [pk_employee_degrees] PRIMARY KEY CLUSTERED  ([employee], [entry_date], [degree_identity]) ON [PRIMARY]
GO
