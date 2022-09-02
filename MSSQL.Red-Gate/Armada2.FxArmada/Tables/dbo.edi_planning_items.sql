CREATE TABLE [dbo].[edi_planning_items]
(
[sales_order] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[so_release] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[line_no] [int] NOT NULL,
[req_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduled_date] [datetime] NULL,
[scheduled_qty] [numeric] (18, 6) NULL,
[changed_date] [datetime] NULL,
[changed_user_id] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[scheduled_net_qty] [numeric] (18, 6) NULL,
[item] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[edi_planning_items] ADD CONSTRAINT [pk_edi_planning_items] PRIMARY KEY CLUSTERED  ([sales_order], [so_release], [item], [line_no]) ON [PRIMARY]
GO
