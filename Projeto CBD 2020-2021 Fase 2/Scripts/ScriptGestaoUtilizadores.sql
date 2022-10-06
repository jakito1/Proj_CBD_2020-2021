use AgrupamentoSTB;

--SELECT SESSION_CONTEXT(N'ID');


-- ---------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------
--                                                                                              |
--                                  Gestão de Utilizadores                                      |
--                                                                                              |
-- ---------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------------------------------|---------------------------------------------------------------------------------------------------------------------------------



--Codificar/Hashing (Encripta o email e a password de forma a proteger os dados dos utilizadores)

go
create or alter function Hashing (@String varchar(max))
returns varchar(max)
as
begin
	declare @return varchar(max)
	select @return = CONVERT(VARCHAR(max), HashBytes('SHA2_512', @String)) 
	return @return
end
go

-- select dbo.Hashing('qwerty');



-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permite iniciar a sessão numa conta já existente
go
create or alter procedure Autenticar @email varchar(200), @Password varchar(max)
as
begin
	if (SELECT SESSION_CONTEXT(N'ID')) is null
	begin
		declare @session int

		set @session = (select AccountID from Accounts
			where AEmail = dbo.Hashing(@email) and EncryptedPassword = dbo.Hashing(@Password))

		if @session is not null
			exec sp_set_session_context 'ID', @session; 
	end
end
go

-- exec Autenticar'KSMILMVUSL@email.com', 'estudante123'


-- Termina a sessão do utilizador
go
create or alter procedure Terminar_Sessao
as
	exec sp_set_session_context 'ID', NULL; 
go

-- exec Terminar_Sessao

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Regista um novo Utilizador e inicia a sessão imediatamente depois (criação de conta)

go
create or alter procedure Registar @email varchar(200), @Password varchar(max), @UserType varchar(25)
as
begin
    declare @encriptedEmail varchar (200);
    declare @encriptedPassword varchar (max);
    declare @UserTypeID int = null;
    declare @PersonID int;

    set @PersonID = (select PersonID from Person where PEmail = @email);
    set @UserTypeID = (select UserID from Users where UserTypeName = @UserType);
    if @UserTypeID is not null and @PersonID is not null and @email is not null and @Password is not null
    begin
        set @encriptedEmail = dbo.Hashing(@email);
        set @encriptedPassword = dbo.Hashing(@Password);
        insert into Accounts(AUserID,APersonID, AEmail, EncryptedPassword) values (@UserTypeID, @PersonID, @encriptedEmail, @encriptedPassword);
        exec Autenticar @email, @Password;
    end
end
go

--exec Registar 'ZKZJBSBZCE@email.com', 'estudante123', 'Guardian'

-- select PersonID from Person where PEmail = 'ZKZMPCZZZS@email.com'
-- select * from Person;
-- select * from Accounts;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permite ao guardião ou estudante acederem aos seus dados

go
create or alter procedure AcederInformacao
as
begin
	declare @AccountID int = convert(int, (select SESSION_CONTEXT(N'ID')));
	declare @PersonID int;
	declare @UserTypeID int;
	if @AccountID is not null
	begin
		Set @PersonID = (select APersonID from Accounts where AccountID = @AccountID);
		Set @UserTypeID = (select AUserID from Accounts where AccountID = @AccountID);
		print @PersonID;
		print @UserTypeID;
		if @UserTypeID = 1 or @UserTypeID = 2
			Select PName, PGender, PBirthDate, PEmail, PPhone, GuardianKinship_en, GuardianKinship_pt, AddressName, AddressType, AddressDescription, 
				GDate, P1, P2, P3, Failures, Absences, StudyTime, FamilySize,  MotherEducation, FatherEducation, MotherJob, FatherJob from Person p 
				inner join Student s on p.PersonID = s.PersonID inner join Guardian g on s.SGuardianID = g.GuardianID 
				inner join Address a on p.PAddressID = a.AddressID inner join Grades gr on s.StudentNumber = gr.GStudentID 
				inner join StudentSchoolInfo ssi on s.SStudentSchoolInfoID = ssi.StudentSchoolInfoID 
				inner join StudentFamilyInfo sfi on s.SStudentFamilyInfoID = sfi.FamilyInfoID where p.PersonID = @PersonID;
	end
end
go

-- exec AcederInformacao;

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Permite ao utilizador alterar as sua palavra passe

go
create or alter procedure AlterarPalavrapasse @CurrPassword varchar(max), @NewPassword1 varchar(max), @NewPassword2 varchar(max)
as
begin
	declare @encriptedCurrPassword varchar (max);
	declare @encriptedNewPassword1 varchar (max);
	declare @encriptedNewPassword2 varchar (max);
	declare @AccountID int = convert(int, (select SESSION_CONTEXT(N'ID')));
	
	if @CurrPassword is not null and @NewPassword1 is not null and @NewPassword2 is not null and @AccountID is not null
	begin
		set @encriptedCurrPassword = dbo.Hashing(@CurrPassword);
		if @encriptedCurrPassword is not null
			set @encriptedNewPassword1 = dbo.Hashing(@NewPassword1);
			set @encriptedNewPassword2 = dbo.Hashing(@NewPassword2);
		if @encriptedNewPassword1 = @encriptedNewPassword2 and @encriptedNewPassword1 is not null
			and @encriptedNewPassword2 is not null
			exec Terminar_Sessao;
			update Accounts set EncryptedPassword = @encriptedNewPassword1 where AccountID = @AccountID;
			insert into PasswordChangedEmails(Message, AccountID) values ('Palavra passs alterada as: ' + convert(varchar, getdate()), @AccountID);
	end
end
go

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Altera a palvra passe do utilizador e envia a nova palavra passe para o seu email

Go
Create or alter procedure RecuperarPalavrapasse @email varchar(200)
As
Begin  
	exec sp_set_session_context 'ID', NULL; 
	declare @encriptedEmail varchar (200);
	declare @AccountID int;
	declare @returnString varchar(5);
	declare @Dictionary varchar(35) = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321';
	declare @oldPassword varchar (max);

	if @email is not null
	begin
		set @encriptedEmail = dbo.Hashing(@email);
		set @AccountID = (select AccountID from Accounts where AEmail = @encriptedEmail);
		if @AccountID is not null
		begin
			set @oldPassword = (select EncryptedPassword from Accounts where AccountID = @AccountID);
			set @returnString = dbo.randomString(@Dictionary, 5);
			update Accounts set EncryptedPassword = dbo.Hashing(@returnString);
			insert into PasswordChangedEmails(Message, AccountID) values ('Palavra passe alterada às: ' + convert(varchar, getdate()) + ' para: ' + @returnString, @AccountID);
			select @returnString;
		end
	end
End  
Go

-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Registar Administrador
exec Registar 'ADMIN', 'admin123', 'Admin'
exec Terminar_Sessao;

select * from Accounts
