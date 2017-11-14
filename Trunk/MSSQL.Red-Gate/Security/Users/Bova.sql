IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Bova')
CREATE LOGIN [Bova] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Bova] FOR LOGIN [Bova]
GO
