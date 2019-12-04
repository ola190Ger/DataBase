Create database DZ32;
Create table Departments
(
Id int NOT NULL IDENTITY primary key,
Financing money not null default 0 check(Financing>0),
Name nvarchar(100) not null unique check(Name!=''),
-- Name не пустое и не null?----
)

Create table Faculties(
Id int identity not null primary key,
Dean nvarchar not null check(Dean!='') ,
Name nvarchar(100) not null unique check(Name!=''),
)

Create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Rating int not null check(Rating >1 and Rating<5),
Year int not null check(Year >1 and Year<5),
)

Create table Teacher (
Id int identity not null primary key,
EmploymentDate date not null check(EmploymentDate>'1900-01-01'),
IsAssistent bit not null default 0 ,
IsProfessor bit not null default 0,
Name nvarchar(max) not null check(Name!=0),
Position nvarchar(max) not null check(Position!=0),
Premium money not null check(Premium<0) default 0,
Salary money not null check(Salary>=0),
Surname nvarchar(max) not null check(Surname!='')
)


--test for name date year---
use [C:\USERS\DELL\DOCUMENTS\DZ3.MDF]
insert into Departments (Financing,Name) values (12,N'a2s'),(22,N'As2');
insert into Teacher(EmploymentDate,IsAssistent, IsProfessor,Name,Position,Premium, Salary,Surname)
			values (1900-11-12,0,1,N'Petye',N'1e1',5.4,125,N'Pet5ov');
insert into Teacher values (1900-11-11,0,1,N'Pety',N'111',5.7,128,N'Petrov');
--