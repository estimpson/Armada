IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Dawn')
CREATE LOGIN [Dawn] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Dawn] FOR LOGIN [Dawn]
GO
