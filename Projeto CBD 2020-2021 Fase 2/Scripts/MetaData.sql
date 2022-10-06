use AgrupamentoSTB;

-- Esta função retorna a tabela referenciada pela foreign key (TableRef).
go
 create or alter function GetTableFromForeignKey (@constraintName varchar(100))
		returns varchar(128)
		as
		begin
		declare @return varchar(128)
		declare @cursor cursor
		declare @tableName nvarchar(50)

		


set @cursor = cursor for ((SELECT distinct
  t.name
FROM 
   sys.foreign_keys AS fks
INNER JOIN 
   sys.foreign_key_columns AS fksc 
      ON fks.OBJECT_ID = fksc.constraint_object_id
INNER JOIN 
   sys.tables t 
      ON t.OBJECT_ID = fksc.referenced_object_id
WHERE 
   fks.name = @constraintName))



open @cursor
Fetch Next From @cursor Into @tableName


While @@Fetch_Status=0
begin

set @return = concat (@return, ' ', @tableName)
Fetch Next From @cursor Into @tableName

end

	close @cursor
	Deallocate @cursor

		return @return

		end
		go



-- Esta stored procedure recorre ao catálogo de forma a gerar/inserir informações relativas 
-- às tabelas da nova base de dados numa tabela dedicada a estes dados (MetaData).

go
create or alter procedure InserirMetadata
as
declare @cursor cursor
declare @nameConstraint nvarchar(50)
declare @tableName nvarchar(50)
declare @columnName nvarchar(50)


insert into Metadata(tableName, ColumnName, DataType, SizeOfDataType, ConstraintName) 
select b.TABLE_NAME, b.COLUMN_NAME, b.DATA_TYPE, b.CHARACTER_MAXIMUM_LENGTH, c.CONSTRAINT_NAME
from INFORMATION_SCHEMA.TABLES a 
inner join INFORMATION_SCHEMA.COLUMNS b on a.TABLE_SCHEMA = b.TABLE_SCHEMA and a.TABLE_NAME = b.TABLE_NAME 
full outer join INFORMATION_SCHEMA.CONSTRAINT_COLUMN_USAGE c on b.TABLE_SCHEMA = c.TABLE_SCHEMA 
and b.TABLE_NAME = c.TABLE_NAME and b.COLUMN_NAME = c.COLUMN_NAME

set @cursor = cursor for (select ConstraintName, tableName, columnName from dbo.Metadata)

open @cursor
Fetch Next From @cursor Into @nameConstraint, @tableName, @columnName

While @@Fetch_Status=0
begin

update Metadata set TableRef = dbo.GetTableFromForeignKey(@nameConstraint) where TableName = @tableName and columnName = @columnName

Fetch Next From @cursor Into @nameConstraint, @tableName, @columnName
end
	close @cursor
	Deallocate @cursor
go

exec InserirMetadata

-- select * from metadata

-- delete from metadata