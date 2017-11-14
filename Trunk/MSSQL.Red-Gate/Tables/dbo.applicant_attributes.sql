CREATE TABLE [dbo].[applicant_attributes]
(
[applicant] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[text_1] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_2] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_3] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_4] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_5] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_6] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_7] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_8] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_9] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_10] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_11] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_12] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_13] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_14] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_15] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_16] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_17] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_18] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_19] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[text_20] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[integer_1] [int] NULL,
[integer_2] [int] NULL,
[integer_3] [int] NULL,
[integer_4] [int] NULL,
[integer_5] [int] NULL,
[decimal_1] [decimal] (18, 6) NULL,
[decimal_2] [decimal] (18, 6) NULL,
[decimal_3] [decimal] (18, 6) NULL,
[decimal_4] [decimal] (18, 6) NULL,
[decimal_5] [decimal] (18, 6) NULL,
[date_1] [datetime] NULL,
[date_2] [datetime] NULL,
[date_3] [datetime] NULL,
[date_4] [datetime] NULL,
[date_5] [datetime] NULL,
[date_6] [datetime] NULL,
[date_7] [datetime] NULL,
[date_8] [datetime] NULL,
[date_9] [datetime] NULL,
[date_10] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[changed_date] [datetime] NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[applicant_attributes] ADD CONSTRAINT [pk_applicant_attributes] PRIMARY KEY CLUSTERED  ([applicant]) ON [PRIMARY]
GO
