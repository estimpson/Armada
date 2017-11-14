IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Patti')
CREATE LOGIN [Patti] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Patti] FOR LOGIN [Patti]
GO
