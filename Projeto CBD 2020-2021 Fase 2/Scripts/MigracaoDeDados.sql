use AgrupamentoSTB;

/*
exec sp_MSforeachtable "declare @name nvarchar(max); set @name = parsename('?', 1); exec sp_MSdropconstraints @name";
exec sp_MSforeachtable "drop table ?";

EXEC sp_MSForEachTable 'DISABLE TRIGGER ALL ON ?'
GO
EXEC sp_MSForEachTable 'ALTER TABLE ? NOCHECK CONSTRAINT ALL'
GO
EXEC sp_MSForEachTable 'DELETE FROM ?'
GO
EXEC sp_MSForEachTable 'ALTER TABLE ? CHECK CONSTRAINT ALL'
GO
EXEC sp_MSForEachTable 'ENABLE TRIGGER ALL ON ?'
GO

EXEC sp_MSforeachtable 'DBCC CHECKIDENT ([?], reseed, 0)'
*/

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 1 - Tabela Address (Associado ao comentário do PostalCode)
-- Apenas é necessário inserir de uma cadeira de cada ano pois a informação é repetida.
insert into Address(AddressType, AddressDescription) select address, (case when address = 'U' then 'Urbano' when address = 'R' then 'Rural' end) as AddressDescription 
from OldSTB.dbo.[2017 student-BD];

insert into Address(AddressType, AddressDescription) select address, (case when address = 'U' then 'Urbano' when address = 'R' then 'Rural' end) as AddressDescription 
from OldSTB.dbo.[2018 student-CBD];

insert into Address(AddressType, AddressDescription) select address, (case when address = 'U' then 'Urbano' when address = 'R' then 'Rural' end) as AddressDescription 
from OldSTB.dbo.[2019 student-MAT1];

--select * from Address;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------


-- 2 - Tabela Person (Informação básica dos Alunos e Encarregados de Educação)
insert into Person(PGender, PBirthDate)
select sex, convert(datetime, [Birth Date], 103) from OldSTB.dbo.[2017 student-BD];
insert into Person(PGender, PBirthDate)
select sex, convert(datetime, Birth_Date, 103) from OldSTB.dbo.[2018 student-CBD];
insert into Person(PGender, PBirthDate)
select sex, convert(datetime, Birth_Date, 103) from OldSTB.dbo.[2019 student-MAT1];

insert into Person(PGender)
select case when guardian = 'mother' then 'F' when guardian = 'father' then 'M' else '?' end from OldSTB.dbo.[2017 student-BD];
insert into Person(PGender)
select case when guardian = 'mother' then 'F' when guardian = 'father' then 'M' else '?' end from OldSTB.dbo.[2018 student-CBD];
insert into Person(PGender)
select case when guardian = 'mother' then 'F' when guardian = 'father' then 'M' else '?' end from OldSTB.dbo.[2019 student-MAT1];

--select * from Person;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 3 - Tabela Guardian (Encarregado de Educação) case when guardian = 'mother' then 'mãe' when guardian = 'father' then 'pai'
-- Apenas é necessário inserir de uma cadeira de cada ano pois a informação é repetida.
insert into Guardian(GuardianKinship_pt, GuardianKinship_en) select (case when guardian = 'mother' then 'mãe' when guardian = 'father' then 'pai' when guardian = 'other' then 'outro' end), 
guardian from OldSTB.dbo.[2017 student-BD];
insert into Guardian(GuardianKinship_pt, GuardianKinship_en) select (case when guardian = 'mother' then 'mãe' when guardian = 'father' then 'pai' when guardian = 'other' then 'outro' end),
guardian from OldSTB.dbo.[2018 student-CBD];
insert into Guardian(GuardianKinship_pt, GuardianKinship_en) select (case when guardian = 'mother' then 'mãe' when guardian = 'father' then 'pai' when guardian = 'other' then 'outro' end),
guardian from OldSTB.dbo.[2019 student-MAT1];


--select * from Guardian;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 4 - Tabela Student (Alunos - informação básica)
insert into Student(StudentNumber)
select distinct [Student Number] from OldSTB.dbo.[2017 student-BD];

insert into Student(StudentNumber)
select distinct Student_Number from OldSTB.dbo.[2018 student-CBD];

insert into Student(StudentNumber)
select distinct Student_Number from OldSTB.dbo.[2019 student-MAT1];

--select * from Student;



-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 5 - Tabela Department (Departamento da disciplina)
insert into Department(DName_pt, DDescription_pt, DName_en, DDescription_en)
select distinct SUBSTRING(Class, 1, 3), (case when SUBSTRING(Class, 1, 3) = 'DSI' then 'Departamento de Sistemas de Informação' end),(case when SUBSTRING(Class, 1, 3) = 'DSI' then 'ISD' end), (case when SUBSTRING(Class, 1, 3) = 'DSI' then 'Information Systems Department' end) from OldSTB.dbo.[2017 student-BD];

insert into Department(DName_pt, DDescription_pt, DName_en, DDescription_en)
select distinct SUBSTRING(Class, 1, 4), (case when SUBSTRING(Class, 1, 4) = 'DMAT' then 'Departamento de Matemática' end),(case when SUBSTRING(Class, 1, 4) = 'DMAT' then 'MATHD' end), (case when SUBSTRING(Class, 1, 4) = 'DMAT' then 'Mathematics Department' end) from OldSTB.dbo.[2017 student-MAT1];

--select * from Department;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 6 - Tabela Area (Área da disciplina)
insert into Area(AName_pt, ADescription_pt, AName_en, ADescription_en)
select distinct SUBSTRING(Class, 5, 2), (case when SUBSTRING(Class, 5, 2) = 'BD' then 'Base de Dados' end) 
, 'DB', 'Database' from OldSTB.dbo.[2017 student-BD];

insert into Area(AName_pt, ADescription_pt, AName_en, ADescription_en)
select distinct SUBSTRING(Class, 6, 3), (case when SUBSTRING(Class, 6, 3) = 'MAT' then 'Matemática' end) 
,'MATH', 'Mathematics' from OldSTB.dbo.[2017 student-MAT1];


--select * from Area;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 7 - Tabela Subjects (Notas dos alunos)
insert into Subjects(SName_pt, SDescription_pt, SName_en, SDescription_en)
select distinct SUBSTRING(Class, 8, 2), (case when SUBSTRING(Class, 8,2) = 'BD' then 'Base de Dados' end), 'DB', 'DataBase' from OldSTB.dbo.[2017 student-BD];

insert into Subjects(SName_pt, SDescription_pt, SName_en, SDescription_en)
select distinct SUBSTRING(Class, 8, 3), (case when SUBSTRING(Class, 8,3) = 'CBD' then 'Complementos de Base de Dados' end), 'DAO', 'Database Add-ons' from OldSTB.dbo.[2018 student-CBD];

insert into Subjects(SName_pt, SDescription_pt, SName_en, SDescription_en)
select distinct SUBSTRING(Class, 10, 4), (case when SUBSTRING(Class, 10,4) = 'MAT1' then 'Matemática 1' end), 'Math1', 'Mathematics 1' from OldSTB.dbo.[2019 student-MAT1];


--select * from Subjects;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 8 - Tabela Grades (Notas dos alunos)
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2017 student-BD];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2018 student-BD];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2019 student-BD];

insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2017 student-CBD];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2018 student-CBD];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2019 student-CBD];

insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2018 student-MAT1];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2017 student-MAT1];
insert into Grades(P1, P2, P3)
select P1, P2, P3 from OldSTB.dbo.[2019 student-MAT1];


--select * from Grades;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 9 - Tabela School (Informação básica da escola)
insert into School(SName, SDescription)
select distinct school, (case when school = 'GP' then 'Gabriel Pereira' when school = 'MS' then 'Mousinho da Silveira' end) from OldSTB.dbo.[2017 student-BD];


--select * from School;

-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 10 - Tabela StudentSchoolInfo (Informação Académica)
insert into StudentSchoolInfo(Failures, Absences, StudyTime, SchoolSupport, ExtraPaidClasses, ExtraCurricularActivities, AttendedNursery)
select convert(int, a.failures) + convert(int, b.failures) + convert(int, c.failures), 
       convert(int, a.absences) + convert(int, b.absences) + convert(int, c.absences), 
	   (convert(int, a.studytime) + convert(int, b.studytime) + convert(int, c.studytime)) / 3,  
	   (case when a.schoolsup = 'yes' then 1 when a.schoolsup = 'no' then 0 end), 
	   (case when a.paid = 'yes' then 1 when a.paid = 'no' then 0 end), 
	   (case when a.activities = 'yes' then 1 when a.activities = 'no' then 0 end), 
	   (case when a.nursery = 'yes' then 1 when a.nursery = 'no' then 0 end) 
	   from OldSTB.dbo.[2017 student-BD] a 
	   join OldSTB.dbo.[2017 student-CBD] b on a.[Student Number] = b.Student_Number 
	   join OldSTB.dbo.[2017 student-MAT1] c on b.Student_Number = c.Student_Number;


insert into StudentSchoolInfo(Failures, Absences, StudyTime, SchoolSupport, ExtraPaidClasses, ExtraCurricularActivities, AttendedNursery)
select convert(int, a.failures) + convert(int, b.failures) + convert(int, c.failures), 
       convert(int, a.absences) + convert(int, b.absences) + convert(int, c.absences), 
	   convert(int, a.studytime) + convert(int, b.studytime) + convert(int, c.studytime),  
	   (case when a.schoolsup = 'yes' then 1 when a.schoolsup = 'no' then 0 end), 
	   (case when a.paid = 'yes' then 1 when a.paid = 'no' then 0 end), 
	   (case when a.activities = 'yes' then 1 when a.activities = 'no' then 0 end), 
	   (case when a.nursery = 'yes' then 1 when a.nursery = 'no' then 0 end) 
	   from OldSTB.dbo.[2018 student-BD] a 
	   join OldSTB.dbo.[2018 student-CBD] b on a.Student_Number = b.Student_Number 
	   join OldSTB.dbo.[2018 student-MAT1] c on b.Student_Number = c.Student_Number;


insert into StudentSchoolInfo(Failures, Absences, StudyTime, SchoolSupport, ExtraPaidClasses, ExtraCurricularActivities, AttendedNursery)
select convert(int, a.failures) + convert(int, b.failures) + convert(int, c.failures), 
       convert(int, a.absences) + convert(int, b.absences) + convert(int, c.absences), 
	   convert(int, a.studytime) + convert(int, b.studytime) + convert(int, c.studytime),  
	   (case when a.schoolsup = 'yes' then 1 when a.schoolsup = 'no' then 0 end), 
	   (case when a.paid = 'yes' then 1 when a.paid = 'no' then 0 end), 
	   (case when a.activities = 'yes' then 1 when a.activities = 'no' then 0 end), 
	   (case when a.nursery = 'yes' then 1 when a.nursery = 'no' then 0 end) 
	   from OldSTB.dbo.[2019 student-BD] a 
	   join OldSTB.dbo.[2019 student-CBD] b on a.Student_Number = b.Student_Number 
	   join OldSTB.dbo.[2019 student-MAT1] c on b.Student_Number = c.Student_Number;



--select * from StudentSchoolInfo;


-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 11 - Tabela StudentFamilyInfo (Informação Familiar)
insert into StudentFamilyInfo(FamilySize, ParentsLivingTogether, MotherEducation, FatherEducation, MotherJob, FatherJob, FamEduSupport, FamRelationship)
select (case when famsize = 'LE3' then '<=3' when famsize = 'GT3' then '>3' end), 
(case when Pstatus = 'T' then 1 when Pstatus = 'A' then 0 end), 
Medu, Fedu, MJob, FJob,  
(case when famsup = 'yes' then 1 when famsup = 'no' then 0 end), 
famrel from OldSTB.dbo.[2017 student-BD];

insert into StudentFamilyInfo(FamilySize, ParentsLivingTogether, MotherEducation, FatherEducation, MotherJob, FatherJob, FamEduSupport, FamRelationship)
select (case when famsize = 'LE3' then '<=3' when famsize = 'GT3' then '>3' end), 
(case when Pstatus = 'T' then 1 when Pstatus = 'A' then 0 end), 
Medu, Fedu, MJob, FJob,  
(case when famsup = 'yes' then 1 when famsup = 'no' then 0 end), 
famrel from OldSTB.dbo.[2018 student-CBD];

insert into StudentFamilyInfo(FamilySize, ParentsLivingTogether, MotherEducation, FatherEducation, MotherJob, FatherJob, FamEduSupport, FamRelationship)
select (case when famsize = 'LE3' then '<=3' when famsize = 'GT3' then '>3' end), 
(case when Pstatus = 'T' then 1 when Pstatus = 'A' then 0 end), 
Medu, Fedu, MJob, FJob,  
(case when famsup = 'yes' then 1 when famsup = 'no' then 0 end), 
famrel from OldSTB.dbo.[2019 student-MAT1];



--select * from StudentFamilyInfo;


-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 12 - Tabela OptionalStudentInfo (Informação Extra/Opcional do aluno)
insert into OptionalStudentInfo(SchoolReason, TravelTime, FreeTime, HigherEdu, InternetAccess, InRelationship, GoingOutFrequency, Dalc, Walc, Health)
select reason, traveltime, freetime, 
(case when higher = 'yes' then 1 when higher = 'no' then 0 end),
(case when internet = 'yes' then 1 when internet = 'no' then 0 end),
(case when romantic = 'yes' then 1 when romantic = 'no' then 0 end),
goout, Dalc, Walc, health from OldSTB.dbo.[2017 student-BD];

insert into OptionalStudentInfo(SchoolReason, TravelTime, FreeTime, HigherEdu, InternetAccess, InRelationship, GoingOutFrequency, Dalc, Walc, Health)
select reason, traveltime, freetime, 
(case when higher = 'yes' then 1 when higher = 'no' then 0 end),
(case when internet = 'yes' then 1 when internet = 'no' then 0 end),
(case when romantic = 'yes' then 1 when romantic = 'no' then 0 end),
goout, Dalc, Walc, health from OldSTB.dbo.[2018 student-CBD];

insert into OptionalStudentInfo(SchoolReason, TravelTime, FreeTime, HigherEdu, InternetAccess, InRelationship, GoingOutFrequency, Dalc, Walc, Health)
select reason, traveltime, freetime, 
(case when higher = 'yes' then 1 when higher = 'no' then 0 end),
(case when internet = 'yes' then 1 when internet = 'no' then 0 end),
(case when romantic = 'yes' then 1 when romantic = 'no' then 0 end),
goout, Dalc, Walc, health from OldSTB.dbo.[2019 student-MAT1];


--select * from OptionalStudentInfo;


-- ----------------------------------------------------------------------------------------------------
-- ----------------------------------------------------------------------------------------------------

-- 13 - SchoolRecords (registos das inscrições e notas (por associações de FKs))
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2017 student-BD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2017 student-CBD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2017 student-MAT1];

insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2018 student-BD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2018 student-CBD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2018 student-MAT1];

insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2019 student-BD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2019 student-CBD];
insert into SchoolRecords(SchoolYear)
select year from OldSTB.dbo.[2019 student-MAT1];



--select * from SchoolRecords;