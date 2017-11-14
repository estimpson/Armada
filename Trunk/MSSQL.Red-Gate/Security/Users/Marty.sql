IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Marty')
CREATE LOGIN [Marty] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Marty] FOR LOGIN [Marty]
GO
