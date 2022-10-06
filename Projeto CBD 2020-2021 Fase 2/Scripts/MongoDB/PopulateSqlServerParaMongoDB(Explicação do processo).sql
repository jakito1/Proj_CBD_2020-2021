use AgrupamentoSTB;

-- -- ---------------------------------------------------------------------------------------------|

--                                        MongoDB                                                  |

-- -- ---------------------------------------------------------------------------------------------|

-- Para podermos popular a nova Base de Dados em MongoDB, decidimos optar pela exporta��o para ficheiros CSV.

-- Para isso, seguimos as seguintes etapas:

-- 1�: Bot�o direito do rato na BD AgrupamentoSTB -> Tasks -> Export Data.
-- 2�: Data Source -> SQL Server Native Client 11.0.
-- 3�: Destination -> Flat File Destination.
-- 4�: Selecionar o ficheiro em formato .csv (previamente criado sem nada).
-- 5�: Selecionar a op��o 'Write a query to specify the data to transfer' (e aqui escolhemos as colunas que pretendemos atrav�s de uma query).
-- 6�: Next -> Next (mudar o column delimiter para semicolon (;)) -> Run Immediately.

-- Depois destas etapas, bastou importar os ficheiros .csv para fazer a devida popula��o.


-- QUERIES USADAS PARA EXPORTAR AS TABELAS NECESS�RIAS:
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