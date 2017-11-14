IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Larry')
CREATE LOGIN [Larry] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Larry] FOR LOGIN [Larry]
GO
