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

--1. Вывести номера корпусов, если суммарный фонд финансирования расположенных в них кафедр превышает 100000000000000.
--МОЖЛИВО НЕОБХІДНО ВИВЕСТИ НАЗВУ ФАКУЛЬТЕТУ...ІМ'Я КАФЕДРИ УНИКАЛЬНЕ , НЕ МОЖЛИВО ПОРАХУВАТИ СУМИ

select Faculties.Name, Sum(Finansing) as FacultiFinance
from Faculties
join Departmens on Faculties.Id=FacultiID
group by Faculties.Name
having SUM(Finansing)>100000000000000

--2. Вывести названия групп 5-го курса кафедры “Software
--Development”, которые имеют более 10 пар в первую неделю.

--==WHAT======WERE IS SCHEDULE================================================

--3. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) больше, чем рейтинг группы
--“D221”."DOIGIRGW"==>>rating>3

SELECT Groups.Name, sum(Rating) as GroupRating 
from GroupStudents
join Groups on GroupId=Groups.Id
join Students on StudentId=Students.Id
Group by Groups.Name 
having sum(Rating)>(select sum(Rating)
					from GroupStudents
					join Groups on GroupId=Groups.Id
					join Students on StudentId=Students.Id
					where Groups.Name='DOIGIRGW')
-- how make easer===========================================

--4. Вывести фамилии и имена преподавателей, ставка которых
--выше средней ставки профессоров.



--5. Вывести названия групп, у которых больше одного куратора.
--6. Вывести названия групп, имеющих рейтинг (средний рейтинг всех студентов группы) меньше, чем минимальный
--рейтинг групп 5-го курса.
--7. Вывести названия факультетов, суммарный фонд финансирования кафедр которых больше суммарного фонда
--финансирования кафедр факультета “Computer Science”.
--8. Вывести названия дисциплин и полные имена преподавателей, читающих наибольшее количество лекций по ним.
--9. Вывести название дисциплины, по которому читается
--меньше всего лекций.
--10. Вывести количество студентов и читаемых дисциплин на
--кафедре “Software Development”.
