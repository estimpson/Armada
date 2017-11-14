IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Laurie')
CREATE LOGIN [Laurie] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Laurie] FOR LOGIN [Laurie]
GO
