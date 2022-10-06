use AgrupamentoSTB;


-- |--------------------------------------------------------------------------------------|

-- |                          2.1.3 - VERIFICAÇÃO DA NOVA BD                              |

-- |--------------------------------------------------------------------------------------|


-- a) Média de notas no ano letivo por escola
select SchoolYear as 'Ano', SDescription as 'Escola', avg((P1 + P2 + P3)/3) as 'Média' from Grades g 
inner join Student s on g.GStudentID = s.StudentNumber
inner join SchoolRecords sr on g.GradeID = sr.SRGradeID
inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
inner join School sc on ssi.SSISchoolID = sc.SchoolID 
group by SchoolYear, SDescription order by SchoolYear;

-- --------------------------------------------------------------------------------------

-- b) Média de notas por ano letivo e período letivo por escola
select SchoolYear as 'Ano', SDescription as 'Escola', avg(P1) as 'Média P1', avg(P2) as 'Média P2', avg(P3) as 'Média P3' from Grades g 
inner join Student s on g.GStudentID = s.StudentNumber
inner join SchoolRecords sr on g.GradeID = sr.SRGradeID
inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
inner join School sc on ssi.SSISchoolID = sc.SchoolID 
group by SchoolYear, SDescription;


-- --------------------------------------------------------------------------------------

-- c) Total de alunos por escola/ano letivo
select SchoolYear as 'Ano', SDescription as 'Escola', COUNT(StudentNumber) / 3 as 'Número de alunos'
from SchoolRecords sr 
inner join Grades g on sr.SRGradeID = g.GradeID 
inner join Student s on g.GStudentID = s.StudentNumber 
inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID
inner join School sc on ssi.SSISchoolID = sc.SchoolID 
group by SchoolYear ,SDescription;



-- --------------------------------------------------------------------------------------
-- --------------------------------------------------------------------------------------



-- |--------------------------------------------------------------------------------------|

-- |                              EXTRAS/Outras Consultas                                 |

-- |--------------------------------------------------------------------------------------|


-- OldSTB
use OldSTB;

-- 1) Número de alunos rapazes da escola Mousinho da Silveira inscritos em BD nos últimos 3 anos (240 alunos)
SELECT (SELECT COUNT([Student Number]) FROM   dbo.[2017 student-BD] where school = 'MS' and sex = 'M')
		+
        (SELECT COUNT(Student_Number) FROM   dbo.[2018 student-BD] where school = 'MS' and sex = 'M')
		+
		(SELECT COUNT(Student_Number)FROM   dbo.[2019 student-BD] where school = 'MS' and sex = 'M'
        ) AS 'Total de alunos rapazes da Mousinho Silveira'



-- 2) Número de alunos com notas iguais ou superiores a 10 no 1º Período
select (SELECT COUNT([Student Number]) FROM dbo.[2017 student-BD] where P1 >= 10)
		+
       (SELECT COUNT(Student_Number) FROM dbo.[2018 student-BD] where P1 >= 10)
		+
	   (SELECT COUNT(Student_Number)FROM dbo.[2019 student-BD] where P1 >= 10
       ) 
	    +
		(SELECT COUNT(Student_Number)FROM dbo.[2017 student-CBD] where P1 >= 10
       ) 
	    +
		(SELECT COUNT(Student_Number)FROM dbo.[2018 student-CBD] where P1 >= 10
       ) 
	    +
		(SELECT COUNT(Student_Number)FROM dbo.[2019 student-CBD] where P1 >= 10
       ) 
	   +
		(SELECT COUNT(Student_Number)FROM dbo.[2017 student-MAT1] where P1 >= 10
       ) 
	   +
		(SELECT COUNT(Student_Number)FROM dbo.[2018 student-MAT1] where P1 >= 10
       ) 
	   +
		(SELECT COUNT(Student_Number)FROM dbo.[2019 student-MAT1] where P1 >= 10
       ) AS 'Total de alunos com nota >= 10 no P1'


-- 3) Dados de um aluno especifico 
select [Student Number], school, sex, [Birth Date], guardian from dbo.[2017 student-BD] where [Student Number] = 1;

-- 4) Disciplinas, Áreas e Departamentos
select (select distinct Class from dbo.[2017 student-BD]) union 
(select distinct Class from dbo.[2017 student-CBD]) union
(select distinct Class from dbo.[2017 student-MAT1]);

-- 5) Número de chumbos de um aluno ao acaso
select [Student Number] as 'Número de Estudante', convert(int, a.failures) + convert(int, b.failures) + convert(int, c.failures) as 'Nº de Chumbos' from dbo.[2017 student-BD] a join [dbo].[2017 student-CBD] b on a.[Student Number] =b.Student_Number
join dbo.[2017 student-MAT1] c on b.Student_Number = c.Student_Number where [Student Number] = 164;

-- ----------------------------------------------------------------------------------------



-- AgrupamentoSTB
use AgrupamentoSTB;

-- 1) Número de alunos rapazes da escola Mousinho da Silveira inscritos em BD nos últimos 3 anos (240 alunos)
select count(*) as 'Total de alunos rapazes da Mousinho Silveira' from Person p 
inner join Student s on p.PersonID = s.PersonID 
inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID
inner join School sc on ssi.SSISchoolID = SchoolID
where p.PGender = 'M' and sc.SName = 'MS';



-- 2) Número de alunos com notas iguais ou superiores a 10 no 1º Período
select count(P1) from Grades where P1 >= 10; 



-- 3) Dados de um aluno especifico 
select StudentNumber, SName, PGender, PBirthDate, GuardianKinship_en from Student s 
inner join Person p on s.PersonID = p.PersonID
inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
inner join School sc on ssi.SSISchoolID = sc.SchoolID 
inner join Guardian g on s.SGuardianID = g.GuardianID
where StudentNumber = 1;



-- 4) Disciplinas, Áreas e Departamentos
select SName_pt as UC, SDescription_pt as 'Descrição da UC', AName_pt as 'Área', ADescription_pt as 'Descrição da Área', 
DName_pt as Departamento, DDescription_pt as 'Descrição do Departamento'
from Subjects s inner join Area a on s.SAreaID = a.AreaID 
inner join Department d on s.SDepartmentID = DepartmentID; 


-- 5) Número de chumbos de um aluno ao acaso
select StudentNumber, Failures from Student s inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
where StudentNumber = 164;
