CREATE TABLE [dbo].[NetMPS]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Statu__6C5F0D53] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NetMPS_New__Type__6D53318C] DEFAULT ((0)),
[OrderNo] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Order__6E4755C5] DEFAULT ((-1)),
[LineID] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredDT] [datetime] NOT NULL,
[GrossDemand] [numeric] (30, 12) NOT NULL,
[Balance] [numeric] (30, 12) NOT NULL,
[OnHandQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__OnHan__6F3B79FE] DEFAULT ((0)),
[InTransitQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__InTra__702F9E37] DEFAULT ((0)),
[WIPQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__WIPQt__7123C270] DEFAULT ((0)),
[LowLevel] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__7217E6A9] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__730C0AE2] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__74002F1B] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__74F45354] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NetMPS] ADD CONSTRAINT [PK__NetMPS_N__FFEE7451AE02A8C8] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
