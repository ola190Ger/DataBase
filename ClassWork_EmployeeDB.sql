create database EmplayDATA
use EmplayDATA
create table Position(
Id int not null identity primary key,
 Name nvarchar(20) not null check(Name!=''),
)

create table Departments(
Id int not null identity primary key,
 Name nvarchar(20) not null check(Name!=''),
)


create table Employees(
Id int not null identity primary key,
Name nvarchar(20) not null check(Name!=''),
Bday date not null check(Bday>'1990-01-01'),
Email nvarchar(20) check(Email!='') unique,
PositionID int references Position(Id),
DepartmensID int references Departments(Id),
HireDate date check(HireDate<convert(date,getdate())),
ManagerID int not null check(ManagerID>0),
LastName nvarchar(20) not null check(LastName!=''),
FirstName nvarchar(20) not null check(FirstName!=''),
MiddleName nvarchar(20) not null check(MiddleName!=''),
Salary money not null check(Salary>0),
BonusPercent money default 0 check(BonusPercent>0)

)

--ЗАДАЧА:
--для каждого отдела вывести последнего принятого сотрудника, если сотрудников нет, то просто вывести название отдела








