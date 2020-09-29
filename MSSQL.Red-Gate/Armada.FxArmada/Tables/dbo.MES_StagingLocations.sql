CREATE TABLE [dbo].[MES_StagingLocations]
(
[StagingLocationCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MachineCode] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[PartCode] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [int] NOT NULL CONSTRAINT [DF__MES_Stagi__Statu__3B721077] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__MES_Stagin__Type__3C6634B0] DEFAULT ((0)),
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__MES_Stagi__RowCr__3D5A58E9] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__MES_Stagi__RowCr__3E4E7D22] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__MES_Stagi__RowMo__3F42A15B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__MES_Stagi__RowMo__4036C594] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_StagingLocations] ADD CONSTRAINT [PK__MES_Stag__FFEE74516200F867] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_StagingLocations] ADD CONSTRAINT [UQ__MES_Stag__077E763913F8AC6A] UNIQUE NONCLUSTERED  ([StagingLocationCode], [MachineCode], [PartCode]) ON [PRIMARY]
GO
ALTER TABLE [dbo].[MES_StagingLocations] ADD CONSTRAINT [FK__MES_Stagi__Machi__3989C805] FOREIGN KEY ([MachineCode]) REFERENCES [dbo].[machine] ([machine_no])
GO
ALTER TABLE [dbo].[MES_StagingLocations] ADD CONSTRAINT [FK__MES_Stagi__PartC__3A7DEC3E] FOREIGN KEY ([PartCode]) REFERENCES [dbo].[part] ([part])
GO
ALTER TABLE [dbo].[MES_StagingLocations] ADD CONSTRAINT [FK__MES_Stagi__Stagi__3895A3CC] FOREIGN KEY ([StagingLocationCode]) REFERENCES [dbo].[location] ([code])
GO
