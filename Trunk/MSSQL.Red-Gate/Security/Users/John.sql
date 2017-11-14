IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'John')
CREATE LOGIN [John] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [John] FOR LOGIN [John]
GO
