IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Gary')
CREATE LOGIN [Gary] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Gary] FOR LOGIN [Gary]
GO
