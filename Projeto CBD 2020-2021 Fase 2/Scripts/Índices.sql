use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                        ÍNDICES                                                  |

-- -- ---------------------------------------------------------------------------------------------|
	
--  Stored Procedure que gera dados de histórico desde o ano 1960 até 2020 para 9 disciplinas e 4 escolas (entre 2000-2500 registos por ano)
go
create or alter procedure GerarDadosDeHistorico
	as
	-- 1º Geramos um número aleatório de registos a criar no intervalo [2000,2500].
	declare @YearCounter int
	set @YearCounter = 1960;
	declare @AllChars varchar(26) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
	declare @AllNumbers varchar(9) = '1029384756';

	-- 2º Criamos as disciplinas e as escolas em falta (E as respetivas áreas e departamentos).
	-- EM ALTERNATIVA PODERIAMOS USAR AS STORED PROCEDURES CRIADAS NA FASE 1
	insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 3', 'U', 'Urbano');
	insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 4', 'U', 'Urbano');
	insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 5', 'R', 'Rural');
	insert into Address(AddressName, AddressType, AddressDescription) values ('Rua Escola 6', 'R', 'Rural');
	insert into School(SName, SDescription, AddressID) values('FP', 'Fernando Pessoa', 1950);
	insert into School(SName, SDescription, AddressID) values('JS', 'José Saramago', 1951);
	insert into School(SName, SDescription, AddressID) values('EQ', 'Eça de Queirós', 1952);
	insert into School(SName, SDescription, AddressID) values('B', 'Bocage', 1953);
	insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) values ('LD', 'Languages Department', 'DL', 'Departamento de Línguas');
	insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) values ('SD', 'Sciences Department', 'DC', 'Departamento de Ciências');
	insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) values ('ITD', 'Information Technology Department', 'DTI', 'Departamento da Tecnologia de Informação');
	insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) values ('AD', 'Arts Department', 'DA', 'Departamento de Artes');
	insert into Department(DName_en, DDescription_en, DName_pt, DDescription_pt) values ('PED', 'Physical Education Department', 'DEF', 'Departamento de Educação Física');
	insert into Area(ADepartmentID, AName_en, ADescription_en, AName_pt, ADescription_pt) values(3, 'L', 'Languages', 'L', 'Línguas');
	insert into Area(ADepartmentID, AName_en, ADescription_en, AName_pt, ADescription_pt) values(4, 'S', 'Sciences', 'C', 'Ciências');
	insert into Area(ADepartmentID, AName_en, ADescription_en, AName_pt, ADescription_pt) values(5, 'I', 'Informatics', 'I', 'Informática');
	insert into Area(ADepartmentID, AName_en, ADescription_en, AName_pt, ADescription_pt) values(6, 'A', 'Arts', 'A', 'Artes');
	insert into Area(ADepartmentID, AName_en, ADescription_en, AName_pt, ADescription_pt) values(7, 'PE', 'Physical Education', 'EF', 'Educação Física');
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('PT', 'Portuguese', 'PT', 'Português', 3);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('EN', 'English', 'I', 'Inglês', 3);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('FR', 'French', 'FR', 'Francês', 3);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('MATH', 'Mathematic', 'MAT', 'Matemática', 2);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('S', 'Sciences', 'C', 'Ciências', 4);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('PC', 'Physico-Chemical', 'FQ', 'Físico-Química', 4);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('ICT', 'Information and Communication Technologies', 'TIC', 'Tecnologias de Informação e Comunicação', 5);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('VE', 'Visual Education', 'EV', 'Educação Visual', 6);
	insert into Subjects(SName_en, SDescription_en, SName_pt, SDescription_pt, SAreaID) values ('PE', 'Physical Education', 'EF', 'Educação Física', 7);

	-- 3º Geramos os dados aleatórios das Disciplinas e Escolas num intervalo de 60 anos ([1960, 2020]).	
	while(@YearCounter <= 2020)
	begin
		declare @RandomNumber int
		set @RandomNumber = (select floor(rand()*(2500-2000+1))+2000);
		declare @RegisterCounter int
		set @RegisterCounter = 1;
		while(@RegisterCounter <= @RandomNumber)
		begin
			declare @Subject int
			declare @RandomGradeP1 int
			declare @RandomGradeP2 int
			declare @RandomGradeP3 int
			declare @RandomSchool int
			set @Subject = (select floor(rand()*(12-4+1))+4);
			set @RandomGradeP1 = (select floor(rand()*(20-0+1))+0);
			set @RandomGradeP2 = (select floor(rand()*(20-0+1))+0);
			set @RandomGradeP3 = (select floor(rand()*(20-0+1))+0);
			set @RandomSchool = (select floor(rand()*(6-3+1))+3);
			insert into Person(PUserTypeID, PName) values(1, (select dbo.randomString(@AllChars, 15)));
			insert into StudentSchoolInfo(SSISchoolID) values(@RandomSchool);
			insert into Student(PersonID, StudentNumber, SStudentSchoolInfoID) values((select top 1 PersonID from Person order by PersonID desc), ((select top 1 StudentNumber from Student order by StudentNumber desc) + 1), (select top 1 StudentSchoolInfoID from StudentSchoolInfo order by StudentSchoolInfoID desc));
			insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values ((select top 1 StudentNumber from Student order by StudentNumber desc), @Subject, (select cast(convert(varchar, (@YearCounter)) as datetime2)));
			insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) values((select top 1 StudentNumber from Student order by StudentNumber desc), @Subject, (select cast(convert(varchar, (@YearCounter)) as datetime2)), @RandomGradeP1, @RandomGradeP2, @RandomGradeP3);
			insert into SchoolRecords(SchoolYear, SRSubjectRegID, SRGradeID) values(@YearCounter, ((select top 1 SubjectRegID from SubjectRegistration order by SubjectRegID desc)), ((select top 1 GradeID from Grades order by GradeID desc)));
			set @RegisterCounter = @RegisterCounter  + 1
		end
		set @YearCounter  = @YearCounter  + 1
	end
go

-- exec GerarDadosDeHistorico;

-- Testes
-- select count(*) as 'Número de Registos' from SchoolRecords where SchoolYear = 1999;
-- select * from SchoolRecords order by SchoolYear;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1 - View que mostra a taxa de crescimento de cada ano, face ao ano anterior, no que ao número de alunos diz respeito.
go
CREATE or alter VIEW View_TaxaCrescimentoNrAlunosEmRelacaoAoAnoAnterior
AS  
	select sr.SchoolYear, count(StudentNumber) as 'Número de alunos', 
	((cast((select count(SRSubjectRegID) from SchoolRecords where SchoolYear = sr.SchoolYear) as float) - 
	cast(nullif((select count(SRSubjectRegID) from SchoolRecords where SchoolYear = sr.SchoolYear-1), 0) as float)) /
	cast((select count(SRSubjectRegID) from SchoolRecords where SchoolYear = sr.SchoolYear-1) as float) * 100) as 'Taxa de Crescimento (%)'
	from SchoolRecords sr inner join Grades g on sr.SRGradeID = g.GradeID inner join Student s on g.GStudentID = s.StudentNumber group by SchoolYear;
go

-- select * from View_TaxaCrescimentoNrAlunosEmRelacaoAoAnoAnterior order by SchoolYear;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 - View que calcula, por ano, a percentagem de alunos com nota final (P3) maior ou igual a 15.
go
CREATE or alter VIEW View_AlunosComNotaFinalMaiorQueQuinze
AS  
	select SchoolYear, (cast((select count(GradeID) from Grades where Year(GDate) = SchoolYear and P3 >=15) as float) * 100 / 
	cast((select count(GradeID) from Grades where Year(GDate) = SchoolYear) as float)) as 'Alunos com Nota Final >= 15 (%)' 
	from SchoolRecords group by SchoolYear;
go

--Test
-- select * from View_AlunosComNotaFinalMaiorQueQuinze order by SchoolYear;

-- select count(GradeID) from Grades where Year(GDate) = 1965    
-- select count(GradeID) from Grades where Year(GDate) = 1965 and P3 >=15;  

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- drop function maxAvgPorAno
-- Esta é uma função auxiliar que foi necessária para gerar os resultados da View_EscolaComMelhorMediaFinalPorAno
-- pois, devido à forma como implementámos a nossa BD, não encontrámos uma maneira melhor de encontrar estes resultados com uma simples query.
CREATE or alter FUNCTION maxAvgPorAno()
RETURNS @maxAvg table(SchoolYear int, SDescription varchar(max), maxAvgPerYear float)
AS 
BEGIN
	declare @yearCounter int
	set @yearCounter = 1960
	while(@yearCounter <= year(GETDATE()))
		begin
			declare @table table(SchoolYear int, SDescription varchar(max), average float)
			insert into @table select SchoolYear, SDescription, ((cast(sum(g.P3) as float)/(cast(count(g.P3) as float)))) as MediaFinal 
								from SchoolRecords sr 
								inner join Grades g on sr.SRGradeID = g.GradeID 
								inner join Student s on g.GStudentID = s.StudentNumber
								inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
								inner join School sc on ssi.SSISchoolID = sc.SchoolID
								where SchoolYear = @yearCounter
								group by SDescription, SchoolYear;
			declare @EscolaComMaiorMedia varchar(max)
			set @EscolaComMaiorMedia = (select SDescription from @table where average = (select max(average) from @table) group by SDescription);
			insert into @maxAvg(SchoolYear, SDescription, maxAvgPerYear) values(@yearCounter, @EscolaComMaiorMedia, (select max(average) from @table));
			delete from @table where average is not null 
			set @yearCounter = @yearCounter + 1
		end
    RETURN
END;



-- 3 - View que calcula, por cada ano, a escola com melhor média final.
go
CREATE or alter VIEW View_EscolaComMelhorMediaFinalPorAno
AS  
	select * from maxAvgPorAno(); 
go

-- Testes
-- select * from View_EscolaComMelhorMediaFinalPorAno order by SchoolYear;

/*drop table temp;

create table temp(
	SchoolYear int,
	SDescription varchar(max), 
	average float
);

insert into temp(SchoolYear, SDescription, average) select SchoolYear, SDescription, ((cast(sum(g.P3) as float)/(cast(count(g.P3) as float)))) as MediaFinal 
								from SchoolRecords sr 
								inner join Grades g on sr.SRGradeID = g.GradeID 
								inner join Student s on g.GStudentID = s.StudentNumber
								inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
								inner join School sc on ssi.SSISchoolID = sc.SchoolID
								where SchoolYear = 1961
								group by SDescription, SchoolYear
insert into temp(SchoolYear, SDescription, average) select SchoolYear, SDescription, ((cast(sum(g.P3) as float)/(cast(count(g.P3) as float)))) as MediaFinal 
								from SchoolRecords sr 
								inner join Grades g on sr.SRGradeID = g.GradeID 
								inner join Student s on g.GStudentID = s.StudentNumber
								inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
								inner join School sc on ssi.SSISchoolID = sc.SchoolID
								where SchoolYear = 1962
								group by SDescription, SchoolYear

select SDescription from temp where average = (select max(average) from temp) group by SDescription

select max(average) from temp

select SDescription from temp group by SDescription, average having max(average) = average; */


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------


-- -- ---------------------------------------------------------------------------------------------|

--                                  NON-CLUSTERED INDEXES                                          |

-- -- ---------------------------------------------------------------------------------------------|

-- DBCC DROPCLEANBUFFERS;
-- set statistics io on;
-- set statistics io off;

-- NONCLUSTERED INDEXES

-- Drop dos Índices  
drop index Ix_SchoolRecords1 on SchoolRecords;   
drop index Ix_SchoolRecords2 on SchoolRecords;    
drop index Ix_Grades on Grades;   
drop index Ix_Student on Student;    

drop index [_dta_index_Grades_7_901682360__K7_4] on Grades;   
drop index [_dta_index_SchoolRecords_7_965682588__K2] on SchoolRecords;   


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 1 - Índices usados para a view: View_TaxaCrescimentoNrAlunosEmRelacaoAoAnoAnterior
create nonclustered index Ix_SchoolRecords1   
    on SchoolRecords (SchoolYear asc)
	include(SRSubjectRegID);   
go

create nonclustered index Ix_SchoolRecords2   
    on SchoolRecords (SRGradeID,SchoolYear);   
go

create nonclustered index Ix_Student  
    on Student (StudentNumber asc)  
go 

-- Índice recomendado pelo Tuning Advisor. Visto só ter uma redução de 3 logical reads, não achámos necessário usá-lo.
/* create nonclustered index Ix_Grades   
    on Grades (GradeID, GStudentID)  
go*/ 


-- Tuning Advisor em relação à view: View_TaxaCrescimentoNrAlunosEmRelacaoAoAnoAnterior
-- Otimização recomendada antes dos índices: 59%
-- Otimização recomendada depois dos índices: 0%
-- Sem índices
-- Table 'SchoolRecords' logical reads 5752
-- Table 'Grades' logical reads 745
-- Table 'Student' logical reads 585
-- Com índices 
-- Table 'SchoolRecords' logical reads 4331
-- Table 'Grades' logical reads 742
-- Table 'Student' logical reads 517

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- 2 - Índices usados para a view: View_AlunosComNotaFinalMaiorQueQuinze
CREATE NONCLUSTERED INDEX [_dta_index_Grades_7_901682360__K7_4] ON [dbo].[Grades]
(
	[P3] ASC
)
INCLUDE([GDate]) WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]

CREATE NONCLUSTERED INDEX [_dta_index_SchoolRecords_7_965682588__K2] ON [dbo].[SchoolRecords]
(
	[SchoolYear] ASC
)WITH (SORT_IN_TEMPDB = OFF, DROP_EXISTING = OFF, ONLINE = OFF) ON [PRIMARY]


-- Tuning Advisor em relação à view: View_TaxaCrescimentoNrAlunosEmRelacaoAoAnoAnterior
-- Otimização recomendada antes dos índices: 19%
-- Otimização recomendada depois dos índices: 0%
-- Sem índices
-- Table 'SchoolRecords' logical reads 1327
-- Table 'Grades' logical reads 45136
-- Com índices 
-- Table 'SchoolRecords' logical reads 748
-- Table 'Grades' logical reads 30866

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Índices usados para a view: maxAvgPorAno(View_EscolaComMelhorMediaFinalPorAno) 

-- A view View_EscolaComMelhorMediaFinalPorAno não precisou do uso de índices, pois foi utilizada uma função auxiliar (maxAvgPorAno()) que já calcula os dados pretendidos, otimizando a procura e cálculo dos resultados.
