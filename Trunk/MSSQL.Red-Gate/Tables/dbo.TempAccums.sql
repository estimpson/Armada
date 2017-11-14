CREATE TABLE [dbo].[TempAccums]
(
[OrderNo] [int] NOT NULL,
[Accum] [numeric] (20, 6) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[TempAccums] ADD CONSTRAINT [PK__TempAccu__C3907C74B5D03C53] PRIMARY KEY CLUSTERED  ([OrderNo]) ON [PRIMARY]
GO
