IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'DebW')
CREATE LOGIN [DebW] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [DebW] FOR LOGIN [DebW]
GO
