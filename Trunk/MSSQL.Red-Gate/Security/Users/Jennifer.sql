IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Jennifer')
CREATE LOGIN [Jennifer] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Jennifer] FOR LOGIN [Jennifer]
GO
