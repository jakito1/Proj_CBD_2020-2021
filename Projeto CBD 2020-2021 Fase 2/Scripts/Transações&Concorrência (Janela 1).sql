use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                Transações & Concorrência                                        |

-- -- ---------------------------------------------------------------------------------------------|

-- Populate do CurrentSchoolYear para podermos verificar os efeitos da concorrência de transações;
exec AbrirAnoLetivo;

insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values(1, 1, getdate());
insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) values(1, 1, getdate(), 20, 20, 20);
insert into CurrentSchoolYear(CSYGradesID, CSYSubjectRegID) values((select top 1 GradeID from Grades order by GradeID desc), (select top 1 SubjectRegID from SubjectRegistration order by SubjectRegID desc));

insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values(2, 1, getdate());
insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) values(2, 1, getdate(), 20, 20, 20);
insert into CurrentSchoolYear(CSYGradesID, CSYSubjectRegID) values((select top 1 GradeID from Grades order by GradeID desc), (select top 1 SubjectRegID from SubjectRegistration order by SubjectRegID desc));

insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values(3, 2, getdate());
insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) values(3, 2, getdate(), 20, 20, 20);
insert into CurrentSchoolYear(CSYGradesID, CSYSubjectRegID) values((select top 1 GradeID from Grades order by GradeID desc), (select top 1 SubjectRegID from SubjectRegistration order by SubjectRegID desc));

insert into SubjectRegistration(SRStudentID, SRSubjectID, RegistrationDate) values(4, 2, getdate());
insert into Grades(GStudentID, GSubjectID, GDate, P1, P2, P3) values(4, 2, getdate(), 20, 20, 20);
insert into CurrentSchoolYear(CSYGradesID, CSYSubjectRegID) values((select top 1 GradeID from Grades order by GradeID desc), (select top 1 SubjectRegID from SubjectRegistration order by SubjectRegID desc));


-- select * from CurrentSchoolYear;
-- select * from SubjectRegistration;
-- select * from Grades;

-- 1 - Nível de isolamento para as SPs AbrirAnoLetivo, FecharAnoLetivo e AtualizarNota.
set transaction isolation level repeatable read
set nocount on
go
begin tran
	select * from CurrentSchoolYear;
	select * from Grades where GStudentID = 1;
	waitfor delay '00:00:10'
	select * from CurrentSchoolYear;
	select * from Grades where GStudentID = 1;
commit tran

-- --------------------------------------------------------------------------------------------------------------------


-- -- -------------------------------------------------|

--                 Outros Cenários                     |

-- -- -------------------------------------------------|

-- Cenário 1 (eliminar o histórico mais antigo (como se fosse uma manutenção da base de dados) enquanto um aluno tenta aceder ao seu histórico)
set transaction isolation level repeatable read
set nocount on
go
begin tran
	select * from SchoolRecords sr inner join Grades g on sr.SRGradeID = g.GradeID where g.GStudentID = 1;
	waitfor delay '00:00:10'
	select * from SchoolRecords sr inner join Grades g on sr.SRGradeID = g.GradeID where g.GStudentID = 1;
commit tran


-- Cenário 2 (um aluno tenta ver as suas notas e entretanto é adicionada uma nova nota desse mesmo aluno)
set transaction isolation level read committed
set nocount on
go
begin tran
	select * from Grades where GStudentID = 1;
	waitfor delay '00:00:10'
	select * from Grades where GStudentID = 1;
commit tran




	