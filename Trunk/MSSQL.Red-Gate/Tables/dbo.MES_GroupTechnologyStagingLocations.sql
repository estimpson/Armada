CREATE TABLE [dbo].[MES_GroupTechnologyStagingLocations]
(
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Machine] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__MES_Group__Statu__784B7224] DEFAULT ((0)),
[StagingLocation] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__MES_Group__RowCr__7A33BA96] DEFAULT (getdate()),
[RowCreateUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__MES_Group__RowCr__7B27DECF] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__MES_Group__RowMo__7C1C0308] DEFAULT (getdate()),
[RowModifiedUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL CONSTRAINT [DF__MES_Group__RowMo__7D102741] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [PK__MES_Grou__FFEE745169092E94] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [UQ__MES_Grou__4AD4603C719E7495] UNIQUE NONCLUSTERED  ([Machine]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [UQ__MES_Grou__A15FB695747AE140] UNIQUE NONCLUSTERED  ([Part]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [UQ__MES_Grou__65F2F0966BE59B3F] UNIQUE NONCLUSTERED  ([Part], [Machine]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [UQ__MES_Grou__5F4177656EC207EA] UNIQUE NONCLUSTERED  ([StagingLocation]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [FK__MES_Group__Machi__77574DEB] FOREIGN KEY ([Machine]) REFERENCES [dbo].[machine] ([machine_no])
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [FK__MES_Group__Stagi__793F965D] FOREIGN KEY ([StagingLocation]) REFERENCES [dbo].[location] ([code])
GO
ALTER TABLE [dbo].[MES_GroupTechnologyStagingLocations] ADD CONSTRAINT [FK__MES_GroupT__Part__766329B2] FOREIGN KEY ([Part]) REFERENCES [dbo].[part] ([part])
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__4AD4603C719E7495'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'307207631', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__4AD4603C719E7495'
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__5F4177656EC207EA'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'1698850539', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__5F4177656EC207EA'
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__65F2F0966BE59B3F'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'1966466635', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__65F2F0966BE59B3F'
GO
EXEC sp_addextendedproperty N'SVN_Revision', N'$Rev$', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__A15FB695747AE140'
GO
EXEC sp_addextendedproperty N'T_Checksum', N'1077948288', 'SCHEMA', N'dbo', 'TABLE', N'MES_GroupTechnologyStagingLocations', 'CONSTRAINT', N'UQ__MES_Grou__A15FB695747AE140'
GO
