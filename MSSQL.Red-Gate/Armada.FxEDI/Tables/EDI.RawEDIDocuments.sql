CREATE TABLE [EDI].[RawEDIDocuments]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[GUID] [uniqueidentifier] NOT NULL CONSTRAINT [DF__RawEDIDocu__GUID__0544AF38] DEFAULT (newid()),
[Status] [int] NOT NULL CONSTRAINT [DF__RawEDIDoc__Statu__0638D371] DEFAULT ((0)),
[FileName] [sys].[sysname] NOT NULL,
[HeaderData] [xml] NULL,
[RowTS] [timestamp] NOT NULL,
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__RawEDIDoc__RowCr__072CF7AA] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__RawEDIDoc__RowCr__08211BE3] DEFAULT (suser_name()),
[Data] [xml] NULL,
[TradingPartnerA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[TypeA] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[VersionA] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[EDIStandardA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ReleaseA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DocNumberA] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ControlNumberA] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[DeliveryScheduleA] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[MessageNumberA] [varchar] (8) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [EDI].[RawEDIDocuments] ADD CONSTRAINT [PK__RawEDIDo__3214EC270C11DE5D] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [ixRawEDIDocuments_1] ON [EDI].[RawEDIDocuments] ([Status], [EDIStandardA], [TypeA]) ON [PRIMARY]
GO
CREATE PRIMARY XML INDEX [PXML_EDIData]
ON [EDI].[RawEDIDocuments] ([Data])
GO
