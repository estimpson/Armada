CREATE TABLE [dbo].[MissingXRtBackflushDiscrepencies]
(
[BackflushNumber] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Status] [int] NOT NULL,
[Type] [int] NOT NULL,
[MachineCode] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[PartProduced] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[SerialProduced] [int] NOT NULL,
[QtyProduced] [numeric] (20, 6) NOT NULL,
[TranDT] [datetime] NOT NULL,
[RowID] [int] NOT NULL,
[RowCreateDT] [datetime] NULL,
[RowCreateUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[RowModifiedDT] [datetime] NULL,
[RowModifiedUser] [nvarchar] (128) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[Line] [float] NULL,
[bdStatus] [int] NULL,
[bdType] [int] NULL,
[ChildPartSequence] [int] NULL,
[ChildPartBOMLevel] [int] NULL,
[BillOfMaterialID] [int] NULL,
[PartConsumed] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[SerialConsumed] [int] NULL,
[QtyAvailable] [numeric] (20, 6) NULL,
[QtyRequired] [numeric] (20, 6) NULL,
[QtyIssue] [numeric] (20, 6) NULL,
[QtyOverage] [numeric] (20, 6) NULL,
[Notes] [varchar] (max) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
