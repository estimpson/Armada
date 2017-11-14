IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Butch')
CREATE LOGIN [Butch] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Butch] FOR LOGIN [Butch]
GO
