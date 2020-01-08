--������� 1. ��� ���� ������ ����������� ������� ��
--������������� ������� ������ ���������, �������� ��������� � ���������������� ������� �������� ���������
--���������������� �������:
use SportShop
--1. ���������������� ������� ���������� ���������� ���������� �����������
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
--2. ���������������� ������� ���������� ������� ���� ������ ����������� ����. ��� ������ ��������� � ��������
--���������. ��������, ������� ���� �����
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
--3. ���������������� ������� ���������� ������� ����
--������� �� ������ ����, ����� �������������� �������
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
--4. ���������������� ������� ���������� ���������� � ��������� ��������� ������. 
--�������� ����������� ���������� ���������� ������: ���� �������

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
--5. ���������������� ������� ���������� ���������� � ������ ��������� ������. �������� ����������� �������
--���������� ������: ���� �������
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
--6. ���������������� ������� ���������� ���������� � �������� ���� ������� ����������� �������������. ���
--������ � �������� ������������� ���������� � ��������
--����������
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

--7. ���������������� ������� ���������� ���������� � �����������, ������� � ���� ���� ���������� 45 ���

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

--������� 2. ��� ���� ������ ������������ ���������� ��
--������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ���������������� �������:
--1. ���������������� ������� ���������� ��� ����� ���������
--����. ��� ��������� � �������� ���������
--2. ���������������� ������� ���������� ����������
--� ������ � ���������� ��������� �������, �� �������
--�������������
--3. ���������������� ������� ���������� ���������� � ����
--������ � ���� �������� ����������� �������� �����. �����
--��������� � �������� ���������
--4. ���������������� ������� ���������� ���������� �������� � ������ hard rock � heavy metal
--5. ���������������� ������� ���������� ���������� � ������� ������������ ����� ��������� �����������. ��������
--����������� ��������� � �������� ���������
--6. ���������������� ������� ���������� ���������� � ����� ������ � ����� �������� �����
--7. ���������������� ������� ���������� ���������� ��
--������������, ������� ������� ������� � ���� � �����
--������.