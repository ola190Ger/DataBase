CREATE DATABASE Hosp1

GO

USE Hosp1

CREATE TABLE Examinations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Doctors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Surname nvarchar(max) NOT NULL CHECK(Surname != ''),
  Salary money NOT NULL CHECK(Salary > 0),
  Premium money NOT NULL CHECK(Premium !< 0) DEFAULT 0
)

CREATE TABLE Departments(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != ''),
  Building int NOT NULL CHECK(Building BETWEEN 1 AND 5)
)

CREATE TABLE Wards(
  Id int IDENTITY NOT NULL PRIMARY KEY,
  Name nvarchar(20) NOT NULL UNIQUE CHECK(Name != ''),
  Places int NOT NULL CHECK(Places !< 1),
  DepartmentId int NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE DoctorsExaminations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  StartTime time NOT NULL CHECK(StartTime BETWEEN '08:00:00' AND '18:00:00'),
  EndTime time NOT NULL,
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id),
  ExaminationId int NOT NULL FOREIGN KEY REFERENCES Examinations(Id),
  WardId int NOT NULL FOREIGN KEY REFERENCES Wards(Id),
  CHECK(EndTime > StartTime)
)

INSERT INTO Departments VALUES
(N'Surgery', 4),
(N'Traumatology', 1),
(N'Pediatrics', 2),
(N'Oncology', 3)

INSERT INTO Doctors VALUES
(N'Jason', N'Nater', 2000, 300),
(N'Andrew', N'Black', 1500, 250),
(N'Nazar', N'Nazarov', 500, 90),
(N'Bill', N'Brown', 3000, 400)

INSERT INTO Examinations VALUES
(N'Fhdjshdd'),
(N'Lhjdjshj'),
(N'Yjdkjsdk'),
(N'Jgdyudhs')

INSERT INTO Wards VALUES
(N'Seven', 40, 3),
(N'Nine', 7, 4),
(N'Three', 150, 2),
(N'Five', 12, 1)

INSERT INTO DoctorsExaminations VALUES
('9:35:00', '11:00:00', 1, 4, 1),
('12:01:00', '13:00:00', 2, 3, 3),
('14:25:57', '16:31:13', 3, 2, 4),
('17:30:00', '17:50:00', 4, 1, 2)

select count(*) as  Palats
from Wards
where Places>10

select d.Name, Count(*) as Palats
from Departments as d, Wards as w
where w.DepartmentId=d.Id
group by d.Name

select d.Building, Count(*) as Palats
from Departments as d, Wards as w
where w.DepartmentId=d.Id
group by d.Building

select d.Name as DepName, Sum(Premium) as SumPremium
from Departments as d, Doctors as doc, DoctorsExaminations as de, Wards as w
where de.DoctorId=doc.Id and de.WardId=w.Id and w.DepartmentId=d.Id
group by d.Name

select d.Name
from Departments as d, Doctors as doc, DoctorsExaminations as de, Wards as w
where de.DoctorId=doc.Id and de.WardId=w.Id and w.DepartmentId=d.Id
group by d.Name
having Count(*)>0

select count(*)as DoctorsSum, Sum(Salary+Premium) as ZP
from Doctors as d

select avg(Salary+Premium) as avgZP
from Doctors as d

select Wards.Name
from Wards
where Places=(select MIN(Places) from Wards)


Select newD.Name 
from Departments as newD, Wards as w 
where Building IN (1,3,7,8)
group by newD.Name, w.Places
having Sum(w.Places)>100 and w.Places>10 

