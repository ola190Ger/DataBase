create database DZ4

use DZ4


create Table Faculties(
Id int identity not null primary key,
Financing money not null check(Financing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique
)

create table Curators(
Id int Identity not null primary key ,
Name nvarchar(max) not null check(Name!=''),
Surname nvarchar(max) not null check(Surname!='')
)

create table Departments(
Id int identity not null primary key,
Financing money not null check(Financing>0) default 0,
Name nvarchar(100) not null check(Name!='') unique,
FacultyId int not null references Faculties(Id)

)

create table Groups(
Id int identity not null primary key,
Name nvarchar(10) not null check(Name!='') unique,
Year int not null check(year>=1 and year<=5),
DepartmentId int not null references Departments (Id)
)

create table GroupseCurators(
Id int identity not null primary key,
CuratorId int not null references Curators(Id),
GroupId int not null references Groups(Id)
)

create table Subjects(
Id int identity not null primary key,
Name nvarchar(100) not null check(Name!='') unique
)

create table Teachers(
Id int identity not null primary key,
Name nvarchar(max) not null check(Name!=''),
Salary money not null check(Salary>0),
Surname nvarchar(max) not null check(Surname!='')
)

create table Lectures(
Id int identity not null primary key,
LectureRoom nvarchar(max) not null check(LectureRoom!=''),
SubjectId int not null references Subjects(Id),
TeacherId int not null references Teachers(Id)
)

create table GroupsLectures(
Id int identity not null primary key,
GroupId int not null references Groups(Id),
LecturedId int not null references Lectures(Id)
)

--Fulling in tables-----------------------------
------------------------------------------------

use DZ4
--1. Вывести все возможные пары строк преподавателей и групп.

Select Teachers.Name, Groups.Name
from Teachers
cross join Groups

--2. Вывести названия факультетов, фонд финансирования
--кафедр которых превышает фонд финансирования факультета.

	select (Select Name from Departments
	where Faculties.Id=Departments.Id and Faculties.Financing<Departments.Financing 
	) --way to remove NULL
	from Faculties
  
--3. Вывести фамилии кураторов групп и названия групп, которые они курируют.
select Id,
	(select Name+' '+Surname  from Curators
	where Curators.Id=GroupseCurators.Id) as Curator,
	(select Name from Groups
	where Groups.Id=GroupseCurators.Id) as 'Group'
from GroupseCurators

--4. Вывести имена и фамилии преподавателей, которые читают
--лекции у группы “P107”."OEH"
	Select Teachers.Name +' '+ Surname   
	FROM GroupsLectures 
	join Groups on GroupsLectures.GroupId=Groups.Id 
	join Lectures on GroupsLectures.LecturedId=Lectures.Id 
	join Teachers on Lectures.TeacherId=Teachers.Id
	where Groups.Name='OEH'

--5. Вывести фамилии преподавателей и названия факультетов
--на которых они читают лекции.
  Select Teachers.Surname as SurnameTeacher, Faculties.Name as Facultiet
  from Teachers 
  Join Lectures on TeacherId=Teachers.Id 
  Join GroupsLectures on LecturedId=Lectures.Id
  join Groups on GroupId=Groups.Id
  join Departments on DepartmentId=Departments.Id
  join Faculties on FacultyId=Faculties.Id

--6. Вывести названия кафедр и названия групп, которые к
--ним относятся.
use DZ4
Select 
Faculties.Name as Faculti,
Groups.Name as Groups
from Faculties
full join Departments on Departments.Id=Faculties.Id
full join Groups on Groups.Id=Departments.Id

--7. Вывести названия дисциплин, которые читает преподаватель “Samantha Adams”. Emily Mitchell
Select Subjects.Name, Teachers.Name, Teachers.Surname
from Lectures 
join Subjects on SubjectId=Subjects.Id
join Teachers on TeacherId=Teachers.Id
where Teachers.Name='Emily' and Teachers.Surname='Mitchell'

--8. Вывести названия кафедр, на которых читается дисциплина
--“Database Theory”. YCXP==>BAQZFUGUVPGITYLBNNWKAPPHVBUNXQWWSCPDBEZIMJNNOLKLITBDVUEAFDYEYDYBZGIORMLL
select Departments.Name
from GroupsLectures
join Lectures on LecturedId=Lectures.Id
join Subjects on SubjectId=Subjects.Id
join Groups on GroupId=Groups.Id
join Departments on DepartmentId=Departments.Id
where Subjects.Name='YCXP'

--9. Вывести названия групп, которые относятся к факультету
--“Computer Science”. AVFFM==>IUPQQD
select Faculties.Name as Facultet,
		Groups.Name as Groups
from Faculties
join Departments on Faculties.Id=FacultyId
join Groups on Departments.Id=DepartmentId
--order by Faculties.Name
where Faculties.Name='AVFFM'

--10. Вывести названия групп 5-го курса, а также название факультетов, к которым они относятся.
select Groups.Name as 'Group',
		Faculties.Name as Facultet
from Groups
join Departments on DepartmentId=Departments.Id
join Faculties on FacultyId=Faculties.Id
where Groups.Year=5
order by Groups.Name

--11. Вывести полные имена преподавателей и лекции, которые
--они читают (названия дисциплин и групп), причем отобрать
--только те лекции, которые читаются в аудитории “B103”. 
--Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.

Select 
Teachers.Name+' '+Teachers.Surname as Teacher,
LectureRoom as Room,
Subjects.Name as 'Subject',
Groups.Name as 'Groups'
from GroupsLectures
join Lectures on LecturedId=Lectures.Id
join Subjects on SubjectId=Subjects.Id
join Teachers on TeacherId=Teachers.Id
join Groups on GroupId=Groups.Id
--order by LectureRoom
where LectureRoom='Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt.'










