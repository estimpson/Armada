CREATE TABLE [dbo].[CurrentCums]
(
[Orderno] [int] NOT NULL,
[Customer] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Destination] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[BlanketPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[CustomerPart] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[OurCum] [int] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[CurrentCums] ADD CONSTRAINT [PK__CurrentC__C39F584C0C0E21B3] PRIMARY KEY CLUSTERED  ([Orderno]) ON [PRIMARY]
GO
