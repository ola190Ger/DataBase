--Задание 1. Для базы данных «Спортивный магазин» из
--практического задания модуля «Триггеры, хранимые процедуры и пользовательские функции» создайте следующие
--хранимые процедуры:
use SportShop
--1. Хранимая процедура отображает полную информацию
--о всех товарах

go
create procedure PR_FullInfoGoods as
begin
select * from Goods
end;
 
execute PR_FullInfoGoods

--2. Хранимая процедура показывает полную информацию
--о товаре конкретного вида. Вид товара передаётся в качестве параметра.
--Например, если в качестве параметра
--указана обувь, нужно показать всю обувь, которая есть
--в наличии(Kind2)

go
create procedure PR_FindGood
	@kind nvarchar(max)
as
begin
select * from Goods where Kind=@kind
end;

execute PR_FindGood 'Kind2'

--3. Хранимая процедура показывает топ-3 самых старых клиентов. 
--Топ-3 определяется по дате регистрации

go
create procedure PR_Top3Clients
as
begin
select top 3 * from Clients order by id
end;
--==============TEST===================
execute PR_Top3Clients

--4. Хранимая процедура показывает информацию о самом
--успешном продавце. Успешность определяется по общей
--сумме продаж за всё время
go
create procedure PR_BestEmployee
as
begin
select top 1 Employees.Name, SUM(SellPrice*Amount) from Employees, Sells where EmployeeId=Employees.Id group by Employees.Name
end;

execute PR_BestEmployee

--5. Хранимая процедура проверяет есть ли хоть один товар
--указанного производителя в наличии. Название производителя передаётся в качестве параметра. 
--По итогам работы
--хранимая процедура должна вернуть yes в том случае, если
--товар есть, и no, если товара нет

go
create procedure PR_GoodExists
	@Manufactur nvarchar(max)
as
begin 
if (select sum(Amount) from Goods where Manufacturer=@Manufactur)>0
print'YES. Goods manufacturer "'+@Manufactur+'" are available.'
else
print 'NO. Goods manufacturer "'+@Manufactur+'" ended.'
end;

execute PR_GoodExists 'Manuf' 

--6. Хранимая процедура отображает информацию о самом популярном производителе среди покупателей.
--Популярность среди покупателей определяется по общей сумме продаж

go
create procedure PR_BestManufacturer
as
begin
select top 1 Goods.Manufacturer, sum(Sells.SellPrice*Sells.Amount) from Sells, Goods where GoodId=Goods.Id group by Goods.Manufacturer
end;

execute PR_BestManufacturer

--7. Хранимая процедура удаляет всех клиентов, зарегистрированных после указанной даты. Дата передаётся в качестве
--параметра. Процедура возвращает количество удаленных
--записей.

go
create procedure PR_DellClient
	@_Date date --= '2008-09-08'
as
begin
select 
	distinct Sells.ClientId as ClientId, ROW_NUMBER() over(order by ClientId ) as ROW# 
	into #TempTable 
				from Sells where DateOfSelling>@_Date group by ClientId
				select * from #TempTable
declare @CountDelClients int
set @CountDelClients=CAST((select count(ClientId) from #TempTable) as varchar(12))
print 'Deleting' print @CountDelClients
while @CountDelClients>0
	begin
	print 'Delete client'
	delete Clients where Clients.Id=(select ClientId from #TempTable where ROW#=@CountDelClients)
	set @CountDelClients-=1
	end;

end;

--Задание 2. Для базы данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые
--процедуры:
go
use MusicCollection
--1. Хранимая процедура показывает полную информацию о музыкальных дисках

go
create procedure PR_AllInfoDiscs
as
begin
select * from Discs
end;

execute PR_AllInfoDiscs

--2. Хранимая процедура показывает полную информацию
--о всех музыкальных дисках конкретного издателя. Название издателя передаётся в качестве параметра

go
create procedure PR_PublisherDiscs
	@Publisher nvarchar(max)
as
begin
select * from Discs, Publishers where PublisherId=Publishers.Id and Publishers.Name=@Publisher 
end;

execute PR_PublisherDiscs 'Publisher1'

--3. Хранимая процедура показывает название самого популярного стиля. Популярность стиля определяется по 
--количеству дисков в коллекции

go
create procedure PR_BestSyle
as
begin
select top 1 Styles.Name, count(Discs.Id) from Styles, Discs where StyleId=Styles.Id group by Styles.Name order by Count(Discs.Id) desc
end;

execute PR_BestSyle


--4. Хранимая процедура отображает информацию о диске конкретного стиля с наибольшим количеством песен.
--Название стиля передаётся в качестве параметра, если передано слово
--all, анализ идёт по всем стилям
go
create procedure PR_DiscInfoAll
	@Style nvarchar(max)
as
begin
if (@Style='All' or @Style='all' or @Style='ALL')
select Discs.Name as disc, Count(Songs.Id) as countsongs, Styles.Name as Style
	from Discs, Songs, Styles where DiscId=Discs.Id and Discs.StyleId=Styles.Id group by Discs.Name, Styles.Name
else
select Discs.Name as disc, Count(Songs.Id) as countsongs 
	from Discs, Songs, Styles where DiscId=Discs.Id and Discs.StyleId=Styles.Id and Styles.Name=@Style group by Discs.Name
end;

execute PR_DiscInfoAll 'Rock'


--5. Хранимая процедура удаляет все диски заданного стиля.
--Название стиля передаётся в качестве параметра. Процедура
--возвращает количество удаленных альбомов

go
create procedure PR_DiscInfoDelete
	@Style nvarchar(max)
as
begin
if OBJECT_ID('TR_IfDeleteAddInArchive','TR') is not null
begin
drop trigger TR_IfDeleteAddInArchive
end;
delete from Discs
  where Discs.Id in (select Discs.Id from Discs join Styles on StyleId=Styles.Id where  Styles.Name=@Style)
return @@Rowcount
end;

declare @print int 
exec @print= PR_DiscInfoDelete 'Rock'
print @print

--6. Хранимая процедура отображает информацию о самом
--«старом» альбом и самом «молодом». Старость и молодость
--определяются по дате выпуска
go
create procedure PR_OldYangDiscs
as
begin
declare @Min date, @Max date, @_print nvarchar(max),@_print2 nvarchar(max)
set @Min=(Select Min(ReleaseDate) from Discs)
set @Max=(Select Max(ReleaseDate) from Discs)
set @_print= (select top 1 Name from Discs where ReleaseDate=@Min)+' yangest, '
set @_print2=(select top 1 Name from Discs where ReleaseDate=@Max)+' oldest'
print @_print+@_print2
end;

execute PR_OldYangDiscs

--7. Хранимая процедура удаляет все диски в названии которых есть заданное слово. 
--Слово передаётся в качестве
--параметра. Процедура возвращает количество удаленных
--альбомов.
go
create proc PR_DelAllDiscs
	@Slovo nvarchar(max)
as
begin

delete from Discs where Discs.Name like '%'+@Slovo+'%' 
return @@rowcount
end;

declare @DelRow int
exec @DelRow= PR_DelAllDiscs '1/1'
print @DelRow
