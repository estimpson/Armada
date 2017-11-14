IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'Don')
CREATE LOGIN [Don] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Don] FOR LOGIN [Don]
GO
