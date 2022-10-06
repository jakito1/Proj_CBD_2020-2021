use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                   Backup E Recuperação                                          |

-- -- ---------------------------------------------------------------------------------------------|

-- backup completo
go
create or alter procedure fullBackup
as
	begin
		Backup database [AgrupamentoSTB]
		to disk = N'C:SQLServer\DatabaseBackups\ASTB_full.bak'
	end
go

-- backup parcial 1
go
create or alter procedure partialBackup_1
as
	begin
		Backup database [AgrupamentoSTB]
		to disk = N'C:SQLServer\DatabaseBackups\ASTB_partial1.bak'
		with differential;
	end
go

-- backup parcial 2
go
create or alter procedure partialBackup_2
as
	begin
		Backup database [AgrupamentoSTB]
		to disk = N'C:SQLServer\DatabaseBackups\ASTB_partial2.bak'
		with differential;
	end
go

-- backup do log
go
create or alter procedure logBackup
as
	begin
		Backup log [AgrupamentoSTB]
		to disk = N'C:SQLServer\LogBackups\ASTB.log'
	end
go

-- backup do tail do log
go
create or alter procedure backupLogTail
as
	begin
		Backup log [AgrupamentoSTB]
		to disk = N'C:SQLServer\LogBackups\ASTB_tail.trn'
		with no_truncate
	end
go

-- restore do backup completo
go
create or alter procedure restoreFullBackup
as
	begin
		Restore database [AgrupamentoSTB]
		from disk = N'C:SQLServer\DatabaseBackups\ASTB_full.bak'
		with norecovery
	end
go

-- restore do backup parcial 1
go
create or alter procedure restorePartialBackup_1
as
	begin
		Restore database [AgrupamentoSTB]
		from disk = N'C:SQLServer\DatabaseBackups\ASTB_partial1.bak'
		with norecovery
	end
go

-- restore do backup parcial 2
go
create or alter procedure restorePartialBackup_2
as
	begin
		Restore database [AgrupamentoSTB]
		from disk = N'C:SQLServer\DatabaseBackups\ASTB_partial2.bak'
		with norecovery
	end
go

-- restore dos logs
go
create or alter procedure restoreLog
as
	begin
		Restore log [AgrupamentoSTB]
		from disk = N'C:SQLServer\LogBackups\ASTB.log'
		with norecovery
	end
go

-- restore do tail dos logs
go
create or alter procedure restoreLogTail
as
	begin
		Restore log [AgrupamentoSTB]
		from disk = N'C:SQLServer\LogBackups\ASTB_tail.trn'
		with recovery
	end
go
