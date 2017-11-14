CREATE TABLE [dbo].[NetMPS]
(
[Status] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Statu__3F8A7927] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [DF__NetMPS_New__Type__407E9D60] DEFAULT ((0)),
[OrderNo] [int] NOT NULL CONSTRAINT [DF__NetMPS_Ne__Order__4172C199] DEFAULT ((-1)),
[LineID] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredDT] [datetime] NOT NULL,
[GrossDemand] [numeric] (30, 12) NOT NULL,
[Balance] [numeric] (30, 12) NOT NULL,
[OnHandQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__OnHan__4266E5D2] DEFAULT ((0)),
[InTransitQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__InTra__435B0A0B] DEFAULT ((0)),
[WIPQty] [numeric] (30, 12) NOT NULL CONSTRAINT [DF__NetMPS_Ne__WIPQt__444F2E44] DEFAULT ((0)),
[LowLevel] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__4543527D] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowCr__463776B6] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__472B9AEF] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [DF__NetMPS_Ne__RowMo__481FBF28] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NetMPS] ADD CONSTRAINT [PK__NetMPS_N__FFEE7451763B23DD] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
