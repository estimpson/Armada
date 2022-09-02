CREATE TABLE [dbo].[destination_message_file]
(
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[message1] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message10] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message2] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message3] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message4] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message5] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message6] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message7] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message8] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[message9] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[destination_message_file] ADD CONSTRAINT [PK__destinat__9CEEF12CEB9BDC16] PRIMARY KEY CLUSTERED  ([destination]) ON [PRIMARY]
GO
