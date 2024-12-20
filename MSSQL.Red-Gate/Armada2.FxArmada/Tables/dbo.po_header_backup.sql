CREATE TABLE [dbo].[po_header_backup]
(
[po_number] [int] NOT NULL,
[vendor_code] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NOT NULL,
[po_date] [datetime] NULL,
[date_due] [datetime] NULL,
[terms] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[fob] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_via] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_to_destination] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[status] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[type] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[description] [varchar] (100) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[plant] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[freight_type] [varchar] (20) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[buyer] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[printed] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[notes] [varchar] (255) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[total_amount] [numeric] (20, 6) NULL,
[shipping_fee] [numeric] (20, 6) NULL,
[sales_tax] [numeric] (20, 6) NULL,
[blanket_orderded_qty] [numeric] (20, 6) NULL,
[blanket_frequency] [varchar] (15) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_duration] [numeric] (5, 0) NULL,
[blanket_qty_per_release] [numeric] (20, 6) NULL,
[blanket_part] [varchar] (25) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[blanket_vendor_part] [varchar] (30) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[price] [numeric] (20, 6) NULL,
[std_unit] [varchar] (2) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[ship_type] [varchar] (10) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[flag] [int] NULL,
[release_no] [int] NULL,
[release_control] [char] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[tax_rate] [numeric] (4, 2) NULL,
[scheduled_time] [datetime] NULL,
[trusted] [varchar] (1) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[currency_unit] [varchar] (3) COLLATE SQL_Latin1_General_CP1_CI_AS NULL,
[show_euro_amount] [smallint] NULL,
[next_seqno] [int] NULL
) ON [PRIMARY]
GO
