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
select * from Idioms;
select * from MeaningsInfo;
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
select * from UsersInfoIdioms;
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

-- 1 - Inserção dos idiomas
insert into Idioms(IName, IDescription) values('EN', 'English');
insert into Idioms(IName, IDescription) values('PT', 'Português');

-- select * from Idioms;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 - Inserção dos significados das várias variáveis dos dados (número de familiares, presenças, etc)
insert MeaningsInfo(MName, Meaning) values('Family Educational Support | Higher Education | Internet Access | In a relationship | Extra Paid Classes | Exta Curricular Activities | Attended Nursery', 'yes');
insert MeaningsInfo(MName, Meaning) values('Family Educational Support | Higher Education | Internet Access | In a relationship | Extra Paid Classes | Exta Curricular Activities | Attended Nursery', 'no');
insert MeaningsInfo(MName, Meaning) values('Other Information', 'other');
insert MeaningsInfo(MName, Meaning) values('Family Relationship | Health', 'Very bad');
insert MeaningsInfo(MName, Meaning) values('Family Relationship | Health', 'Bad');
insert MeaningsInfo(MName, Meaning) values('Family Relationship | Health', 'Normal');
insert MeaningsInfo(MName, Meaning) values('Family Relationship | Health', 'Good');
insert MeaningsInfo(MName, Meaning) values('Family Relationship | Health', 'Excellent');
insert MeaningsInfo(MName, Meaning) values('Study Time', '<2 hours a week');
insert MeaningsInfo(MName, Meaning) values('Study Time', '2-5 hours a week');
insert MeaningsInfo(MName, Meaning) values('Study Time', '5-10 hours a week');
insert MeaningsInfo(MName, Meaning) values('Study Time', '>10 hours a week');
insert MeaningsInfo(MName, Meaning) values('Parents Living Status', 'Living Together');
insert MeaningsInfo(MName, Meaning) values('Parents Living Status', 'Living Apart');
insert MeaningsInfo(MName, Meaning) values('Parents Education', 'None');
insert MeaningsInfo(MName, Meaning) values('Parents Education', '4th Grade');
insert MeaningsInfo(MName, Meaning) values('Parents Education', '5th-9th Grade');
insert MeaningsInfo(MName, Meaning) values('Parents Education', '12th Grade');
insert MeaningsInfo(MName, Meaning) values('Parents Education', 'Higher Education');
insert MeaningsInfo(MName, Meaning) values('School Reason for Choice', 'Close from Home');
insert MeaningsInfo(MName, Meaning) values('School Reason for Choice', 'School Reputation');
insert MeaningsInfo(MName, Meaning) values('School Reason for Choice', 'Course Preference');
insert MeaningsInfo(MName, Meaning) values('Travel Time', '<15min');
insert MeaningsInfo(MName, Meaning) values('Travel Time', '15-30min');
insert MeaningsInfo(MName, Meaning) values('Travel Time', '30min-1hour');
insert MeaningsInfo(MName, Meaning) values('Travel Time', '>1hour');
insert MeaningsInfo(MName, Meaning) values('Free Time | Going Out Frequency | Dalc | Walc - 1', 'Very low');
insert MeaningsInfo(MName, Meaning) values('Free Time | Going Out Frequency | Dalc | Walc - 1', 'Low');
insert MeaningsInfo(MName, Meaning) values('Free Time | Going Out Frequency | Dalc | Walc - 1', 'Normal');
insert MeaningsInfo(MName, Meaning) values('Free Time | Going Out Frequency | Dalc | Walc - 1', 'High');
insert MeaningsInfo(MName, Meaning) values('Free Time | Going Out Frequency | Dalc | Walc - 1', 'Very high');


-- select * from MeaningsInfo;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 3 - População dos significados dos parâmetros da tabela OptionalStudentInfo
update OptionalStudentInfo set SchoolReasonMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when SchoolReason = 'home' then 20 when SchoolReason = 'reputation' 
                                                                                                                        then 21 when SchoolReason = 'course' then 22 when SchoolReason = 'other' then 3 end));
update OptionalStudentInfo set TravelTimeMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when TravelTime = 1 then 23 when TravelTime = 2 
                                                                                                                      then 24 when TravelTime = 3 then 25 when TravelTime = 4 then 26 end));
update OptionalStudentInfo set FreeTimeMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when FreeTime = 1 then 27 when FreeTime = 2 
                                                                                                                      then 28 when FreeTime = 3 then 29 when FreeTime = 4 then 30 when FreeTime = 5 then 31 end));
update OptionalStudentInfo set HigherEduMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when HigherEdu = 1 then 1 when HigherEdu = 0 then 2 end));
update OptionalStudentInfo set InternetAccessMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when InternetAccess = 1 then 1 when InternetAccess = 0 then 2 end));
update OptionalStudentInfo set InRelationshipMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when InRelationship = 1 then 1 when InRelationship = 0 then 2 end));
update OptionalStudentInfo set GoingOutFrequencyMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when GoingOutFrequency = 1 then 27 when GoingOutFrequency = 2 
                                                                                                                             then 28 when GoingOutFrequency = 3 then 29 when GoingOutFrequency = 4 then 30 when GoingOutFrequency = 5 then 31 end));
update OptionalStudentInfo set DalcMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when Dalc = 1 then 27 when Dalc = 2 
                                                                                                                      then 28 when Dalc = 3 then 29 when Dalc = 4 then 30 when Dalc = 5 then 31 end));
update OptionalStudentInfo set WalcMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when Walc = 1 then 27 when Walc = 2 
                                                                                                                      then 28 when Walc = 3 then 29 when Walc = 4 then 30 when Walc = 5 then 31 end));
update OptionalStudentInfo set HealthMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when Health = 1 then 4 when Health = 2 
                                                                                                                      then 5 when Health = 3 then 6 when Health = 4 then 7 when Health = 5 then 8 end));

-- Teste
-- select osi.SchoolReason, mi.Meaning from OptionalStudentInfo osi inner join MeaningsInfo mi on osi.SchoolReasonMeaningID = mi.MeaningsInfoID where OptionalStudentInfoID = 1;
-- select * from OptionalStudentInfo;
-- select * from MeaningsInfo;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 4 - População dos significados dos parâmetros da tabela StudentFamilyInfo
update StudentFamilyInfo set ParentsLivingTogetherMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when ParentsLivingTogether = 0 then 14 when ParentsLivingTogether = 1 then 13 end));
update StudentFamilyInfo set MotherEducationMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when MotherEducation = 0 then 15 when MotherEducation = 1 then 16 when MotherEducation = 2 then 17 when MotherEducation = 3 then 18 when MotherEducation = 4 then 19 end));
update StudentFamilyInfo set FatherEducationMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when FatherEducation = 0 then 15 when FatherEducation = 1 then 16 when FatherEducation = 2 then 17 when FatherEducation = 3 then 18 when FatherEducation = 4 then 19 end));
update StudentFamilyInfo set FamEduSupportMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when FamEduSupport = 1 then 1 when FamEduSupport = 0 then 2 end));
update StudentFamilyInfo set FamRelationshipMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when FamRelationship = 1 then 4 when FamRelationship = 2 then 5 when FamRelationship = 3 then 6 when FamRelationship = 4 then 7 when FamRelationship = 5 then 8 end));

-- Teste
-- select ParentsLivingTogether, Meaning from StudentFamilyInfo sfi inner join MeaningsInfo mi on sfi.ParentsLivingTogetherMeaningID = mi.MeaningsInfoID where FamilyInfoID = 1;
-- select * from StudentFamilyInfo;
-- select * from MeaningsInfo;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 5 - População dos significados dos parâmetros da tabela StudentSchoolInfo
update StudentSchoolInfo set StudyTimeMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when StudyTime = 1 then 9 when StudyTime = 2 then 10 when StudyTime = 3 then 11 else 12 end));
update StudentSchoolInfo set SchoolSupportMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when SchoolSupport = 1 then 1 when SchoolSupport = 0 then 2 end));
update StudentSchoolInfo set ExtraPaidClassesMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when ExtraPaidClasses = 1 then 1 when ExtraPaidClasses = 0 then 2 end));
update StudentSchoolInfo set ExtraCurricularActivitiesMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when ExtraCurricularActivities = 1 then 1 when ExtraCurricularActivities = 0 then 2 end));
update StudentSchoolInfo set AttendedNurseryMeaningID = (select MeaningsInfoID from MeaningsInfo where MeaningsInfoID = (case when AttendedNursery = 1 then 1 when AttendedNursery = 0 then 2 end));

-- Teste
-- select StudyTime, Meaning from StudentSchoolInfo ssi inner join MeaningsInfo mi on ssi.StudyTimeMeaningID = mi.MeaningsInfoID where StudentSchoolInfoID = 1;
-- select * from StudentSchoolInfo;
-- select * from MeaningsInfo;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 6 - Inserção dos tipos de Usuários
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(1,1, 'Student');
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(1,2, 'Guardian');
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(1,3, 'Admin');
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(2,1, 'Estudante');
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(2,2, 'Guardião');
insert into UsersInfoIdioms(UIIIdiomID, UserTypeID, UserTypeDescription) values(2,3, 'Administrador');

-- select * from UsersInfoIdioms;

insert into Users(UserTypeName, UUserInfoID) values('S', 1);
insert into Users(UserTypeName, UUserInfoID) values('G', 2);
insert into Users(UserTypeName, UUserInfoID) values('A', 3);
insert into Users(UserTypeName, UUserInfoID) values('S', 4);
insert into Users(UserTypeName, UUserInfoID) values('G', 5);
insert into Users(UserTypeName, UUserInfoID) values('A', 6);

-- select * from Users;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 7 - Associação das FKs StudentID e SubjectID à tabela Grades

update Grades set GStudentID = (select StudentNumber from Student where StudentNumber = 
	(case when (GradeID % 1947) = 0 then 1947 else (GradeID % 1947) end));

update Grades set GSubjectID = (select SubjectID from Subjects where SName_en =
	(case when GradeID  <= 1947 then 'DB' 
	when GradeID > 1947 and GradeID <= 3894 then 'DAO'
	else 'Math1' end));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 8 - Associação da FK PersonID à tabela Guardian

update Guardian set PersonID = (select PersonID from Person where PersonID = (GuardianID + 1947));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 9 - Associação das FKs UserTypeID e AddressID à tabela Person.
update Person set PUserTypeID = (select UserID from Users where UserID = 
	(case when PersonID > 1947 then 2 else 1 end));
update Person set PAddressID = (select AddressID from Address where AddressID = 
	(case when PUserTypeID != 2 then PersonID else (PersonID - 1947) end));

-- Populate da data de nascimento dos encarregados de Educação
update Person set PBirthDate = (select cast('1900-01-01T00:00:00.000' as datetime2)) where PersonID > 1947;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 10 - Associação das FKs PersonID, GuardianID, StudentSchoolInfoID, StudentFamilyInfoID e OptionalStudentInfoID à tabela Student.

update Student set PersonID = (select PersonID from Person where PersonID = StudentNumber);
update Student set SGuardianID = (select GuardianID from Guardian where GuardianID = StudentNumber);
update Student set SStudentSchoolInfoID = (select StudentSchoolInfoID from StudentSchoolInfo where StudentNumber = StudentSchoolInfoID);
update Student set SStudentFamilyInfoID = (select FamilyInfoID from StudentFamilyInfo where FamilyInfoID = StudentNumber);
update Student set SOptionalStudentInfoID = (select OptionalStudentInfoID from OptionalStudentInfo where OptionalStudentInfoID = StudentNumber);


-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 11 - Esta procedure permite associar a FK StudentSchoolInfoID à tabela Student de forma 
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
-- select * from Area;
-- select * from Department
-- select * from Subjects

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 12 - Associação da FK AreaID à tabela Subjects e associação da FK DepartmentID à tabela Area.

update Subjects set SAreaID = (select AreaID from Area where AName_en = 'DB') where SName_en = 'DAO' or SName_en = 'DB';
update Subjects set SAreaID = (select AreaID from Area where AName_en = 'MATH') where SName_en = 'Math1';

update Area set ADepartmentID = (select DepartmentID from Department where DName_en = 'ISD') where AName_en = 'DB';
update Area set ADepartmentID = (select DepartmentID from Department where DName_en = 'MATHD') where AName_en = 'MATH';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 13 - Esta procedure permite popular as inscrições dos alunos nas disciplinas dos dados da OldSTB

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

-- 14 - Associação das FKs GradeID e SujectID à classe SchoolRecords

update SchoolRecords set SRGradeID = (select GradeID from Grades where GradeID = RecordsID);
update SchoolRecords set SRSubjectRegID = (select SubjectRegID from SubjectRegistration where SubjectRegID = RecordsID);

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 15 - Populate das Inscrições nas disciplinas dos anos da Base de Dados antiga 

update SubjectRegistration set RegistrationDate = (select cast(convert(varchar, (select SchoolYear from SchoolRecords where RecordsID = SubjectRegID)) as datetime2));

update Grades set GDate = (select cast(convert(varchar, (select SchoolYear from SchoolRecords where RecordsID = GradeID)) as datetime2));
-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- 16 - Permite adicionar notas a um determinado aluno num determinada disciplina
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


-- exec insertGrade 1, 1, 8, 8, 8;

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Biblioteca usada para as Strings aleatórias
declare @AllChars varchar(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
declare @AllNumbers varchar(9) = '1029384756';

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 17 - Populate das ruas (nomes aleatórios) da classe Address (ou seja, as moradas)
update Address set AddressName = (select 'Rua ' + (select dbo.randomString(@AllChars, 10)));

-- Populate das moradas das escolas (GP e MS)
insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 1', 'R', 'Rural');
insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 2', 'R', 'Rural');

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 18 - Associação da FK AddressID à tabela School 

update School set AddressID = (select AddressID from Address where AddressName = 
(case when SchoolID = 1 then 'Rua Escola 1' else 'Rua Escola 2' end));

-- --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 19 - Populate aleatório dos atributos Nome (PName), email (PEmail) e telemóvel (PPhone) da tabelas Person

update Person set PName = (select dbo.randomString(@AllChars, 15));
update Person set PEmail = (select(select dbo.randomString(@AllChars, 10)) + '@email.com');
update Person set PPhone = (select dbo.randomString(@AllNumbers, 9));

-- Inserir Administrador
insert into Person(PUserTypeID, PEmail) values (3, 'ADMIN');