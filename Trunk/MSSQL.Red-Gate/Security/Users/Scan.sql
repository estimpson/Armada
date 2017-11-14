IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Scan')
CREATE LOGIN [Scan] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Scan] FOR LOGIN [Scan]
GO
