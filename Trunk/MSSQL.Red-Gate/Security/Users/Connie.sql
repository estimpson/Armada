IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Connie')
CREATE LOGIN [Connie] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Connie] FOR LOGIN [Connie]
GO
