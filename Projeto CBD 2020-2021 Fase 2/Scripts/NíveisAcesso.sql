use AgrupamentoSTB;

-- ------------------------------------------------------------------------------------------------|

--                                      N�veis de Acesso                                           |

-- ------------------------------------------------------------------------------------------------|

-- Procedure que cria uma conta de utilizador para os estudantes. 
go
create or alter procedure spNovoStudentUser @studentEmail varchar(50), @password nvarchar(50)
as
declare @sql nvarchar(512)

	set @sql = concat('create login [', @studentEmail ,'Student] with password = ', ' '' ', @password, ' '' ', ' ;',
	' create user [', @studentEmail, '] for login [',@studentEmail,'Student]; exec sp_addrolemember LeituraUtilizadorEscolaRole, [', @studentEmail, ']')

	exec (@sql)
go




-- ------------------------------------------------------------------------------------------------

--Administrador. Tem acesso a toda a informa��o
go
	CREATE LOGIN Administrador WITH PASSWORD = 'admin'
go



IF NOT EXISTS (SELECT * FROM sys.database_principals WHERE name = 'Administrador')
BEGIN
    CREATE USER Administrador FOR LOGIN Administrador
    EXEC sp_addrolemember N'db_owner', N'Administrador'
END;
GO

execute as user = 'Administrador'

-- ------------------------------------------------------------------------------------------------

-- View que filtra os resultados da escola do utilizador 
go
CREATE or alter VIEW view_KeyUserAccess 
AS  
	select StudentNumber as 'N� de Estudante', PName as 'Nome do Estudante', PGender as Genero, PBirthDate as 'Data de nascimento', PEmail as Email, 
	PPhone as Telemovel, GuardianKinship_pt as 'Grau de Parentesco', AddressName as 'Morada', year(GDate) as 'Ano Escolar', P1, P2, P3, Failures as 'N� de reprova��es', Absences as Faltas, 
	StudyTime as 'Tempo de estudo', FamilySize as 'Tamanho da fam�lia',  MotherEducation as 'Educa��o da M�e', Meaning, FatherEducation as 'Educa��o do Pai', MotherJob as 'Profiss�o da M�e', FatherJob as 'Profiss�o do Pai' from Person p 
	inner join Student s on p.PersonID = s.PersonID inner join Guardian g on s.SGuardianID = g.GuardianID 
	inner join Address a on p.PAddressID = a.AddressID inner join Grades gr on s.StudentNumber = gr.GStudentID 
	inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
	inner join StudentFamilyInfo sfi on s.SStudentFamilyInfoID = sfi.FamilyInfoID 
	inner join MeaningsInfo mi on sfi.MotherEducationMeaningID = mi.MeaningsInfoID and sfi.FatherEducationMeaningID = mi.MeaningsInfoID where p.PEmail = (SELECT name FROM sys.database_principals WHERE sid = SUSER_SID());
go

-- Cria��o do Role para os estudantes e as suas respetivas permiss�es/privil�gios.
create role LeituraUtilizadorEscolaRole
grant select on view_KeyUserAccess to LeituraUtilizadorEscolaRole
deny delete on SchoolRecords to LeituraUtilizadorEscolaRole

exec spNovoStudentUser 'PCOIZMXRZZ@email.com', '123qwerty'

execute as user = 'PCOIZMXRZZ@email.com'
select * from view_KeyUserAccess
revert


-- ------------------------------------------------------------------------------------------------
drop Role EscolaRole
drop user if exists Escola
drop login Escola

-- Objetos necess�rios e os privil�gios de acesso aos objetos da base de dados para a Escola. 
-- Cada escola s� tem acesso �s notas dos seus alunos e apenas pode gerir as tabelas de estudantes, inscri��es e notas
create role EscolaRole
grant select,delete,update on Student to EscolaRole;
grant select,delete,update on SubjectRegistration to EscolaRole;
grant select,delete,update on Grades to EscolaRole;

CREATE LOGIN Escola WITH PASSWORD = 'escola123'

go
	CREATE USER Escola FOR LOGIN Administrador
	EXEC sp_addrolemember N'EscolaRole', N'Escola'
go


execute as user = 'Escola'

-- Permiss�o negada
-- select * from Person;

-- Permiss�o Concedida
-- select * from Grades;

