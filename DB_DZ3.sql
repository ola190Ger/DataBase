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
Rating int not null check(Rating >=1 and Rating<=5),
Year int not null check(Year >=1 and Year<=5),
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
--3.Вывести для преподавателей их фамилию, процент ставки по отношению к надбавке и процент ставки по отношению к зарплате (сумма ставки и надбавки). 
 select Surname as 'Surname',
		Salary/Premium*100 as 'Percent 1st',
		Salary/(Salary+Premium)*100 as 'Percent 2nd'
	from Teacher
--4.Вывести таблицу факультетов в виде одного поля в следующем формате: “The dean of faculty [faculty] is [dean].”.
select '"The dean of faculty '+Name+' is '+Dean+'."' as DeanFaculti from Faculties
--5.Вывести фамилии преподавателей, которые являются профессорами и ставка которых превышает 1050. 
Select Surname from Teacher where IsProfessor=1  and Salary>1050000
--6.Вывести названия кафедр, фонд финансирования которых меньше 11000 или больше 25000. 
Select Name from Departments where Financing >20000000000000 and Financing<25000000000000
--7.  Вывести названия факультетов кроме факультета “R”. 
Select Name from Departments where Name!='R'
--8. Вывести фамилии и должности преподавателей, которые не являются профессорами.
Select Name, Position from Teacher where IsProfessor!=1
--9.Вывести фамилии, должности, ставки и надбавки ассистентов, у которых надбавка в диапазоне от 160 до 550.(16000000000000-55000000000000)
Select Surname, Position, Salary, Premium from Teacher where Premium>16000000000000 and Premium<55000000000000
--10. Вывести фамилии и ставки ассистентов. 
Select Surname, Salary from Teacher where IsAssistent=1
--11.Вывести фамилии и должности преподавателей, которые были приняты на работу до 01.01.2000.
Select Surname, Position from Teacher where EmploymentDate<'2000-01-01'
--12.Вывести названия кафедр, которые в алфавитном порядке располагаются до кафедры “PRIPJJTYXTVNE”. Выводимое поле должно иметь название “Name of De part ment”. 
Select Name as 'Name of De part ment' from Departments
where Name<'PRIPJJTYXTVNE'
--13.Вывести фамилии ассистентов, имеющих зарплату (сумма ставки и надбавки) не более 1200.12000000000000
Select Surname from Teacher where (Salary+Premium)<12000000000000
--14. Вывести названия групп 5-го (3-го) курса, имеющих рейтинг в диапазоне от 2 до 4.
Select Name, Year from Groups where Year=3 and Rating>=2 and Rating<=4
--15. Вывести фамилии ассистентов со ставкой меньше 55000000000000 или надбавкой меньше 20000000000000. 
Select Surname from Teacher where Salary<55000000000000 or Premium<20000000000000



