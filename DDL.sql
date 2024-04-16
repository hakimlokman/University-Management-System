Drop universityDB
Create database universityDB
(Name= 'universityDB_DATA_1', 
FileName = N'C:\Program Files\Microsoft SQL Server\MSSQL14.LOKMAN\MSSQL\DATA\universityDB_DATA_1.mdf' ,
Size= 25Mb, MaxSize = 100Mb, FileGrowth = 5%)
Log on
(Name= 'universityDB_Log_1', 
FileName = N'C:\Program Files\Microsoft SQL Server\MSSQL14.LOKMAN\MSSQL\DATA\universityDB_Log_1.ldf' ,
Size= 2Mb, MaxSize = 50Mb, FileGrowth = 1MB)

Use UniversityDB

Create table Subjects
(
SubjectId Int Primary Key Not Null,
SubjectName varchar(50),
NoOfCredit int Not Null,
Duration varchar(10),
TuitionFee Money ,
Vat Decimal(8,4)
)


create table Teachers
(
TeacherId int Primary key ,
TeacherName Varchar(50),
JoiningDate Date,
Salary Money,
Status Varchar(50)

)


Create Table Students
(
Roll Int Primary Key Not Null,
StudentsName Varchar(30),
DOB date,
BloodGroup VarchaR (20),
Contact int,
District varchar(20),
subjectId int references Subjects(SubjectId)
)




Create table  Campus
(
Campusid Int Primary key ,
CampusName varchar(20)
)


Drop Table MIS
create table MIS (
CampusId Int References Campus(CampusId),
Roll Int  References Students(Roll),
TeacherId int References Teachers(TeacherId),
PaidAmount Money,
ActiveStatus Varchar(30)
)




Select * From Mis
Select * From Teachers
Select * From Students
Select * From Campus
Select * From Subjects
--------Clustered Index
create Clustered Index Xi_Campus
on Mis(CampusId)

-------------------Non Clustered Index
create NonClustered Index Xi_Roll
on Mis(Roll)


-------Instead Of Delete Trigger
Select * Into SubjectCopy From Subjects
Select * From SubjectCopy

Create Table SubjectLog 
(
LogId Int Identity(1,1) Not Null,
SubjectId Int,
ActionLog Varchar(50)
)

Create Trigger Tr_Instead
On SubjectCopy
Instead Of Delete
As
Begin
Declare @SubjectId Int
Select @SubjectId = deleted.SubjectId From deleted
If @SubjectId =3
Begin
Raiserror('This Record Cannot Be Deleted',16,1)
RollBack
Insert Into SubjectLog 
Values (@SubjectId,'Record Cannot be Delete')
End 
Else
Begin
Delete From SubjectCopy 
Where SubjectId = @SubjectId
Insert Into SubjectLog
Values (@SubjectId,'Instead Of Delete')
End
End
Go

---------Trigger Test

Delete SubjectCopy
Where SubjectId = 3
Select * From SubjectCopy
Select * From SubjectLog


----------Function
----Table Value Function
Create Function Fn_Subjects()
Returns Table
Return
(Select * From SubjectCopy)

Select * From dbo.Fn_Subjects()

-----Scalar Function
Create Function Fn_Scalar
()
Returns Int
Begin
Declare @b Int
Select @b = Count(*)  From SubjectCopy
Return @b;
End;
Select  dbo.Fn_Scalar();

-------Multi Table 
Create Function fn_Multi()
Returns @OutTable Table(SubjectName Varchar(50),Duration Varchar(30), TuitionFee Money,Extent_TuitionFee Money)
Begin
Insert Into @OutTable(SubjectName,Duration,TuitionFee,Extent_TuitionFee)
Select SubjectName,Duration,tuitionFee, TuitionFee = TuitionFee + 50000 From SubjectCopy
Return;
End

Select * From dbo.fn_Multi()

Select * Into CampusCopy from Campus
Select * From CampusCopy
---------Store procedure
Create proc Sp_Campus
(
@CampusId int,
@CampusName nvarchar(100),
@Statement Nvarchar(20) =''
)
As 
If @Statement ='Select'
Begin
Select * From CampusCopy
end
If @Statement = 'Insert'
Begin
Insert Into CampusCopy(Campusid,CampusName)
Values (@CampusId,@CampusName)
end
If @Statement = 'Update'
Begin
Update CampusCopy
Set CampusName = @CampusName
Where CampusId = @CampusId
End
If @Statement = 'Delete'
Begin
Delete CampusCopy
Where Campusid = @CampusId
End

Exec Sp_Campus 3,'Agargaon','Insert'
Exec Sp_Campus 3,'Mirpur','Update'
Exec Sp_Campus 3,'Mirpur','Delete'
Go
----In parameter
Create Proc Sp_In
@CampusId int,
@CampusName Varchar(50)
As 
Insert Into CampusCopy
Values (@CampusId,@CampusName)
go
Exec Sp_in 4, 'Badda'

----Out parameter
create Sp_out
(
@CampusId int output
)
as
Select Count(@CampusId)
From CampusCopy
Exec Sp_Out 4
go

----------------Retuen
Create Proc Sp_return
(
@CampusId Int
)
As 
Select CampusId,Campusname From CampusCopy
Where Campusid = @CampusId
Go
Declare @Return_Value Int
Exec @Return_Value = Sp_return @Campusid = 2
Select 'Return value' = @Return_Value


-----------------------Create view
create view Vw_Students
As
Select * From Students

Select * From Vw_Students

------View With Encryption 
create view Vw_enc
With Encryption
As
(Select * From Students )

Select * From  Vw_enc

------View With Schemabinding
Create view Vw_Schema
With SchemaBinding
As
Select roll, StudentsName,BloodGroup From  dbo.Students 

Select * from Vw_Schema

-------------View table With SchemaBinding and Encryption
Create view Vw_both
With SchemaBinding, Encryption
As
Select roll, StudentsName,BloodGroup From  dbo.Students 
 Select * from Vw_both