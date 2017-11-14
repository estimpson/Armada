IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Sharon')
CREATE LOGIN [Sharon] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Sharon] FOR LOGIN [Sharon]
GO
