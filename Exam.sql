CREATE DATABASE BookShop
GO
USE BookShop

CREATE TABLE Countries(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(50) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Themes(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(100) NOT NULL UNIQUE CHECK(Name != '')
)

CREATE TABLE Authors(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Surname nvarchar(max) NOT NULL CHECK(Surname != ''),
  CountryId int NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Books(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  Pages int NOT NULL CHECK(Pages > 0),
  Price money NOT NULL CHECK(Price !< 0),
  PublishDate date NOT NULL CHECK(PublishDate !> GETDATE()),
  AuthorId int NOT NULL FOREIGN KEY REFERENCES Authors(Id),
  ThemeId int NOT NULL FOREIGN KEY REFERENCES Themes(Id)
)

CREATE TABLE Shops(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Name nvarchar(max) NOT NULL CHECK(Name != ''),
  CountryId int NOT NULL FOREIGN KEY REFERENCES Countries(Id)
)

CREATE TABLE Sales(
  Id int NOT NULL IDENTITY PRIMARY KEY,
  Price money NOT NULL CHECK(Price !< 0),
  Quantity int NOT NULL CHECK(Quantity > 0),
  SaleDate date NOT NULL CHECK(SaleDate !> GETDATE()) DEFAULT GETDATE(),
  BookId int NOT NULL FOREIGN KEY REFERENCES Books(Id),
  ShopId int NOT NULL FOREIGN KEY REFERENCES Shops(Id)
)

--1. Показать все книги, количество страниц в которых больше 500, но меньше 650. 

select *
from Books
where Books.Pages between 50000 and 65000
--2. Показать все книги, в которых первая буква названия либо «А», либо «З».

select Authors.Name+' '+Authors.Surname as Autor, Books.Name as Book
from Books join Authors on AuthorId=Authors.Id
where Books.Name like 'A%' or Books.Name like 'Z%'

--3. Показать все книги жанра «Детектив», количество проданных книг более 30 экземпляров BYCKLOUSPHJP.

select *
from Books join Themes on ThemeId=Themes.Id
		join Sales on BookId=Books.Id and Quantity>300000
where Themes.Name='BYCKLOUSPHJP'


--4. Показать все книги, в названии которых есть слово 'Mar' «Micro soft», но нет слова «Windows».'Mark'

Select *
from Books
where Books.Name like '%Mar%' and Books.Name not like '%mark%'


--5. Показать все книги (название, тематика, полное имя автора в одной ячейке), цена одной страницы которых меньше 65 копеек. 176 871 266,6253(Marvin)

select '"'+ Books.Name+'"'as Book, Authors.Name+' '+Authors.Surname as Author, Themes.Name as 'Book Author Theme'
from Books join Authors on AuthorId=Authors.Id and Price/Pages<=176871267
	join Themes on ThemeId=Themes.Id
order by Books.Name


--6. Показать все книги, название которых состоит из 4 слов. 

select *
from Books
where Books.Name like '% % % %'


--7. Показать информацию о продажах в следующем виде: 
--▷Название книги, но, чтобы оно не содержало букву «А». 
--▷Тематика, но, чтобы не «Программирование». 
--▷Автор, но, чтобы не «Герберт Шилдт».
--▷Цена, но, чтобы в диапазоне от 10 до 20 гривен.
--▷Количество продаж, но не менее 8 книг. 
--▷Название магазина, который продал книгу, но он не должен быть в Украине или России.

select Books.Name as Book, Themes.Name as Theme, Authors.Name+' '+Authors.Surname as Authors, Sales.Price as Price, Sales.Quantity as 'QuantitySales', Shops.Name as Shop
from Books join Sales on BookId=Books.Id and Books.Name not like '%a%' and Sales.Quantity>300000 
		join Themes on ThemeId=Themes.Id and Themes.Name not like 'k%'
		join Authors on AuthorId=Authors.Id and Authors.Name!=' San Diego Francisco' and Authors.Name!='Isabelle Maria Gersya Markes'
		join Shops on ShopId=Shops.Id
		join Countries on Shops.CountryId=Countries.Id and Countries.Name!='AUYYXTIDE' and Countries.Name!='BEGETRG'
where Sales.Price between 61974566458711  and	73366779076573


--8. Показать следующую информацию в два столбца (числа в правом столбце приведены в качестве примера): 
--▷Количество авторов: 14 
--▷Количество книг: 47 
--▷Средняя цена продажи: 85.43 грн. 
--▷Среднее количество страниц: 650.6. 

select 'CountAuthors' as Count, Count(Authors.Name) as Value from Authors 
union
select 'Count Books', COUNT(Books.Name)  from Books
--union
--select 'AVG price', AVG(Sales.Price)  from Sales
union
select 'AVG pages', AVG(Books.Pages) from Books



--9. Показать тематики книг и сумму страниц всех книг по каждой из них. 
select Themes.Name as Book, Sum(Books.Pages)
from Books 
	join Themes on ThemeId=Themes.Id
group by Themes.Name

--10. Показать количество всех книг и сумму страниц этих книг по каждому из авторов.

select Authors.Name+' '+Authors.Surname as Author, count(Books.Name) as Book, Sum(Books.Pages) as [Book`s pages]
from Books, Authors 
where AuthorId=Authors.Id	
group by Authors.Name, Authors.Surname

--11. Показать книгу тематики «Программирование» с наибольшим количеством страниц. 
select top 1 Books.Name 
from Books, Themes 
Where ThemeId=Themes.Id and Themes.Name='c'
order by Books.Pages


--12. Показать среднее количество страниц по каждой тематике, которое не превышает 400. 

select Themes.Name as Theme, Avg(Books.Pages)
from Themes, Books 
where ThemeId=Themes.Id 
group by Themes.Name
having Avg(Books.Pages)<400000


--13. Показать сумму страниц по каждой тематике, учитывая только книги с количеством страниц более 400, 
--и чтобы тематики были «Программирование», «Администрирование» и «Дизайн». 

select TM.Theme,TM.SumPages
from
(select Themes.Name as Theme , Sum(Books.Pages) as SumPages
	from Themes, Books where ThemeId=Themes.Id and Books.Pages>400000 group by Themes.Name) as TM
where TM.Theme = 'C'or TM.Theme ='EM'or TM.Theme = 'MCNM'

--14. Показать информацию о работе магазинов: что, где, кем, когда и в каком количестве было продано.
select Books.Name as 'What', 
	Countries.Name as 'Where',
		Shops.Name as 'Who', 
			Sales.SaleDate as 'When', 
				Sales.Quantity as 'How much'
from Books join Sales on BookId=Books.Id
	join Shops on ShopId=Shops.Id
	join Countries on CountryId=Countries.Id

--15. Показать самый прибыльный магазин.
select top 1 Shops.Name, Sum(Cast(Sales.Price as decimal) *Sales.Quantity) as Summa
from Sales, Shops
where ShopId=Shops.Id 
group by Shops.Name
order by Sum(Cast(Sales.Price as decimal) *Sales.Quantity) desc

