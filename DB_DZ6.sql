create database DZ62

use DZ62

create table Curators
(
id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Surname nvarchar(max) not null Check(Surname!='')
)

create table Faculties(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique
)

create table Departmens(
Id int identity not null primary key,
Building int not null check(Building>1 and Building<5),
Finansing money not null check(Finansing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique,
FacultiID int not null references Faculties(Id)
)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Year int not null check(Year>0 And Year<6),
DepartmentId int  not null references Departmens(Id)
)

Create table GroupsCurators(
Id int identity not null primary key,
CuratorId int not null references Curators(Id),
GroupId int not null references Groups(Id)
)

create table Subjects(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique,
)

create table Teachers(
Id int identity not null primary key,
IsProfessor bit not null default 0,
Name nvarchar(max) not null check(Name!=''),
Salary money not null check(Salary>=0),
Surname nvarchar(max) not null check(Surname!='')
)

create table Lectures(
Id int identity not null primary key,
SubjectId int not null references Subjects(Id),
TeacherId int not null references Teachers(Id)
)

Create table GroupsLectures(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
LecturedId int not null references Lectures(Id)
)

create table Students(
Id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Rating int not null check(Rating>0 and Rating<=5),
Surname nvarchar(max) not null check(Surname!='')
)

create table GroupStudents(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
StudentId int not null references Students(Id)
)
