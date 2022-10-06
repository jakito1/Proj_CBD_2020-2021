use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                       Transações & Concorrência                                 |

-- -- ---------------------------------------------------------------------------------------------|

-- 1
BEGIN TRAN
	exec FecharAnoLetivo;
	exec AbrirAnoLetivo;
	exec AtualizarNota 1, 1, 2017, 'p1', 0;
COMMIT

-- Cenário 1
BEGIN TRAN
	delete from SchoolRecords where SchoolYear = 2017; 
COMMIT

-- Cenário 2
BEGIN TRAN
	insert into Grades(GStudentID, GSubjectID, GDate, P1) values (1,1,getdate(),16); 
COMMIT
