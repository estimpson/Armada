IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Tabetha')
CREATE LOGIN [Tabetha] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Tabetha] FOR LOGIN [Tabetha]
GO
