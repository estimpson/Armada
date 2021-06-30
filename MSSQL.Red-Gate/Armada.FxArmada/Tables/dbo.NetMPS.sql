CREATE TABLE [dbo].[NetMPS]
(
[Status] [int] NOT NULL CONSTRAINT [df_NetMPS_Status] DEFAULT ((0)),
[Type] [int] NOT NULL CONSTRAINT [df_NetMPS_Type] DEFAULT ((0)),
[OrderNo] [int] NOT NULL CONSTRAINT [df_NetMPS_OrderNo] DEFAULT ((-1)),
[LineID] [int] NOT NULL,
[Part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RequiredDT] [datetime] NOT NULL,
[GrossDemand] [numeric] (30, 12) NOT NULL,
[Balance] [numeric] (30, 12) NOT NULL,
[OnHandQty] [numeric] (30, 12) NOT NULL CONSTRAINT [df_NetMPS_OnHandQty] DEFAULT ((0)),
[InTransitQty] [numeric] (30, 12) NOT NULL CONSTRAINT [df_NetMPS_InTransitQty] DEFAULT ((0)),
[WIPQty] [numeric] (30, 12) NOT NULL CONSTRAINT [df_NetMPS_WIPQty] DEFAULT ((0)),
[LowLevel] [int] NOT NULL,
[Sequence] [int] NOT NULL,
[RowID] [int] NOT NULL IDENTITY(1, 1),
[RowCreateDT] [datetime] NULL CONSTRAINT [df_NetMPS_RowCreateDT] DEFAULT (getdate()),
[RowCreateUser] [sys].[sysname] NOT NULL CONSTRAINT [df_NetMPS_RowCreateUser] DEFAULT (suser_name()),
[RowModifiedDT] [datetime] NULL CONSTRAINT [df_NetMPS_RowModifiedDT] DEFAULT (getdate()),
[RowModifiedUser] [sys].[sysname] NOT NULL CONSTRAINT [df_NetMPS_RowModifiedUser] DEFAULT (suser_name())
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[NetMPS] ADD CONSTRAINT [pk_NetMPS] PRIMARY KEY CLUSTERED  ([RowID]) ON [PRIMARY]
GO
