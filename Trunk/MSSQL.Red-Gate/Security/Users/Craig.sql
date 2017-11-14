IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Craig')
CREATE LOGIN [Craig] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Craig] FOR LOGIN [Craig]
GO
