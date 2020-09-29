CREATE TABLE [dbo].[States]
(
[StateCode] [char] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[StateName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[States] ADD CONSTRAINT [PK__States__D515E98BB3D8454F] PRIMARY KEY CLUSTERED  ([StateCode]) ON [PRIMARY]
GO
