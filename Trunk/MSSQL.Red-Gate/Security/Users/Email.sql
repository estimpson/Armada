IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'email')
CREATE LOGIN [email] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [Email] FOR LOGIN [email] WITH DEFAULT_SCHEMA=[Email]
GO
REVOKE CONNECT TO [Email]
