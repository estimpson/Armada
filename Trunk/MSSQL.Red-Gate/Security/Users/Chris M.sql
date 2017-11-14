IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Chris')
CREATE LOGIN [Chris] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Chris M] FOR LOGIN [Chris]
GO
