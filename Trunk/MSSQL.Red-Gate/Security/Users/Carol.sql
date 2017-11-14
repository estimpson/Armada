IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Carol')
CREATE LOGIN [Carol] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Carol] FOR LOGIN [Carol]
GO
