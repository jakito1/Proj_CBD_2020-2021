use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                        MongoDB                                                  |

-- -- ---------------------------------------------------------------------------------------------|

-- Para podermos popular a nova Base de Dados em MongoDB, decidimos optar pela exportação para ficheiros CSV.

-- Para isso, seguimos as seguintes etapas:

-- 1º: Botão direito do rato na BD AgrupamentoSTB -> Tasks -> Export Data.
-- 2º: Data Source -> SQL Server Native Client 11.0.
-- 3º: Destination -> Flat File Destination.
-- 4º: Selecionar o ficheiro em formato .csv (previamente criado sem nada).
-- 5º: Selecionar a opção 'Write a query to specify the data to transfer' (e aqui escolhemos as colunas que pretendemos através de uma query).
-- 6º: Next -> Next (mudar o column delimiter para semicolon (;)) -> Run Immediately.

-- Depois destas etapas, bastou importar os ficheiros .csv para fazer a devida população.


-- QUERIES USADAS PARA EXPORTAR AS TABELAS NECESSÁRIAS:
-- Person
select PersonID, PName from Person;
-- Guardian
select GuardianID, PersonID from Guardian;
-- Student
select StudentNumber, PersonID, SGuardianID from Student;
-- Subjects
select SubjectID, SName_pt, SDescription_pt from Subjects;
-- Grades
select * from Grades;