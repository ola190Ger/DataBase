create database DZ7
use DZ7
--====================================================
-- create table
--====================================================
create table Teachers(
Id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Surname nvarchar(max) not null check(Surname!='')
)

create table Assistants(
Id int identity not null primary key,
TeacherId int not null references Teachers(Id)
)

create table Curators(
Id int identity not null primary key,
TeacherId int not null references Teachers(Id)
)

create table Deans(
Id int identity not null primary key,
TeacherId int not null references Teachers(Id)
)

create table Faculties(
Id int identity not null primary key,
Building int not null check(Building>=1 and Building<=5),
Name nvarchar(100) not null check(Name!='') unique,
DeanId int not null references Deans(Id)
)

create table Subjects(
Id int identity not null primary key,
Name nvarchar(30) not null check(Name!='') unique,
)

create table Heads(
Id int identity not null primary key,
TeacherId int not null references Teachers(Id),
)

create table Departments(
Id int identity not null primary key,
Building int not null check(Building>=1 and Building<=5),
Name nvarchar(100) not null check(Name!='') unique,
FacultyId int not null references Faculties(Id),
HeadId int not null references Heads(Id)
)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Years int not null check(Years>=1 and Years<=5),
DepartmentId int not null references Departments(Id)
)

create table GroupsCurators(
Id int identity not null primary key,
CuratorId int not null references Curators(Id),
GroupId int not null references Groups(Id)
)

create table Lectures(
Id int identity not null primary key,
SubjectId int not null references Subjects(Id),
TeacherId int not null references Teachers(Id)
)

create table GroupsLectures(
Id int identity not null primary key,
LectureId int not null references Lectures(Id),
GroupId int not null references Groups(Id)
)

create table LectureRooms(
Id int identity not null primary key,
Building int not null check(Building>=1 and Building<=5),
Name nvarchar(10) not null check(Name!='') unique,
)

create table Schedules(
Id int identity not null primary key,
Class int not null check(Class>=1 and Class<=8),
DayOfWeek int not null check(DayOfWeek>=1 and DayOfWeek<=7),
Week int not null check(Week>=1 and Week<=52),
LectureId int not null references Lectures(Id),
LectureRoomId int not null references LectureRooms(Id),
)

--======================================================
--Queries
--======================================================
--1. ¬ывести названи€ аудиторий, в которых читает лекции
--преподаватель УDwayne DiazФ.
select LectureRooms.Name
	from LectureRooms, Schedules, Lectures, Teachers
		where LectureRoomId=LectureRooms.Id and LectureId=Lectures.Id and TeacherId=Teachers.Id
					and Teachers.Name+' '+Teachers.Surname='Dwayne Diaz'
--2. ¬ывести фамилии ассистентов, читающих лекции в группе
--УF505Ф.
select Teachers.Surname
	from Teachers, Assistants, Lectures, GroupsLectures, Groups
	where Assistants.TeacherId=Teachers.Id and LectureId=Lectures.Id and GroupId=Groups.Id and Lectures.TeacherId=Teachers.Id
	and Assistants.Id is not null and Groups.Name='OO'
--3. ¬ывести дисциплины, которые читает преподаватель УDwayne DiazФ дл€ групп 5-го курса.
select Subjects.Name
	from Teachers, Subjects, Lectures
	where TeacherId=Teachers.Id and SubjectId=Subjects.Id 
		and Concat(Teachers.Name,' ', Teachers.Surname)='Dwayne Diaz'
		group by Subjects.Name
--4. ¬ывести фамилии преподавателей, которые не читают
--лекции по понедельникам.
select Concat(Teachers.Name,' ', Teachers.Surname) as Teacher, 
		(case CEILING(DayOfWeek) when 2 then 'Tue' 
								 when 3 then 'Wed'
								 when 4 then 'Thu'
								 when 5 then 'Fri'
								 when 6 then 'Sat'
								 when 7 then 'Sun' 
								 end) as day
from Teachers,Lectures,Schedules
where TeacherId=Teachers.Id and LectureId=Lectures.Id and DayOfWeek!='1'

--5. ¬ывести названи€ аудиторий, с указанием их корпусов,
--в которых нет лекций в среду второй недели на третьей
--паре.
select LectureRooms.Name as Room, Building as BuildingNumber
	from LectureRooms, Schedules
	where LectureRoomId=LectureRooms.Id and DayOfWeek!='3' and Week!='2' and Class!='3'
--6. ¬ывести полные имена преподавателей факультета УComputer
--ScienceФ, которые не курируют группы кафедры УSoftware
--DevelopmentФ.
select CONCAT(Teachers.Name, ' ' , Teachers.Surname) as teacher
	from Teachers, Curators, GroupsCurators, Groups, Departments, Faculties
	where TeacherId=Teachers.Id and GroupId=Groups.Id and DepartmentId=Departments.Id
		and FacultyId=Faculties.Id and CuratorId=Curators.Id
		and Faculties.Name='Computer Science' and Departments.Name!='Software Development'

--7. ¬ывести список номеров всех корпусов, которые имеютс€
--в таблицах факультетов, кафедр и аудиторий.

Select DISTINCT Departments.Building as Departments_Building,
		 Faculties.Building as Facultiet_Building, 
		LectureRooms.Building as LecturesRoom_Building
from Faculties  cross join  Departments cross join LectureRooms


--8. ¬ывести полные имена преподавателей в следующем пор€дке: 
--деканы факультетов, заведующие кафедрами, преподаватели, кураторы, ассистенты.
select '1. Dean' as Position,  Teachers.Name+' '+Teachers.Surname as Teacher from Teachers join Deans as d on d.TeacherId=Teachers.Id
union
select '2. Head', Teachers.Name+' '+Teachers.Surname from Teachers join Heads as h on h.TeacherId=Teachers.Id
union
select '3. Lecture', Teachers.Name+' '+Teachers.Surname from Teachers join Lectures as l on l.TeacherId=Teachers.Id
union
select '4. Curator', Teachers.Name+' '+Teachers.Surname from Teachers join Curators as c on c.TeacherId=Teachers.Id
union
select '5. Assistant', Teachers.Name+' '+Teachers.Surname from Teachers join Assistants as a on a.TeacherId=Teachers.Id

 
--9. ¬ывести дни недели (без повторений), в которые имеютс€
--зан€ти€ в аудитори€х УA311Ф и УA104Ф корпуса 6.
Select distinct (case CEILING(DayOfWeek) 
								 when 1 then 'Mon'
								 when 2 then 'Tue' 
								 when 3 then 'Wed'
								 when 4 then 'Thu'
								 when 5 then 'Fri'
								 when 6 then 'Sat'
								 when 7 then 'Sun' 
								 end) as 'Day of week'
								 --,LectureRooms.Name as Class
	from Schedules join LectureRooms on LectureRoomId=LectureRooms.Id and Building=4
	where LectureRooms.Name like 'O%' or LectureRooms.Name like 'B%'