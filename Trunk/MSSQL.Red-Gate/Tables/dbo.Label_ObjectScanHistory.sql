CREATE TABLE [dbo].[Label_ObjectScanHistory]
(
[Serial] [int] NOT NULL,
[LabelDataChecksum] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__Label_Obj__RowCr__430D3B1B] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Label_Obj__RowCr__44015F54] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__Label_Obj__RowMo__44F5838D] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__Label_Obj__RowMo__45E9A7C6] DEFAULT (suser_name()),
[LabelDataXML] [xml] NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO
ALTER TABLE [dbo].[Label_ObjectScanHistory] ADD CONSTRAINT [PK__Label_Ob__FFEE7451953C34D2] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
