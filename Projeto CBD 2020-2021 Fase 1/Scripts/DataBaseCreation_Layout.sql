use [master]

/*
alter database [AgrupamentoSTB] set single_user with rollback immediate;
drop database [AgrupamentoSTB];
*/

begin
create database [AgrupamentoSTB] on primary ( 
	name = N'AgrupamentoSTB', 
	filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AgrupamentoSTB.mdf' , 
	size = 50MB , 
	maxsize = 500MB, 
	filegrowth = 50MB
)
log on ( 
	name = N'AgrupamentoSTB_log', 
	filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\AgrupamentoSTB_log.ldf' , 
	size = 100MB , 
	maxsize = 1GB , 
	filegrowth = 100MB
)
end