IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Jay')
CREATE LOGIN [Jay] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Jay] FOR LOGIN [Jay]
GO
