CREATE DATABASE Hospital_LAB2

GO


USE Hospital_LAB2

CREATE TABLE Examinations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Doctors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Surname nvarchar(max) NOT NULL CHECK(Surname != ''),
  Salary money NOT NULL CHECK(Salary > 0)
)

CREATE TABLE Professors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id)
)

CREATE TABLE Interns(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id)
)

CREATE TABLE Departments(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != ''),
  Building int NOT NULL CHECK(Building BETWEEN 1 AND 5),
  Financing money NOT NULL CHECK(Financing !< 0) DEFAULT 0
)

CREATE TABLE Wards(
  Id int IDENTITY NOT NULL PRIMARY KEY,
  Name nvarchar(20) NOT NULL UNIQUE CHECK(Name != ''),
  Places int NOT NULL CHECK(Places !< 1),
  DepartmentId int NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE Diseases(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE DoctorsExaminations(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Date date NOT NULL CHECK(Date !> GETDATE()) DEFAULT GETDATE(),
  DiseaseId int NOT NULL FOREIGN KEY REFERENCES Diseases(Id),
  DoctorId int NOT NULL FOREIGN KEY REFERENCES Doctors(Id),
  ExaminationId int NOT NULL FOREIGN KEY REFERENCES Examinations(Id),
  WardId int NOT NULL FOREIGN KEY REFERENCES Wards(Id)
)

----------------------------------------------------------

INSERT INTO Departments VALUES
(N'General Surgery', 4, 32312),
(N'Physiotherapy', 3, 78675),
(N'Microbiology', 2, 89423),
(N'Ophthalmology', 5, 32132),
(N'Oncology', 5, 41223),
(N'Neurology', 1, 65412)

INSERT INTO Doctors VALUES
(N'Thomas', N'Gerada', 2000),
(N'Anthony', N'Davis', 1500),
(N'Joshua', N'Bell', 500),
(N'Bill', N'Brown', 3000),
(N'Ivan', N'Ivanov', 1700)

INSERT INTO Examinations VALUES
(N'Fhdjshdd'),
(N'Lhjdjshj'),
(N'Yjdkjsdk'),
(N'Jgdyudhs')

INSERT INTO Wards VALUES
(N'Seven', 40, 3),
(N'Nine', 7, 4),
(N'Three', 150, 6),
(N'Five', 12, 2)

INSERT INTO Diseases VALUES
(N'Flu'),
(N'Measles'),
(N'Diphtheria'),
(N'Diabetes'),
(N'Cancer')

INSERT INTO DoctorsExaminations VALUES
(DEFAULT, 2, 4, 2, 2),
('2018-12-19', 1, 1, 3, 3),
(DEFAULT, 1, 3, 2, 4),
('2007-07-07', 4, 4, 1, 2)

INSERT INTO Professors VALUES
(1),
(3)

INSERT INTO Interns VALUES
(4),
(2)


select Wards.Name, Places
from Wards 
	join Departments on Wards.DepartmentId=Departments.Id 
	and Wards.Places>5 
	and exists(Select * from Wards where Places>15)
where Building IN(5) 

Select Departments.Name
from Departments
	join Wards on DepartmentId=Departments.Id
	join DoctorsExaminations on WardId=Wards.Id and Date between getDate()-7 and GETDATE()

select Diseases.Name   --,Examinations.Name
from Diseases 
	full join DoctorsExaminations on DiseaseId=Diseases.Id 
	full join Examinations on ExaminationId=Examinations.Id 
where Examinations.Name is null

select Distinct Doctors.Name+' '+Doctors.Surname as FullDocName
from Doctors full join DoctorsExaminations on DoctorId=Doctors.Id
where ExaminationId is null

select Departments.Name
from Departments full join Wards on DepartmentId=Departments.Id
	full join DoctorsExaminations on WardId=Wards.Id
where ExaminationId is null

select Distinct Doctors.Name+' '+Doctors.Surname
from Doctors full join Interns on DoctorId=Doctors.Id 
where DoctorId is not null

select Distinct Doctors.Surname
from Doctors  full join Interns on DoctorId=Doctors.Id
where Salary>=(
		Select Max(Salary) from Doctors  full join Interns on DoctorId=Doctors.Id where DoctorId is null)

select Wards.Name 
from Departments join Wards on DepartmentId=Departments.Id 
where Places > 
	(select MAX(Places)
		from Departments join Wards on DepartmentId=Departments.Id and Building in (3))

select Distinct Doctors.Surname
from Wards Full join Departments on DepartmentId=Departments.Id
	full join DoctorsExaminations on WardId=Wards.Id
	full join Doctors on DoctorId=Doctors.Id
where ExaminationId is not null and Departments.Name in('Ophthalmology','Physiotherapy')

select *-- ÍÅÒ ÍÈÊÎÃÎ???
from Doctors 
	full join Interns as i on i.DoctorId=Doctors.Id
	full join Professors as p on p.DoctorId=Doctors.Id
	full join DoctorsExaminations as DE on DE.DoctorId=Doctors.Id
	full join Wards as W on WardId=W.Id
	full join Departments as DP on W.DepartmentId=DP.Id
where i.Id is not null and p.Id is not null

select Distinct  Doctors.Name+' '+Doctors.Surname as FullName
from Doctors
	 join DoctorsExaminations as DE on DE.DoctorId=Doctors.Id
	 join Wards as W on WardId=W.Id
	 join Departments as DP on W.DepartmentId=DP.Id
where DP.Financing>20000

select Distinct DP.Name
from Doctors
	 join DoctorsExaminations as DE on DE.DoctorId=Doctors.Id
	 join Wards as W on WardId=W.Id
	 join Departments as DP on W.DepartmentId=DP.Id
where Salary>=(select Max(Salary)from Doctors)

select Diseases.Name, Count(ExaminationId) as CountEXAM
from DoctorsExaminations 
	full join Diseases on DiseaseId=Diseases.Id 
group by Diseases.Name
having Count(ExaminationId)>0