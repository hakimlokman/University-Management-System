Drop universityDB
Create database universityDB
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

Insert into Subjects
Values (1,'English', 32, '4 Years',250000,0.15),
	   (2,'BBA',36,'4 years',330000,0.15),
	   (3,'LLB' ,32,'4 years',300000,0.15),
	   (4,'CSE',40,'4 Years',450000,0.15),
	   (5,'IT',42,'4 years', 420000,0.15)

create table Teachers
(
TeacherId int Primary key ,
TeacherName Varchar(50),
JoiningDate Date,
Salary Money,
Status Varchar(50)
)

Insert Into Teachers
Values (1,'Mr. AtiKizzaman','2016-09-22',80000,'Assistant Professor'),
	   (2,'Mr.Harun-or-Rashid','2012-11-19',110000,'Professor'),
	   (3,'Mr. Rakib Mahmud','2020-12-25',60000,'Lecturer'),
	   (4,'Mr Tarikul Islam','2019-01-01',70000,'Associate Professor'),
	   (5,'Mr. Jahidur Rahman','2022-01-30',65000,'Lecturer')


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

Insert Into Students
Values (1001,'kaniz Fatema','1998-05-18','A Positive',01787458796,'GopalGonj',1),
	   (1002,'Nazmul Huda','1996-08-08','O Positive',01815879826,'Bogura',2),
	   (1003,'Abdul Kaium','1996-09-25','O positive',01571458796,'Dhaka',3),
	   (1004,'Rashidul Islam','1997-02-13','A Positive',01915789548,'NowaKhali',3),
	   (1005,'Asif kamran','1996-04-19','B Positive',01925478965,'Dhaka',4),
	   (1006,'Hasibul Hasan','1997-09-14','O Positive',01960086635,'Vhola',5),
	   (1007,'Toriqul Islam','1996-06-22','AB Positive',01925458796,'Rajshahi',4),
	   (1008,'Habibur Rahman','1994-08-22','A Positive',01515459878,'Feni',5),
	   (1009,'LOkman Hakim','1996-12-30','O Positive',01521204376,'Satkhira',2),
	   (1010,'Yasin ali','1995-05-09','O Negetive',01514569878,'Jashore',1),
	   (1011,'Nurul Islam','1995-12-08','Ab Positive',01915478956,'Norshingdi',2),
	   (1012,'Anower Hossen','1998-12-09','A Positive',01878365487,'Chittogram',5),
	   (1013,'Fatiha','1998-06-06','A Positive',01915457896,'Jashore',2),
	   (1014,'Masum Billah','2000-04-09','O Positive',01315254698,'ForidPur',2),
	   (1015,'Shahria Ahmed','1999-01-02','B Positive',01545789698,'Rangpur',2)



Create table  Campus
(
Campusid Int Primary key ,
CampusName varchar(20)
)

Insert Into Campus
Values (1,'Bashundhara'),
	   (2,'Panthopath')


create table MIS (
CampusId Int References Campus(CampusId),
Roll Int  References Students(Roll),
TeacherId int References Teachers(TeacherId),
ActiveStatus Varchar(30)
)

Insert Into MIS
Values (1,1001,1,'Regular'),
	   (1,1002,2,'Regular'),
	   (1,1003,3,'Regular'),
	   (1,1004,3,'Regular'),
	   (2,1005,4,'Irregular'),
	   (2,1006,5,'Regular'),
	   (2,1007,4,'Regular'),
	   (2,1008,5,'Regular'),
	   (1,1009,2,'Regular'),
	   (1,1010,1,'Irregular'),
	   (1,1011,2,'Regular'),
	   (2,1012,5,'Regular'),
	   (1,1013,2,'Irregular'),
	   (1,1014,2,'Regular'),
	   (1,1015,2,'Regular')


Select * From Mis
Select * From Teachers
Select * From Students
Select * From Campus
Select * From Subjects


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

