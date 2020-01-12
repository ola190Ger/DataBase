--Задание 1. Создайте следующие хранимые процедуры:
use DBForTesting
--1. Хранимая процедура выводит «Hello, world!»

go
create procedure PR_HelloName
as
begin

print 'Hello world!!!'
end;

exec dbo.PR_HelloName
--2. Хранимая процедура возвращает информацию о текущем
--времени
go
create proc PR_TimeNow as
begin
print convert(time, sysdatetime())
end;

exec PR_TimeNow
	      
--3. Хранимая процедура возвращает информацию о текущей
--дате
go
create proc PR_DateNow as
begin
print convert(date, sysdatetime())
end;

exec PR_DateNow
--4. Хранимая процедура принимает три числа и возвращает
--их сумму
go
create proc PR_Summa(@a int, @b int,@c int) as
begin
print @a+@b+@c
end;

exec PR_Summa 1,2,3
--5. Хранимая процедура принимает три числа и возвращает
--среднеарифметическое трёх чисел
go
create proc PR_AVG3(@a int, @b int,@c int) as
begin
print (@a+@b+@c)/3
end;

exec PR_AVG3 1,2,3
--6. Хранимая процедура принимает три числа и возвращает
--максимальное значение
go
create proc PR_Max3(@a int, @b int,@c int) as
begin
declare @tmp table (num int)
declare @rez int
insert into @tmp (num) values (@a), (@b), (@c)
set @rez =(select Max(num) from @tmp)
print @rez
end;

exec PR_Max3 1,2,3

--7. Хранимая процедура принимает три числа и возвращает
--минимальное значение
go
create proc PR_Min3(@a int, @b int,@c int) as
begin
declare @tmp table (num int)
declare @rez int
insert into @tmp (num) values (@a), (@b), (@c)
set @rez =(select Min(num) from @tmp)
print @rez
end;

exec PR_Min3 1,2,3
	      
--8. Хранимая процедура принимает число и символ. В результате
--работы хранимой процедуры отображается линия длиной равной числу. 
--Линия построена из символа, указанного
--во втором параметре. Например, если было передано 5 и
--#, мы получим линию такого вида #####
go
create proc PR_PrintLine(@simb nvarchar(5), @num int)as
begin
print replicate(@simb, @num)
end;

exec PR_PrintLine '*',6
--9. Хранимая процедура принимает в качестве параметра число
--и возвращает его факториал. Формула расчета факториала:
--n! = 1*2*…n. Например, 3! = 1*2*3 = 6
go
create proc PR_Factorial(@num int)as
begin
declare @factorial int
set @factorial=1

while @num>0
	begin
	set @factorial=@factorial*@num
	set @num= @num-1
	end;

print @factorial
end;

exec PR_Factorial 5
	      
--10.Хранимая принимает два числовых параметра. Первый
--параметр — это число. Второй параметр — это степень.
--Процедура возвращает число, возведенное в степень. Например, если параметры равны 2 и 3, тогда вернется 2
--в третьей степени, то есть 8.
go
use DBForTesting
go
create proc PR_DegreE(@num int, @deg int) as
begin
declare @rez int
set @rez=1 
while @deg>0
	begin
	set @rez=@rez*@num
	set @deg= @deg-1
	end;
print @rez
end;
drop proc PR_DegreE
exec PR_DegreE 2,3

--Задание 2. Для базы данных «Продажи» из практического задания модуля «Работа с таблицами и представлениями в MS SQL Server» создайте следующие хранимые
--процедуры:
use SportShop
--1. Хранимая процедура показывает информацию о всех
--продавцах
go
create proc PR_InfoEmpl as
begin
select Name, DateOfReceipt, Gender from SportShop.dbo.Employees
end;

exec PR_InfoEmpl

--2. Хранимая процедура показывает информацию о всех
--покупателях
go
create proc PR_InfoClients as
begin
select * from SportShop.dbo.Clients
end;

exec PR_InfoClients
--3. Хранимая процедура показывает полную информацию
--о продажах
go
create proc PR_InfoSells as
begin
select * from SportShop.dbo.Sells
end;

exec PR_InfoSells

--4. Хранимая процедура показывает полную информацию
--о всех продажах в конкретный день. Дата продажи передаётся в качестве параметра
go
create proc PR_InfoSellsOfDay (@dd date) as
begin
select * from SportShop.dbo.Sells where DateOfSelling=@dd
end;

exec PR_InfoSellsOfDay '2020-01-05'

--5. Хранимая процедура показывает полную информацию
--о всех продажах в некотором временном сегменте. Дата
--старта и конца сегмента передаётся в качестве параметра

go
create proc PR_InfoSellsOfPeriod (@dd date, @ee date) as
begin
if(@dd<@ee)
	begin
	declare @tmp date
	set @tmp=@dd set @dd=@ee set @ee=@tmp
	end;
select * from SportShop.dbo.Sells where DateOfSelling between @ee and @dd
end;

exec PR_InfoSellsOfPeriod '2012-08-15', '2020-03-07'

--6. Хранимая процедура отображает информацию о продажах конкретного продавца. ФИО продавца передаётся
--в качестве параметра хранимой процедуры
go
create proc PR_InfoEmplName (@name nvarchar(30)) as
begin
select Name as Employee, DateOfReceipt as DateOfReceipt, Gender, DateOfSelling as DateOfSelling, 
	GoodId as good, SellPrice as Price, Amount as amount
		from SportShop.dbo.Employees, SportShop.dbo.Sells 
		where Name=@name and EmployeeId=Employees.Id
end;

exec PR_InfoEmplName 'Employee3'
--7. Хранимая процедура возвращает среднеарифметическую
--цену продажи в конкретный год. Год передаётся в качестве
--параметра.
go
create proc PR_AVGSells (@yy nvarchar(10)) as 
begin
select Avg(SellPrice) as AVGPrice, DATEPART(YEAR, DateOfSelling)as 'Year'
		from  SportShop.dbo.Sells 	where DATEPART(YEAR, DateOfSelling)=@yy group by DATEPART(YEAR, DateOfSelling)
end;

exec PR_AVGSells '2020'
