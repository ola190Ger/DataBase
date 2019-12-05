Create database DZ32;

use DZ32;


--создание таблиц---------
---------------------------------------------------------------
Create table Departments
(
Id int NOT NULL IDENTITY primary key,
Financing money not null default 0 check(Financing>0),
Name nvarchar(100) not null unique check(Name!=''),
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
Name nvarchar(100) not null check(Name!=''),
Position nvarchar(150) not null check(Position!=''),
Premium money not null check(Premium>0) default 0,
Salary money not null check(Salary>0),
Surname nvarchar(100) not null check(Surname!='')
)
---------------------------------------------------------------
drop table Teacher
--заполнение сApex---------------------------------------------
---------------------------------------------------------------
use DZ32;
 --Вывести таблицу кафедр, но расположить ее поля в обратном порядке. 
 select * from Departments order by Id desc
 --Вывести названия групп и их рейтинги, используя в качестве названий выводимых полей “Group Name” и “Group Rating” соответственно. 
 select Name as 'Group Name', Rating as 'Group Rating' from Groups 
 --Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки). 
 select Surname as 'Surname',
		PERCENT_RANK(Salary/(Salary+Premium) as 
