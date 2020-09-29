CREATE TABLE [dbo].[PrintQueue_Object]
(
[ID] [int] NOT NULL,
[PrintQueueName] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[Status] [smallint] NULL,
[Serial] [int] NULL,
[LabelFormat] [varchar] (50) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
