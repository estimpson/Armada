CREATE TABLE [FT].[XRt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TopPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOMID] [int] NULL,
[Sequence] [smallint] NULL,
[BOMLevel] [smallint] NOT NULL CONSTRAINT [DF__XRt_New__BOMLeve__63C9C752] DEFAULT ((0)),
[XQty] [float] NULL CONSTRAINT [DF__XRt_New__XQty__64BDEB8B] DEFAULT ((1)),
[XScrap] [float] NULL CONSTRAINT [DF__XRt_New__XScrap__65B20FC4] DEFAULT ((1)),
[XBufferTime] [float] NOT NULL CONSTRAINT [DF__XRt_New__XBuffer__66A633FD] DEFAULT ((0)),
[XRunRate] [float] NOT NULL CONSTRAINT [DF__XRt_New__XRunRat__679A5836] DEFAULT ((0)),
[Substitute] [bit] NULL CONSTRAINT [DF__XRt_New__Substit__688E7C6F] DEFAULT ((0)),
[Hierarchy] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Infinite] [smallint] NOT NULL CONSTRAINT [DF__XRt_New__Infinit__6982A0A8] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[XRt] ADD CONSTRAINT [PK__XRt_New__3214EC2761C01BD5] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_1] ON [FT].[XRt] ([BOMLevel], [ChildPart], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_3] ON [FT].[XRt] ([ChildPart], [BOMLevel], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_4] ON [FT].[XRt] ([ChildPart], [TopPart], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_6] ON [FT].[XRt] ([TopPart], [ChildPart], [Sequence], [XQty], [XScrap], [XBufferTime], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_5] ON [FT].[XRt] ([TopPart], [ChildPart], [XQty], [ID]) ON [PRIMARY]
GO
CREATE NONCLUSTERED INDEX [idx_XRt_2] ON [FT].[XRt] ([TopPart], [Hierarchy], [ID]) ON [PRIMARY]
GO
ALTER TABLE [FT].[XRt] ADD CONSTRAINT [UQ__XRt_New__1FDC25FCA73D674A] UNIQUE NONCLUSTERED  ([TopPart], [Sequence]) ON [PRIMARY]
GO
