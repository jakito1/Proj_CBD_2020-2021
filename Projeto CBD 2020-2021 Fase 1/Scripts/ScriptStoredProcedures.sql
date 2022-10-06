use AgrupamentoSTB;


-- ---------------------------------------------------------------------------------------------|

--                                    StoredProcedures                                          |

-- ---------------------------------------------------------------------------------------------|

-- a) Abrir Ano Letivo 
go
create or alter procedure AbrirAnoLetivo 
as

	declare @table varchar(max)
	set @table = concat(
	'create table CurrentSchoolYear(
	CurrSchoolYearID int identity(1,1) not null primary key, CSYGradesID int foreign key references ', 
	(select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYGradesID'), 
	'(GradeID), CSYSubjectRegID int foreign key references', 
	(select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYSubjectRegID'), 
	'(SubjectRegID));')
	exec (@table)

--select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYGradesID'
--select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYSubjectRegID'

--select ColumnName from metadata where ConstraintName like '%PK%' and TableName = (select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYGradesID')
--select ColumnName from metadata where ConstraintName like '%PK%' and TableName = (select TableRef from metadata where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYSubjectRegID')

go

--exec AbrirAnoLetivo;


-- -----------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------


-- b) Fechar Ano Letivo
go
create or alter procedure FecharAnoLetivo
	as
	declare @TableName varchar(max)
	set @TableName = 
	 CONCAT('select distinct DatePart(yyyy, GDate) as SchoolYear, GradeID as SRGradeID, SubjectRegID as SRSubjectRegID from ', 
	(select TableRef from MetaData where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYGradesID'), 
	' g inner join ', (select TableRef from MetaData where TableName = 'CurrentSchoolYear' and ColumnName = 'CSYSubjectRegID'), 
	' sr on sr.SRStudentID = g.GStudentID and sr.SRSubjectID = g.GSubjectID where DatePart(yyyy, GDate) =  DatePart(yyyy,getDate()) and DatePart(yyyy, RegistrationDate) =  DatePart(yyyy,getDate());' )

	insert into SchoolRecords(SchoolYear, SRSubjectRegID, SRGradeID) exec(@TableName)

	drop table CurrentSchoolYear;
go

--exec FecharAnoLetivo;

-- -----------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------

-- c) Inscrever alunos na disciplina
go
create or alter procedure InscreverAlunoDisciplina 
	@StudentNumber int, @SubjectID int
	as
	if(@StudentNumber is null or @SubjectID is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else if((select SRStudentID from SubjectRegistration where SRStudentID = @StudentNumber and SRSubjectID = @SubjectID and Year(getdate()) = YEAR(RegistrationDate)) is not null)
	begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Student Number | Número de estudante inválido')
		raiserror(15600, 16,1, 'ERROR: Invalid Student Number | Número de estudante inválido')
	end
	
	else
		insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate)
		values(@StudentNumber, @SubjectID, getdate())
go

-- exec InscreverAlunoDisciplina 1, 1; -- Dá erro pois já existe uma inscrição deste aluno nesta disciplina!!!
-- exec InscreverAlunoDisciplina null, 1; -- Erro pois o número de estudante não pode ser null!

-- select * from SubjectRegistration


-- -----------------------------------------------------------------------------------------------------------------------
-- -----------------------------------------------------------------------------------------------------------------------

-- d) Atualização de nota do aluno numa determinada disciplina
go
create or alter procedure AtualizarNota
	@StudentNumber int, @SubjectID int, @Year int, @Period varchar(3), @NewGrade int
	as
	if(@StudentNumber is null or @SubjectID is null or @Period is null or @NewGrade is null or @Year is null)
	begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (não podem ser null)')
	end

	else if(@NewGrade < 0 or @NewGrade > 20)
	begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Grade. Must be [0,20] | Nota inválida. Dever estar entre 0 e 20')
		raiserror(15600, 16,1, 'ERROR: Invalid Grade. Must be [0,20] | Nota inválida. Dever estar entre 0 e 20')
	end

	else
		if(@Period = 'p1')
		begin 
		update Grades set P1 = @NewGrade where GStudentID = @StudentNumber;
		end
		else if(@Period = 'p2')
		begin 
		update Grades set P2 = @NewGrade where GStudentID = @StudentNumber;
		end
		else if(@Period = 'p3')
		begin 
		update Grades set P3 = @NewGrade where GStudentID = @StudentNumber;
		end
		else
		begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Period. Must be p1, p2 or p3 | Perído escolar inválido. Tem de ser p1, p2 ou p3')
		raiserror(15600, 16,1, 'ERROR: Invalid Period. Must be p1, p2 or p3 | Perído escolar inválido. Tem de ser p1, p2 ou p3')
		end
		
go


-- select * from Grades where GStudentID = 1 and GSubjectID = 1; -- Antes da alteração de nota.
-- exec AtualizarNota 10, 1, 2019, 'p1', 10; -- Depois da alteração de nota.
-- exec AtualizarNota null, 1, 'p1', 14; -- Erro pois o número de estudante não pode ser null.
-- exec AtualizarNota 11, null, 'p1', 17; -- Erro pois o ID da disciplina não pode ser null.
-- exec AtualizarNota 12, 1, null, 18; -- Erro pois o período não pode ser null.
-- exec AtualizarNota 13, 1, 'p2', null; -- Erro pois a nova nota não pode ser null;
-- exec AtualizarNota 14, 1, 'p3', -2; -- Erro pois a nova nota tem de ser maior ou igual a 0.
-- exec AtualizarNota 15, 1, 'p3', 22; -- Erro pois a nova nota tem de ser menor ou igual a 20.

-- --------------------------------------------------------------------------------------



-- e) Total de alunos de alunos inscritos em cada uma das disciplinas no ano aberto face ao ano
--    anterior e a respetiva taxa de crescimento.
go
create or alter procedure AlunosInscritosETaxaCrescimento 
	as
	declare @currYearRegistrations int
	declare @pastYearRegistrations int
	declare @growthRate float
	set @currYearRegistrations = (select count(CSYSubjectRegID) from CurrentSchoolYear);
	set @pastYearRegistrations = (select count(SRSubjectRegID) from SchoolRecords);
	set @growthRate = ((@currYearRegistrations - @pastYearRegistrations)/@pastYearRegistrations * 100);
	select @currYearRegistrations as 'Current Year Registrations | Alunos inscritos (ano atual)', 
	@pastYearRegistrations as 'Past Year Registrations | Alunos inscritos (ano anterior)',
	@growthRate as 'Growth Rate | Taxa de crescimento';
go

-- exec AlunosInscritosETaxaCrescimento;

-- --------------------------------------------------------------------------------------


-- f) Média de notas de todos os anos por escola num determinado ano e a respetiva taxa de
--    crescimento face ao ano anterior.
go
create or alter procedure MediaPorAnoETaxaCrescimento 
	@year int 
	as
	declare @yearAvg int
	declare @pastAvg int
	declare @pastYear int
	declare @growthRate float
	if(@year is null )
	begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid year | Ano inválido')
		raiserror(15600, 16,1, 'ERROR: Invalid year | Ano inválido')
	end
	
	else
		set @pastYear = @year-1;
		set @yearAvg = (select avg((P1 + P2 + P3)/3) as 'Média' from SubjectRegistration sr 
 		                inner join Student s on sr.SRStudentID = s.StudentNumber
                        inner join Grades g on s.StudentNumber = g.GStudentID
						where year(RegistrationDate) = @year);
		set @pastAvg = (select avg((P1 + P2 + P3)/3) as 'Média' from SubjectRegistration sr 
 		                inner join Student s on sr.SRStudentID = s.StudentNumber
                        inner join Grades g on s.StudentNumber = g.GStudentID
						where year(RegistrationDate) = @pastYear);
		set @growthRate = ((@yearAvg-@pastAvg)/@pastAvg * 100);
		select @yearAvg as 'Chosen Year Avg | Média do Ano Escolhido', @pastAvg as 'Past Year Avg | Média do ano anterior', @growthRate as 'Growth Rate | Taxa de Crescimento';
go

--exec MediaPorAnoETaxaCrescimento 2019;

-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------

-- |--------------------------------------------------------------------------------------|

-- |										EXTRAS					                      |

-- |--------------------------------------------------------------------------------------|

-- Esta procedure permite a criação de um novo aluno.
go
create or alter procedure CriarAluno 
	@StudentID int, @Name varchar(100), @Email varchar(200), @GuardianID int
	as
	if(@StudentID is null or @Name is null or @Email is null or @GuardianID is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else if((select StudentNumber from Student where StudentNumber = @StudentID) is not null)
	begin 
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Student Number | Número de estudante inválido')
		raiserror(15600, 16,1, 'ERROR: Invalid Student Number | Número de estudante inválido')
	end
	else
	begin
		insert into Person(PName, PEmail) select @Name, @Email
		insert into Student(PersonID, StudentNumber, SGuardianID) select (select PersonID from Person where PName = @Name and PEmail = @Email), @StudentID, @GuardianID
	end
go

-- exec CriarAluno 'Manel', 'manel@gmail.com', 2;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite a criação de um novo Encarregado de Educação.
go
create or alter procedure CriarEncarregado
	@Name varchar(100), @Email varchar(200), @GuardianKinship_en varchar(50)
	as
	if(@Name is null or @Email is null or @GuardianKinship_en is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else
	begin
		insert into Person(PName, PEmail) select @Name, @Email
		insert into Guardian(PersonID, GuardianKinship_en, GuardianKinship_pt) select (select PersonID from Person where PName = @Name and PEmail = @Email), @GuardianKinship_en, (case when @GuardianKinship_en = 'mother' then 'mãe' when @GuardianKinship_en = 'father' then 'pai' when @GuardianKinship_en = 'others'  then '?' end) 
	end
go

-- exec CriarEncarregado 'Rita', 'rita@gmail.com','mother'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite a criação de uma nova Disciplina
go
create or alter procedure CriarDisciplina
	@Name_en varchar(10), @Description_en varchar(100), @Name_pt varchar(10), @Description_pt varchar(100), @DepartmentID int , @AreaID int
	as
	if(@Name_en is null or @Description_en is null or @Name_pt is null or @Description_pt is null  or @DepartmentID is null or @AreaID is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else
	begin
		insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SDepartmentID, SAreaID) select @Name_en, @Description_en, @Name_pt, @Description_pt, @DepartmentID, @AreaID 
	end
go

-- exec CriarDisciplina 'DB2', 'Database 2', 'BD2', 'Base de Dados 2', 1, 1;

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite a criação de uma nova Área.
go
create or alter procedure CriarArea
	@Name_en varchar(10), @Description_en varchar(100), @Name_pt varchar(10), @Description_pt varchar(100)
	as
	if(@Name_en is null or @Description_en is null or @Name_pt is null or @Description_pt is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else
	begin
		insert into Area(AName_en, ADescription_en, AName_pt, ADescription_pt) select @Name_en , @Description_en , @Name_pt , @Description_pt  
	end
go

-- exec CriarArea 'L', 'Languages', 'L', 'Línguas'

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite a criação de um novo Departamento.
go
create or alter procedure CriarDepartamento
	@Name_en varchar(10), @Description_en varchar(100), @Name_pt varchar(10), @Description_pt varchar(100)
	as
	if(@Name_en is null or @Description_en is null or @Name_pt is null or @Description_pt is null)
	begin
		insert into Errors values(SYSTEM_USER, CURRENT_TIMESTAMP, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
		raiserror(15600, 16,1, 'ERROR: Invalid Data (cannot be null) | Dados inválidos (Não podem ser null)')
	end
	else
	begin
		insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) select @Name_en , @Description_en , @Name_pt , @Description_pt  
	end
go
