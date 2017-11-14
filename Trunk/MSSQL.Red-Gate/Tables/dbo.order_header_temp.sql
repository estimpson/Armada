CREATE TABLE [dbo].[order_header_temp]
(
[order_no] [numeric] (8, 0) NOT NULL,
[customer] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_date] [datetime] NULL,
[contact] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[destination] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[model_year] [varchar] (4) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_part] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[box_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[pallet_label] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[standard_pack] [numeric] (20, 6) NULL,
[our_cum] [numeric] (20, 6) NULL,
[the_cum] [numeric] (20, 6) NULL,
[order_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[amount] [numeric] (20, 6) NULL,
[shipped] [numeric] (20, 6) NULL,
[deposit] [numeric] (20, 6) NULL,
[artificial_cum] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipper] [int] NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[location] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[revision] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[customer_po] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_qty] [numeric] (20, 6) NULL,
[price] [numeric] (20, 6) NULL,
[price_unit] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[salesman] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[zone_code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[term] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[dock_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[package_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[shipping_unit] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line_feed_code] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fab_cum] [numeric] (15, 2) NULL,
[raw_cum] [numeric] (15, 2) NULL,
[fab_date] [datetime] NULL,
[raw_date] [datetime] NULL,
[po_expiry_date] [datetime] NULL,
[begin_kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[end_kanban_number] [varchar] (6) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line11] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line12] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line13] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line14] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line15] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line16] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[line17] [varchar] (35) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom01] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom02] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[custom03] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[quote] [int] NULL,
[due_date] [datetime] NULL,
[engineering_level] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[alternate_price] [decimal] (20, 6) NULL,
[show_euro_amount] [smallint] NULL,
[cs_status] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[order_status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[order_header_temp] ADD CONSTRAINT [PK__order_header_temp__05CF8A74] PRIMARY KEY CLUSTERED  ([order_no]) ON [PRIMARY]
GO
