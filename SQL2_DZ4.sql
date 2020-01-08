--Задание 1. Для базы данных «Спортивный магазин» из
--практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие
--пользовательские функции:
use SportShop
--1. Пользовательская функция возвращает количество уникальных покупателей
go
create function FU_CountUniqueName()
returns int
--@Tableforname table( 
--Name nvarchar(30) not null,
--Surname nvarchar(30) not null)
as
begin
declare @rezult int
set @rezult= (select Count(distinct Name) from Clients)
return @rezult
end;
go

print dbo.FU_CountUniqueName()
--2. Пользовательская функция возвращает среднюю цену товара конкретного вида. Вид товара передаётся в качестве
--параметра. Например, среднюю цену обуви
go
create function FN_AVGPrice(@kind nvarchar(max))
returns dec(16,2)
as
begin
declare @rezult dec
set @rezult= (select AVG(SellPrice) from Goods where Kind= @kind)
return @rezult
end;
go

print dbo.FN_AVGPrice('55')
go 
--3. Пользовательская функция возвращает среднюю цену
--продажи по каждой дате, когда осуществлялись продажи
create function FN_AVGPriceSells(@dateSell date)
returns dec(16,2)
as
begin
declare @rezult dec
set @rezult= (select AVG(SellPrice) from Sells where DateOfSelling=@dateSell group by DateOfSelling)
return @rezult
end;
go

print dbo.FN_AVGPriceSells('2020-01-05')
--4. Пользовательская функция возвращает информацию о последнем проданном товаре. 
--Критерий определения последнего проданного товара: дата продажи

go
create function FN_LastSellGood()
returns @lastSell table (
GoodId int not null,
SellPrice money not null,
Amount int not null,
DateOfSell date not null,
EmployeeID int not null,
ClientId int not null
)
as
begin
insert into @lastSell(GoodId, SellPrice, Amount, DateOfSell, EmployeeID, ClientId)
select GoodId, SellPrice, Amount, DateOfSelling, EmployeeID, ClientId 
	from Sells where DateOfSelling= (select Max(DateOfSelling)from Sells)
return 
end;
go

select * from FN_LastSellGood()
--5. Пользовательская функция возвращает информацию о первом проданном товаре. Критерий определения первого
--проданного товара: дата продажи
go
create function FN_FirstSellGood()
returns @firstSell table (
GoodId int not null,
SellPrice money not null,
Amount int not null,
DateOfSell date not null,
EmployeeID int not null,
ClientId int not null
)
as
begin
insert into @firstSell(GoodId, SellPrice, Amount, DateOfSell, EmployeeID, ClientId)
select GoodId, SellPrice, Amount, DateOfSelling, EmployeeID, ClientId 
	from Sells where DateOfSelling= (select Min(DateOfSelling)from Sells)
return 
end;
go

select * from FN_FirstSellGood()
--6. Пользовательская функция возвращает информацию о заданном виде товаров конкретного производителя. Вид
--товара и название производителя передаются в качестве
--параметров
go
create function FN_GoodInfo(@kind nvarchar(max), @manuf nvarchar(max))
returns @tmptable table (
Id int not null,
Name nvarchar(30) not null,
Kind nvarchar(30) not null,
Amount int not null,
CostPrice money not null,
Manufacturer nvarchar(30) not null,
SellPrice money not null
)
as
begin
insert into @tmptable(Id, Name, Kind, Amount, CostPrice, Manufacturer, SellPrice)
select Id, Name, Kind, Amount, CostPrice, Manufacturer, SellPrice 
	from Goods where Kind=@kind and Manufacturer=@manuf
return 
end;
go

select * from FN_GoodInfo('Kind1', 'Manuf1')

--7. Пользовательская функция возвращает информацию о покупателях, которым в этом году исполнится 45 лет

alter table dbo.Clients
add BirthDay date null
--declare @begin date, @end date
--set @begin = '1920-01-01'
--set @end = '2020=01-01'
--update dbo.Clients set BirthDay = (select cast((cast(@begin) as float) + cast(@end  - @begin )as float) as date * rand() as datetime) as [date]) ;
update Clients 
set BirthDay = (SELECT DATEADD(DAY, FLOOR(rand((SELECT DATEPART(MICROSECOND, SYSDATETIMEOFFSET() )) )*23000), '1920-01-01'));


go
create function FN_ClientInfo(@age int)
returns @tmptable table (
Id int not null,
Name nvarchar(30) not null,
Email nvarchar(30) not null,
Phone nvarchar(30) not null,
Discount int not null,
BirthDay date not null
)
as
begin
insert into @tmptable(Id, Name,Email,Phone,Discount,BirthDay)
select Id, Name,Email,Phone,Discount,BirthDay from Clients where (BirthDay>dateadd(day,-(@age+1)*365, sysdatetime()) and BirthDay<dateadd(day,-(@age-1)*365, sysdatetime()))
return;
end;


select * from FN_ClientInfo(45)

--Задание 2. Для базы данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие пользовательские функции:
--1. Пользовательская функция возвращает все диски заданного
--года. Год передаётся в качестве параметра
--2. Пользовательская функция возвращает информацию
--о дисках с одинаковым названием альбома, но разными
--исполнителями
--3. Пользовательская функция возвращает информацию о всех
--песнях в чьем названии встречается заданное слово. Слово
--передаётся в качестве параметра
--4. Пользовательская функция возвращает количество альбомов в стилях hard rock и heavy metal
--5. Пользовательская функция возвращает информацию о средней длительности песни заданного исполнителя. Название
--исполнителя передаётся в качестве параметра
--6. Пользовательская функция возвращает информацию о самой долгой и самой короткой песне
--7. Пользовательская функция возвращает информацию об
--исполнителях, которые создали альбомы в двух и более
--стилях.