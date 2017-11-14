IF NOT EXISTS (SELECT * FROM master.dbo.syslogins WHERE loginname = N'ArmadaUser')
CREATE LOGIN [ArmadaUser] WITH PASSWORD = 'p@ssw0rd'
GO
CREATE USER [ArmadaUser] FOR LOGIN [ArmadaUser]
GO
