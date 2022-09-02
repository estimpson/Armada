CREATE TABLE [FT].[MenuStructurebak]
(
[ParentMenuID] [uniqueidentifier] NOT NULL,
[ChildMenuID] [uniqueidentifier] NOT NULL,
[Sequence] [float] NULL
) ON [PRIMARY]
GO
ALTER TABLE [FT].[MenuStructurebak] ADD CONSTRAINT [PK__MenuStrubak__ECE174455832119F] PRIMARY KEY CLUSTERED  ([ParentMenuID], [ChildMenuID]) ON [PRIMARY]
GO
