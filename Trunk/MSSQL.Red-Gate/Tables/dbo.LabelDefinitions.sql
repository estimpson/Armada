CREATE TABLE [dbo].[LabelDefinitions]
(
[LabelName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PrinterType] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[ProcedureName] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[LabelCode] [varchar] (8000) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[LabelDefinitions] ADD CONSTRAINT [PK__LabelDef__1E951820540C7B00] PRIMARY KEY CLUSTERED  ([LabelName], [PrinterType]) ON [PRIMARY]
GO
