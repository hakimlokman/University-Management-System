use universityDB
go


Insert into Subjects
Values (1,'English', 32, '4 Years',250000,0.15),
	   (2,'BBA',36,'4 years',330000,0.15),
	   (3,'LLB' ,32,'4 years',300000,0.15),
	   (4,'CSE',40,'4 Years',450000,0.15),
	   (5,'IT',42,'4 years', 420000,0.15)


Insert Into Teachers
Values (1,'Mr. AtiKizzaman','2016-09-22',80000,'Assistant Professor'),
	   (2,'Mr.Harun-or-Rashid','2012-11-19',110000,'Professor'),
	   (3,'Mr. Rakib Mahmud','2020-12-25',60000,'Lecturer'),
	   (4,'Mr Tarikul Islam','2019-01-01',70000,'Associate Professor'),
	   (5,'Mr. Jahidur Rahman','2022-01-30',65000,'Lecturer')


Insert Into Students
Values (1001,'kaniz Fatema','1998-05-18','A Positive',01787458796,'Jashore',1),
	   (1002,'Nazmul Huda','1996-08-08','O Positive',01815879826,'Bogura',2),
	   (1003,'Abdul Kaium','1996-09-25','O positive',01571458796,'Dhaka',3),
	   (1004,'Rashidul Islam','1997-02-13','A Positive',01915789548,'NowaKhali',3),
	   (1005,'Asif kamran','1996-04-19','B Positive',01925478965,'Dhaka',4),
	   (1006,'Hasibul Hasan','1997-09-14','O Positive',01960086635,'Rajshahi',5),
	   (1007,'Toriqul Islam','1996-06-22','AB Positive',01925458796,'Rajshahi',4),
	   (1008,'Habibur Rahman','1994-08-22','A Positive',01515459878,'Feni',5),
	   (1009,'LOkman Hakim','1996-12-30','O Positive',01521204376,'Dhaka',2),
	   (1010,'Yasin ali','1995-05-09','O Negetive',01514569878,'Jashore',1),
	   (1011,'Nurul Islam','1995-12-08','Ab Positive',01915478956,'Rajshahi',2),
	   (1012,'Anower Hossen','1998-12-09','A Positive',01878365487,'Jashore',5),
	   (1013,'Fatiha','1998-06-06','A Positive',01915457896,'Jashore',2),
	   (1014,'Masum Billah','2000-04-09','O Positive',01315254698,'Feni',2),
	   (1015,'Shahria Ahmed','1999-01-02','B Positive',01545789698,Null,2)


Insert Into Campus
Values (1,'Bashundhara'),
	   (2,'Panthopath')


Insert Into MIS
Values (1,1001,1,200000,'Regular'),
	   (1,1002,2,1500000,'Regular'),
	   (1,1003,3,250000,'Regular'),
	   (1,1004,3,200000,'Regular'),
	   (2,1005,4,280000,'Irregular'),
	   (2,1006,5,300000,'Regular'),
	   (2,1007,4,280000,'Regular'),
	   (2,1008,5,400000,'Regular'),
	   (1,1009,2,100000,'Regular'),
	   (1,1010,1,2500000,'Irregular'),
	   (1,1011,2,200000,'Regular'),
	   (2,1012,5,150000,'Regular'),
	   (1,1013,2,210000,'Irregular'),
	   (1,1014,2,300000,'Regular'),
	   (1,1015,2,210000,'Regular')

Select * From Mis
Select * From Teachers
Select * From Students
Select * From Campus
Select * From Subjects

-------------Drop table
Drop Table Mis

----------------------Delete Single row----------
Delete From Teachers Where Teacherid = 2;

----------------Delete All
Delete From Teachers;
--------------------------------------Distinct-------------------------
Select Distinct District , StudentsName, Contact
from Students;

---------------------------------Top Clause---------------------------
Select Top 3 teacherid,TeacherName,Salary
From Teachers
Order by Salary DESC;

--------------------------------------Where Clause-------------------------
Select * 
From Students
Where DOB > '1996-06-01';

--------------------------Logical Operators------------------------------
Select * 
From Students
Where DOB>'1996-06-01' 
or subjectId = 2
And BloodGroup = 'O Positive';

------------------------In Operator----------------------
select *
from Students
Where District in ('Dhaka','Jashore','Satkhira');

Select * 
From Students
Where BloodGroup not in ('O Positive');

---------------------------------Between Operator--------------------
Select * 
From Students
Where DOB Between '1996-01-01' and '1996-12-31';

-----------------------------Like Operators--------------------
Select * 
From Students
Where district Like 'Dha%';

select *
From Students
Where StudentsName Like '[a,e,i,o,u]%';

-------------------------Offset fitch----------------------
select* from Students
order by Roll
OFFSET 0 rows
fetch first 10 rows ONLY;
---------------------------------Sum--------------------
Select TeacherName,JoiningDate,Sum(Salary) as TotalSalary
From Teachers
Group By TeacherName,JoiningDate
Having Sum(Salary) <>0;

-------------------------------Count---------
Select StudentsName,DOB,Contact, Count(District) As NoOfDistict
From Students
where District = 'Dhaka'
Group By StudentsName,DOB,Contact
Having Count(District) <>0;


------------------------------ROLLUP operator----------------------------------
Select District,BloodGroup, Count (*) As NoOfGroup
From Students
Where BloodGroup in ('O positive','A Positive')
Group By District,BloodGroup With ROLLUP
Order By District DESC,BloodGroup DESC;

----------------------------CUBE operator----------------------------------
Select District,BloodGroup, Count (*) As NoOfGroup
From Students
Where BloodGroup in ('O positive','A Positive')
Group By District,BloodGroup With Cube
Order By District DESC,BloodGroup DESC;
--------------------Grouping Sets operator----------------------------------
Select District,BloodGroup, Count (*) As NoOfGroup
From Students
Where BloodGroup in ('O positive','A Positive')
Group By Grouping Sets (District,BloodGroup) 
Order By District DESC,BloodGroup DESC;

-----------------------------------ANY--------------------
Select Students.Roll,StudentsName, ActiveStatus,PaidAmount
From MIS Join Students on Mis.Roll=Students.Roll
Where PaidAmount < Any 
(Select paidAmount From MIS Where Roll = 1004);


-------------------------------ALL-------------------------
Select Students.Roll,StudentsName, ActiveStatus,PaidAmount
From MIS Join Students on Mis.Roll=Students.Roll
Where PaidAmount > All 
(Select paidAmount From MIS Where Roll = 1007);

---------------------------Some-------------------------------
Select Students.Roll,StudentsName, ActiveStatus,PaidAmount
From MIS Join Students on Mis.Roll=Students.Roll
Where PaidAmount < Some 
(Select paidAmount From MIS Where Roll = 1004);

----------------------------------CTE--------------------------------------
With CTE_Summary AS
(Select StudentsName , Dob,Sum(PAidAmount) As SumOfAmount
From Mis join Students on MIS.Roll=Students.Roll
Group By StudentsName , Dob
)
Select * From CTE_Summary;
go

--------------------------------------table join-------------------------------------------
Select Studentsname,SubjectName,Duration,tuitionFee,TeacherName,Status,PaidAmount,ActiveStatus
From Mis Join Students on Mis.Roll=Students.Roll
join Subjects on Students.subjectId=Subjects.SubjectId
join Teachers on Mis.TeacherId=Teachers.TeacherId;

----------------------------------------------Join Quary----------------------------
Select Studentsname,SubjectName,Duration,tuitionFee,TeacherName,Status,PaidAmount,ActiveStatus
From Mis Join Students on Mis.Roll=Students.Roll
join Subjects on Students.subjectId=Subjects.SubjectId
join Teachers on Mis.TeacherId=Teachers.TeacherId
Where  subjectName = 'BBA'
Order by  Studentsname;
-----------------------------Having--------------------------------------
Select Studentsname,SubjectName,Duration,tuitionFee,TeacherName,Status,Sum(PaidAmount) sumOfAmount,ActiveStatus
From Mis Join Students on Mis.Roll=Students.Roll
join Subjects on Students.subjectId=Subjects.SubjectId
join Teachers on Mis.TeacherId=Teachers.TeacherId
Group by Studentsname,SubjectName,Duration,tuitionFee,TeacherName,Status,ActiveStatus
Having Sum(PaidAmount) >200000;

-------------------------------Sub Query------------------------------------------
Select Mis.Roll, StudentsName,SubjectName,TuitionFee,PaidAmount,ActiveStatus
From Mis join Students on Mis.Roll=Students.Roll
join Subjects on Students.subjectId=Subjects.SubjectId
Where Mis.Roll in (Select Roll From Mis Where ActiveStatus = 'Regular');

-------------------Case Function-------------------------------------

Select TeacherName, salary, Status,
case Status
when 'Professor' Then 'Deen'
When 'Assistant Professor' Then 'Co-Deen'
Else 'Teachers'
End As NewStatus
From Teachers;

-------------------------------Ranking Function-------------------------------
select Roll, StudentsName,
ROW_NUMBER() Over(Order By StudentsName) As RowNumber,  
 RANK() Over(Order By StudentsName) As RankNo,
 DENSE_RANk () Over(Order By StudentsName) As Denserank,
 NTILE(2)Over (order By StudentsName) As StudentGroup
 From Students;

 ------------------------------Analytic Function--------------------------------
Select Roll,StudentsName,
First_Value(StudentsName) Over (Order BY Roll) as FirstStudentsName,
Last_Value(StudentsName) Over (Order BY Roll) as LastStudentsName,
LEAD(StudentsName) Over (Order BY Roll) as NextStudent,
LAG(StudentsName) Over (Order BY Roll) as PreviousStudent,
PERCENT_RANK() Over (Order BY StudentsName) as PercentofStudent,
CUME_DIST() Over (Order BY StudentsName) as CumulativeDist,
PERCENTILE_CONT(0.5) Within Group (Order BY roll) Over () as PectStudent,
PERCENTILE_DISC(0.75) Within Group (Order BY Roll) Over () as PttidStudent
From Students;