IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ups')
CREATE LOGIN [ups] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [ups] FOR LOGIN [ups]
GO
