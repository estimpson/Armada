CREATE TABLE [FT].[XRt]
(
[ID] [int] NOT NULL IDENTITY(1, 1),
[TopPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ChildPart] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BOMID] [int] NULL,
[Sequence] [smallint] NULL,
[BOMLevel] [smallint] NOT NULL CONSTRAINT [DF__XRt_New__BOMLeve__36F53326] DEFAULT ((0)),
[XQty] [float] NULL CONSTRAINT [DF__XRt_New__XQty__37E9575F] DEFAULT ((1)),
[XScrap] [float] NULL CONSTRAINT [DF__XRt_New__XScrap__38DD7B98] DEFAULT ((1)),
[XBufferTime] [float] NOT NULL CONSTRAINT [DF__XRt_New__XBuffer__39D19FD1] DEFAULT ((0)),
[XRunRate] [float] NOT NULL CONSTRAINT [DF__XRt_New__XRunRat__3AC5C40A] DEFAULT ((0)),
[Substitute] [bit] NULL CONSTRAINT [DF__XRt_New__Substit__3BB9E843] DEFAULT ((0)),
[Hierarchy] [varchar] (500) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Infinite] [smallint] NOT NULL CONSTRAINT [DF__XRt_New__Infinit__3CAE0C7C] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[XRt] ADD CONSTRAINT [PK__XRt_New__3214EC27965578D7] PRIMARY KEY CLUSTERED  ([ID]) ON [PRIMARY]
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
ALTER TABLE [FT].[XRt] ADD CONSTRAINT [UQ__XRt_New__1FDC25FCFE171615] UNIQUE NONCLUSTERED  ([TopPart], [Sequence]) ON [PRIMARY]
GO
