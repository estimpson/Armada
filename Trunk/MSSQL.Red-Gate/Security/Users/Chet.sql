IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Chet')
CREATE LOGIN [Chet] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Chet] FOR LOGIN [Chet]
GO
