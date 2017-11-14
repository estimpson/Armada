IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Deb')
CREATE LOGIN [Deb] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Deb] FOR LOGIN [Deb]
GO
