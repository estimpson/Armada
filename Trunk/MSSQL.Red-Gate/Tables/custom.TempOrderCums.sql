CREATE TABLE [custom].[TempOrderCums]
(
[orderno] [int] NOT NULL,
[ourcum] [decimal] (16, 8) NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [custom].[TempOrderCums] ADD CONSTRAINT [key_primary_orderCums] PRIMARY KEY CLUSTERED  ([orderno]) ON [PRIMARY]
GO
