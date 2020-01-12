--������� 1. �������� ��������� �������� ���������:
use DBForTesting
--1. �������� ��������� ������� �Hello, world!�
go
create procedure PR_HelloName
as
begin

print 'Hello world!!!'
end;

exec dbo.PR_HelloName
--2. �������� ��������� ���������� ���������� � �������
--�������
go
create proc PR_TimeNow as
begin
print convert(time, sysdatetime())
end;

exec PR_TimeNow
--3. �������� ��������� ���������� ���������� � �������
--����
go
create proc PR_DateNow as
begin
print convert(date, sysdatetime())
end;

exec PR_DateNow
--4. �������� ��������� ��������� ��� ����� � ����������
--�� �����
go
create proc PR_Summa(@a int, @b int,@c int) as
begin
print @a+@b+@c
end;

exec PR_Summa 1,2,3
--5. �������� ��������� ��������� ��� ����� � ����������
--�������������������� ��� �����
go
create proc PR_AVG3(@a int, @b int,@c int) as
begin
print (@a+@b+@c)/3
end;

exec PR_AVG3 1,2,3
--6. �������� ��������� ��������� ��� ����� � ����������
--������������ ��������
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

--7. �������� ��������� ��������� ��� ����� � ����������
--����������� ��������
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
--8. �������� ��������� ��������� ����� � ������. � ����������
--������ �������� ��������� ������������ ����� ������ ������ �����. 
--����� ��������� �� �������, ����������
--�� ������ ���������. ��������, ���� ���� �������� 5 �
--#, �� ������� ����� ������ ���� #####
go
create proc PR_PrintLine(@simb nvarchar(5), @num int)as
begin
print replicate(@simb, @num)
end;

exec PR_PrintLine '*',6
--9. �������� ��������� ��������� � �������� ��������� �����
--� ���������� ��� ���������. ������� ������� ����������:
--n! = 1*2*�n. ��������, 3! = 1*2*3 = 6
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
--10.�������� ��������� ��� �������� ���������. ������
--�������� � ��� �����. ������ �������� � ��� �������.
--��������� ���������� �����, ����������� � �������. ��������, ���� ��������� ����� 2 � 3, ����� �������� 2
--� ������� �������, �� ���� 8.
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

--������� 2. ��� ���� ������ �������� �� ������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ��������
--���������:
use SportShop
--1. �������� ��������� ���������� ���������� � ����
--���������
go
create proc PR_InfoEmpl as
begin
select Name, DateOfReceipt, Gender from SportShop.dbo.Employees
end;

exec PR_InfoEmpl

--2. �������� ��������� ���������� ���������� � ����
--�����������
go
create proc PR_InfoClients as
begin
select * from SportShop.dbo.Clients
end;

exec PR_InfoClients

--3. �������� ��������� ���������� ������ ����������
--� ��������
go
create proc PR_InfoSells as
begin
select * from SportShop.dbo.Sells
end;

exec PR_InfoSells

--4. �������� ��������� ���������� ������ ����������
--� ���� �������� � ���������� ����. ���� ������� ��������� � �������� ���������
go
create proc PR_InfoSellsOfDay (@dd date) as
begin
select * from SportShop.dbo.Sells where DateOfSelling=@dd
end;

exec PR_InfoSellsOfDay '2020-01-05'

--5. �������� ��������� ���������� ������ ����������
--� ���� �������� � ��������� ��������� ��������. ����
--������ � ����� �������� ��������� � �������� ���������
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

--6. �������� ��������� ���������� ���������� � �������� ����������� ��������. ��� �������� ���������
--� �������� ��������� �������� ���������
go
create proc PR_InfoEmplName (@name nvarchar(30)) as
begin
select Name as Employee, DateOfReceipt as DateOfReceipt, Gender, DateOfSelling as DateOfSelling, 
	GoodId as good, SellPrice as Price, Amount as amount
		from SportShop.dbo.Employees, SportShop.dbo.Sells 
		where Name=@name and EmployeeId=Employees.Id
end;

exec PR_InfoEmplName 'Employee3'
--7. �������� ��������� ���������� ��������������������
--���� ������� � ���������� ���. ��� ��������� � ��������
--���������.
go
create proc PR_AVGSells (@yy nvarchar(10)) as 
begin
select Avg(SellPrice) as AVGPrice, DATEPART(YEAR, DateOfSelling)as 'Year'
		from  SportShop.dbo.Sells 	where DATEPART(YEAR, DateOfSelling)=@yy group by DATEPART(YEAR, DateOfSelling)
end;

exec PR_AVGSells '2020'