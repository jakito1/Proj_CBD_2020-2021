use AgrupamentoSTB;

/*
select * from Accounts;
select * from Address;
select * from Area;
select * from CurrentSchoolYear;
select * from Department;
select * from Errors;
select * from Grades;
select * from Guardian;
select * from MetaData;
select * from OptionalStudentInfo;
select * from PasswordChangedEmails;
select * from Person;
select * from School;
select * from SchoolRecords;
select * from Student;
select * from StudentFamilyInfo;
select * from StudentSchoolInfo;
select * from SubjectRegistration;
select * from Subjects;
select * from Users;
*/

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- Esta view permite obter um novo ID aleatório.
Go
Create or alter view Get_NewID
As
	select NEWID() AS MyNewID
Go

Go
Create or alter function randomString(@startingString varchar (MAX), @counter int)
Returns varchar (MAX)
	Begin
		Declare @returnString varchar (MAX) = '';
		While (@counter > 0)
			Begin
				Set @returnString = concat(@returnString, RIGHT( LEFT(@startingString, ABS(BINARY_CHECKSUM((select [MyNewId] from Get_NewID))%35) + 1 ), 1));
				Set @counter -= 1;
			End
		return @returnString;
	End;
Go


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Inserção dos tipos de Usuários

insert into Users(UserType_en, UserType_pt) values('Student', 'Estudante');
insert into Users(UserType_en, UserType_pt) values('Guardian', 'Guardião');
insert into Users(UserType_en, UserType_pt) values('Admin', 'Administrador');


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação das FKs StudentID e SubjectID à tabela Grades

update Grades set GStudentID = (select StudentNumber from Student where StudentNumber = 
	(case when (GradeID % 1947) = 0 then 1947 else (GradeID % 1947) end));

update Grades set GSubjectID = (select SubjectID from Subjects where SName_en =
	(case when GradeID  <= 1947 then 'DB' 
	when GradeID > 1947 and GradeID <= 3894 then 'DAO'
	else 'Math1' end));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação da FK PersonID à tabela Guardian

update Guardian set PersonID = (select PersonID from Person where PersonID = (GuardianID + 1947));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação das FKs UserTypeID e AddressID à tabela Person.
update Person set PUserTypeID = (select UserID from Users where UserID = 
	(case when PersonID > 1947 then 2 else 1 end));
update Person set PAddressID = (select AddressID from Address where AddressID = 
	(case when PUserTypeID != 2 then PersonID else (PersonID - 1947) end));

-- Populate da data de nascimento dos encarregados de Educação
update Person set PBirthDate = (select cast('1900-01-01T00:00:00.000' as datetime2)) where PersonID > 1947;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação das FKs PersonID, GuardianID, StudentSchoolInfoID, StudentFamilyInfoID e OptionalStudentInfoID à tabela Student.

update Student set PersonID = (select PersonID from Person where PersonID = StudentNumber);
update Student set SGuardianID = (select GuardianID from Guardian where GuardianID = StudentNumber);
update Student set SStudentSchoolInfoID = (select StudentSchoolInfoID from StudentSchoolInfo where StudentNumber = StudentSchoolInfoID);
update Student set SStudentFamilyInfoID = (select FamilyInfoID from StudentFamilyInfo where FamilyInfoID = StudentNumber);
update Student set SOptionalStudentInfoID = (select OptionalStudentInfoID from OptionalStudentInfo where OptionalStudentInfoID = StudentNumber);


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite associar a FK StudentSchoolInfoID à tabela Student de forma 
-- a ligar as informações escolares dos alunos pertencentes à OldSTB

go
create or alter procedure AssociarFKStudentSchoolInfoID 
as
Declare
	@tempStudentNumber int,
	@counterGP int = 1,
	@counterMS int = 1,
	@entered bit;
Declare StudentNumber_Cursor cursor
For select StudentNumber from Student;
Open StudentNumber_Cursor;
Fetch next from StudentNumber_Cursor into @tempStudentNumber;
While @@FETCH_STATUS = 0
	Begin
		Set @entered = 0;
		if (@counterGP = 424 and @counterMS < 227 and @entered = 0)
			Begin
				update StudentSchoolInfo set SSISchoolID = 2 where StudentSchoolInfoID = @tempStudentNumber;
				Set @counterMS = @counterMS + 1;
				Set @entered = 1;
			End
		if (@counterGP < 424 and @counterMS = 1 and @entered = 0)
			Begin
				update StudentSchoolInfo set SSISchoolID = 1 where StudentSchoolInfoID = @tempStudentNumber;
				Set @counterGP = @counterGP + 1;
				Set @entered = 1;
			End
		if (@counterGP = 424 and @counterMS = 227)
			Begin
				Set @counterGP = 1;
				Set @counterMS = 1;
			End
		Fetch from StudentNumber_Cursor into @tempStudentNumber;
	End;
Close StudentNumber_Cursor;
Deallocate StudentNumber_Cursor;
go

exec AssociarFKStudentSchoolInfoID


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação das FKs DepartmentID e AreaID à tabela tabela Subjects.

update Subjects set SDepartmentID = (select DepartmentID from Department where DName_en = 'ISD'),
SAreaID = (select AreaID from Area where AName_en = 'DB')
where SName_en = 'DAO' or SName_en = 'DB';
update Subjects set SDepartmentID = (select DepartmentID from Department where DName_en = 'MATHD'),
SAreaID = (select AreaID from Area where AName_en = 'MATH')
where SName_en = 'Math1';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Esta procedure permite popular as inscrições dos alunos nas disciplinas dos dados da OldSTB

go
create or alter procedure InscricoesDisciplinas 
as
declare @tempStudentNumber int
Declare StudentNumber_Cursor cursor
For select StudentNumber from Student;
Open StudentNumber_Cursor;
Fetch from StudentNumber_Cursor into @tempStudentNumber;
While @@FETCH_STATUS = 0
	Begin
		insert into SubjectRegistration(SRStudentID, SRSubjectID) values (@tempStudentNumber, 1); 
		insert into SubjectRegistration(SRStudentID, SRSubjectID) values (@tempStudentNumber, 2); 
		insert into SubjectRegistration(SRStudentID, SRSubjectID) values (@tempStudentNumber, 3); 
		Fetch from StudentNumber_Cursor into @tempStudentNumber;
	End;
Close StudentNumber_Cursor;
Deallocate StudentNumber_Cursor;
go

exec InscricoesDisciplinas;


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação das FKs GradeID e SujectID à classe SchoolRecords

update SchoolRecords set SRGradeID = (select GradeID from Grades where GradeID = RecordsID);
update SchoolRecords set SRSubjectRegID = (select SubjectRegID from SubjectRegistration where SubjectRegID = RecordsID);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate das Inscrições nas disciplinas dos anos da Base de Dados antiga 

update SubjectRegistration set RegistrationDate = (select cast(convert(varchar, (select SchoolYear from SchoolRecords where RecordsID = SubjectRegID)) as datetime2));

update Grades set GDate = (select cast(convert(varchar, (select SchoolYear from SchoolRecords where RecordsID = GradeID)) as datetime2));
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- Permite adicionar notas a um determinado aluno num determinada disciplina
Go
Create or alter procedure insertGrade 
@temp_GStudentID int, @temp_GSubjectID int,
@temp_grade1 int, @temp_grade2 int, @temp_grade3 int
As
	Declare @tempID1 int;
	Declare @tempID2 int;
	insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) 
		values (@temp_GStudentID, @temp_GSubjectID, getdate(), @temp_grade1,
		@temp_grade2, @temp_grade3);
	Set @tempID1 = SCOPE_IDENTITY();
	insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values (@temp_GStudentID, @temp_GSubjectID, getdate());
	Set @tempID2 = SCOPE_IDENTITY();
	insert into CurrentSchoolYear(CSYGradesID, CSYSubjectRegID) values (@tempID1, @tempID2);
Go


exec insertGrade 1, 1, 8, 8, 8;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Biblioteca usada para as Strings aleatórias
declare @AllChars varchar(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
declare @AllNumbers varchar(9) = '1029384756';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate das ruas (nomes aleatórios) da classe Address (ou seja, as moradas)
update Address set AddressName = (select 'Rua ' + (select dbo.randomString(@AllChars, 10)));

-- Populate das moradas das escolas (GP e MS)
insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 1', 'R', 'Rural');
insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 2', 'R', 'Rural');

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Associação da FK AddressID à tabela School 

update School set AddressID = (select AddressID from Address where AddressName = 
(case when SchoolID = 1 then 'Rua Escola 1' else 'Rua Escola 2' end));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Populate aleatório dos atributos Nome (PName), email (PEmail) e telemóvel (PPhone) da tabelas Person

update Person set PName = (select dbo.randomString(@AllChars, 15));
update Person set PEmail = (select(select dbo.randomString(@AllChars, 10)) + '@email.com');
update Person set PPhone = (select dbo.randomString(@AllNumbers, 9));

-- Inserir Administrador
insert into Person(PUserTypeID, PEmail) values (3, 'ADMIN');