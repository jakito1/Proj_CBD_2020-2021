use AgrupamentoSTB;

-- APAGA TUDO DA NOVA BD
/*
exec sp_MSforeachtable "declare @name nvarchar(max); set @name = parsename('?', 1); exec sp_MSdropconstraints @name";
exec sp_MSforeachtable "drop table ?";
*/

-- ---------------------------------------------------------------------------------

create table Idioms(
	IdiomID int identity(1,1) not null primary key,
	IName varchar(10) not null, 
	IDescription varchar(100)
);

create table MeaningsInfo(
	MeaningsInfoID int identity(1,1) not null primary key,
	MName varchar(max) not null, 
	Meaning varchar(max)
);

create table UsersInfoIdioms(
	UserInfoID int identity(1,1) not null primary key,
	UIIIdiomID int foreign key references Idioms(IdiomID),
	UserTypeID int not null,
	UserTypeDescription varchar(50) unique not null
);

create table Users(
	UserID int identity(1,1) not null primary key,
	UserTypeName varchar(10) not null,
	UUserInfoID int foreign key references UsersInfoIdioms(UserInfoID)
);

create table Errors(
	ErrorID int not null identity(1,1) primary key, 
	SqlServer nvarchar(50) not null, 
	Timestamp datetime not null, 
	Description nvarchar(128) not null
);

create table MetaData(
	MetaDataID int identity(1,1) primary key,
	TableName varchar(100),
	ColumnName varchar(100),
	DataType varchar(100),
	SizeOfDataType int,
	ConstraintName varchar(100),
	TableRef varchar(100)
);

create Table Address(
	AddressID int identity(1,1) not null primary key,
	AddressName varchar(200),
	AddressType varchar(10),
	AddressDescription varchar(100)
);

create table Department(
	DepartmentID int identity(1,1) not null primary key,
	DName_en varchar(20) not null,
	DDescription_en varchar(100),
	DName_pt varchar(20),
	DDescription_pt varchar(100)
);

create table Area(
	AreaID int identity(1,1) not null primary key,
	ADepartmentID int foreign key references Department(DepartmentID),
	AName_en varchar(10) not null,
	ADescription_en varchar(100),
	AName_pt varchar(10) not null,
	ADescription_pt varchar(100)
);

create table Subjects(
	SubjectID int identity(1,1) not null primary key,
	SName_en varchar(10) not null,
	SDescription_en varchar(100),
	SName_pt varchar(10) not null, 
	SDescription_pt varchar(100),
	SAreaID int foreign key references Area(AreaID)
);

create table Person(
	PersonID int identity(1,1) primary key,
	PUserTypeID int foreign key references Users(UserID),
	PName varchar(100),
	PGender char(1),
	PBirthDate datetime,
	PEmail varchar(200),
	PPhone varchar(20),
	PAddressID int foreign key references Address(AddressID)
);

create table Accounts(
	AccountID int identity(1,1) not null primary key,
	AUserID int not null foreign key references Users(UserID),
	APersonID int not null foreign key references Person(PersonID),
	AEmail varchar(200) unique not null,
	EncryptedPassword varchar(max) not null,
);

create table PasswordChangedEmails(
	PasswordChangedEmailsID int identity(1,1) not null primary key,
	Message varchar(200),
	AccountID int foreign key references Accounts(AccountID),
);

create table Guardian(
	GuardianID int identity(1,1) not null primary key,
	PersonID int foreign key references Person(PersonID),
	GuardianKinship_en varchar(50),
	GuardianKinship_pt varchar(50),
);

create table School(
	SchoolID int identity(1,1) not null primary key,
	SName varchar(10) not null,
	SDescription varchar(100),
	AddressID int foreign key references Address(AddressID)
);

create table StudentSchoolInfo(
	StudentSchoolInfoID int identity(1,1) not null primary key,
	SSISchoolID int foreign key references School(SchoolID),
	Failures int,
	Absences int,
	StudyTime int,
	StudyTimeMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	SchoolSupport bit,
	SchoolSupportMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	ExtraPaidClasses bit,
	ExtraPaidClassesMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	ExtraCurricularActivities bit,
	ExtraCurricularActivitiesMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	AttendedNursery bit,
	AttendedNurseryMeaningID int foreign key references MeaningsInfo(MeaningsInfoID)
);

create table StudentFamilyInfo(
	FamilyInfoID int identity(1,1) not null primary key,
	FamilySize varchar(10),
	ParentsLivingTogether bit,
	ParentsLivingTogetherMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	MotherEducation int,
	MotherEducationMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	FatherEducation int,
	FatherEducationMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	MotherJob varchar(50),
	FatherJob varchar(50),
	FamEduSupport bit,
	FamEduSupportMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	FamRelationship int,
	FamRelationshipMeaningID int foreign key references MeaningsInfo(MeaningsInfoID)
);

create table OptionalStudentInfo(
	OptionalStudentInfoID int identity(1,1) not null primary key,
	SchoolReason varchar(50),
	SchoolReasonMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	TravelTime int,
	TravelTimeMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	FreeTime int,   
	FreeTimeMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	HigherEdu bit,
	HigherEduMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	InternetAccess bit,
	InternetAccessMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	InRelationship bit,
	InRelationshipMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	GoingOutFrequency int,
	GoingOutFrequencyMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	Dalc int,
	DalcMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	Walc int,
	WalcMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
	Health int,
	HealthMeaningID int foreign key references MeaningsInfo(MeaningsInfoID),
);

create table Student(
	StudentNumber int not null primary key,
	PersonID int foreign key references Person(PersonID),
	SGuardianID int foreign key references Guardian(GuardianID),
	SStudentSchoolInfoID int foreign key references StudentSchoolInfo(StudentSchoolInfoID),
	SStudentFamilyInfoID int foreign key references StudentFamilyInfo(FamilyInfoID),
	SOptionalStudentInfoID int foreign key references OptionalStudentInfo(OptionalStudentInfoID) 
);

create table SubjectRegistration(
	SubjectRegID int identity(1,1) not null primary key,
	SRStudentID int foreign key references Student(StudentNumber),
	SRSubjectID int foreign key references Subjects(SubjectID),
	RegistrationDate datetime
);

create table Grades(
	GradeID int identity(1,1) not null primary key,
	GStudentID int foreign key references Student(StudentNumber),
	GSubjectID int foreign key references Subjects(SubjectID),
	GDate datetime,
	P1 int,
	P2 int,
	P3 int
);


create table SchoolRecords(
	RecordsID int identity(1,1) not null primary key,
	SchoolYear int not null,
	SRSubjectRegID int foreign key references SubjectRegistration(SubjectRegID),
	SRGradeID int foreign key references Grades(GradeID)
);

create table CurrentSchoolYear(
	CurrSchoolYearID int identity(1,1) not null primary key,
	CSYGradesID int foreign key references Grades(GradeID),
	CSYSubjectRegID int foreign key references SubjectRegistration(SubjectRegID)
);






