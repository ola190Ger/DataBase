create database DZ6

use DZ6

create table Curators
(
id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Surname nvarchar(max) not null Check(Name!='')
)

create table Faculties(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique
)

-----------------------------------------------------
Create table GroupsLectures-- create here------------
-----------------------------------------------------

Create table GroupsCurators(
Id int identity not null primary key
CuratorId int not null references Curators(Id)
)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Year int not null check(Year>1 And Year<5),
DepartmentId int  not null references Departments(Id)
)

create table Departmens(
Id int identity not null primary key,
Building int not null check(Building>1 and Building<5),
Finansing money not null check(Finansing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique,
FacultiID int not null refrences Faculties(Id)
)