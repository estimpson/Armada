IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Cab')
CREATE LOGIN [Cab] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Cab] FOR LOGIN [Cab]
GO
