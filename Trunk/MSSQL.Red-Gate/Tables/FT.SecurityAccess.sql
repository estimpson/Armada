CREATE TABLE [FT].[SecurityAccess]
(
[SecurityID] [uniqueidentifier] NOT NULL,
[ResourceID] [uniqueidentifier] NOT NULL,
[Status] [int] NULL CONSTRAINT [DF__SecurityA__Statu__02932B16] DEFAULT ((0)),
[Type] [int] NULL CONSTRAINT [DF__SecurityAc__Type__03874F4F] DEFAULT ((0))
) ON [PRIMARY]
GO
ALTER TABLE [FT].[SecurityAccess] ADD CONSTRAINT [PK__Security__7B66114400AAE2A4] PRIMARY KEY CLUSTERED  ([SecurityID], [ResourceID]) ON [PRIMARY]
GO
