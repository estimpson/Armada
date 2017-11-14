IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Andre')
CREATE LOGIN [Andre] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Andre] FOR LOGIN [Andre]
GO
