CREATE TABLE [dbo].[NetMPS]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Statu__13F70CCD] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NetMPS_New__Type__14EB3106] DEFAULT ((0)),
[OrderNo] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Order__15DF553F] DEFAULT ((-1)),
[LineID] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredDT] [datetime] NOT NULL,
[GrossDemand] [numeric] (30, 12) NOT NULL,
[Balance] [numeric] (30, 12) NOT NULL,
[OnHandQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__OnHan__16D37978] DEFAULT ((0)),
[InTransitQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__InTra__17C79DB1] DEFAULT ((0)),
[WIPQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__WIPQt__18BBC1EA] DEFAULT ((0)),
[LowLevel] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__19AFE623] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__1AA40A5C] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__1B982E95] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__1C8C52CE] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NetMPS] ADD CONSTRAINT [PK__NetMPS_N__FFEE745157D4AB2E] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
