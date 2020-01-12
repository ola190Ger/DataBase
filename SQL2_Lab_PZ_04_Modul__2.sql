--������� 2. �������� ��������� ���������������� �������:
--1. ���������������� ������� ���������� ����������� � �����
--�Hello, ���!� ��� ��� ��������� � �������� ���������.
use DBForTesting
go
create function FN_HelloName(@name nvarchar(max))
returns nvarchar(max)
as
begin

return concat('Hello ', @name)
end;

print dbo.FN_HelloName('You')

--��������, ���� �������� Nick, �� ����� Hello, Nick!
--2. ���������������� ������� ���������� ���������� �
--������� ���������� �����

go
create function FN_MinutNOW()
returns int
as
begin
return datepart(MINUTE, getdate())
end;

print dbo.FN_MinutNOW()
--3. ���������������� ������� ���������� ���������� �
--������� ����
go
create function FN_YearNOW()
returns int
as
begin
return datepart(YEAR, getdate())
end;

print dbo.FN_YearNOW()
--4. ���������������� ������� ���������� ���������� �
--���: ������ ��� �������� ���
go
create function FN_YearNOWisEven()
returns nvarchar(max)
as
begin
return IIF(datepart(YEAR, getdate())%2=0, 'year is Even', 'year is Uneven')
end;

print dbo.FN_YearNOWisEven()
--5. ���������������� ������� ��������� ����� � ���������� yes, ���� ����� ������� � no, 
--���� ����� �� �������.
go
create function FN_SimpleNumber(@num int)
returns nvarchar(max)
as
begin
declare @numm int
set @numm=@num-1
while (@numm>1)
	begin
		if(@num%@numm!=0)
			set @numm=@numm-1
		else break;
	end;
return IIF(@numm=1, 'Yes', 'No')
end;

print dbo.FN_SimpleNumber(7)
--6. ���������������� ������� ��������� � �������� ���������� ���� �����. ���������� ����� 
--������������ � ������������� �������� �� ���������� ����
--����������
go
create function FN_MinMaxFUN(@a int, @b int, @c int, @d int, @e int)
returns int
as
begin
declare @intT table (Numbers int not null)

insert  @intT (Numbers) values 
	(@a),(@b) ,(@c) ,(@d) ,(@e)

return (select MIN(Numbers)from @intT)+(select Max(Numbers)from @intT)
end;

print dbo.FN_MinMaxFUN(1, 1,1, 1, 1)
--7. ���������������� ������� ���������� ��� ������ ���
--�������� ����� � ���������� ���������. ������� ��������� ��� ���������: 
--������ ���������, ����� ���������,
--��� ��� ����� ����������.
go
create function FN_EvenNumbers(@begin int, @end int, @even int)
returns @intT table (Numbers int not null)
as
begin
declare @diapazon int
set @diapazon= (@end-@begin)

if (@even=1)
	begin while(@diapazon>0) begin
					if(@diapazon%2=0) begin
					insert  @intT (Numbers) values (@diapazon)
					set @diapazon= @diapazon-1
									end;
					else set @diapazon= @diapazon-1
					end; end; 

else	begin 
		while(@diapazon>0) 
			begin
					if(@diapazon%2!=0) 
					begin
					insert  @intT (Numbers) values (@diapazon)
					set @diapazon= @diapazon-1
					end; 
					else set @diapazon= @diapazon-1
			end;
		end;

return
end;

-- 1-even/ 2-Uneven
select* from FN_EvenNumbers(1, 11,1)

--������� 2. ��� ���� ������ �������� �� �������������
--������� ������ ������� � ��������� � ���������������
--� MS SQL Server� �������� ��������� ����������������
--�������:
use SportShop
--1. ���������������� ������� ���������� ����������� ������� ����������� ��������. 
--��� �������� ���������
--� �������� ��������� ���������������� �������
go
create function FN_MinSellEmploee(@Employee nvarchar(max))
returns int
as 
begin
return (select min(SellPrice*Amount) from Sells, Employees where EmployeeId=Employees.Id 
	and Employees.Name=@Employee)
end;

print dbo.FN_MinSellEmploee('Employee3')
--2. ���������������� ������� ���������� �����������
--������� ����������� ����������.
go
create function FN_MinSellClient(@Client nvarchar(max))
returns int
as 
begin
return (select min(SellPrice*Amount) from Sells, Clients where ClientId=Clients.Id 
	and Clients.Name=@Client)
end;

print dbo.FN_MinSellClient('Client1')

--��� ���������� ��������� � �������� ��������� ���������������� �������

--3. ���������������� ������� ���������� ����� �����
--������ �� ���������� ����. ���� ������� ��������� �
--�������� ���������
go
create function FN_SumSelldata(@data date)
returns int
as 
begin
return (select sum(SellPrice*Amount) from Sells where DateOfSelling=@data)
end;

print dbo.FN_SumSelldata('2020-01-05')

--4. ���������������� ������� ���������� ����, ����� �����
--����� ������ �� ���� ���� ������������
go
create function FN_MaxSumSelldata()
returns date
as 
begin
return (select t.datE from ( select top 1 sum(SellPrice*Amount) as suma , DateOfSelling as datE 
			from Sells group by DateOfSelling order by sum(SellPrice*Amount) desc)as t)
end;

print dbo.FN_MaxSumSelldata()
--5. ���������������� ������� ���������� ���������� � ����
--�������� ��������� ������. �������� ������ ���������
--� �������� ���������
go
create function FN_SellsInfo(@good nvarchar(max))
returns @SellsInfo table(
Sellprice money not null,
Amount int not null,
DateofSalling date not null
)
as 
begin
insert into @SellsInfo (Sellprice, Amount, DateofSalling)
select s.Sellprice, s.Amount, s.DateOfSelling from Sells as s, Goods where s.GoodId=Goods.Id and Goods.Name=@good
return 
end;

go
select * from FN_SellsInfo('Good1')

--6. ���������������� ������� ���������� ���������� � ����
--��������� �������������
ALTER TABLE Employees  
NOCHECK CONSTRAINT [CK__Employees__Name__3D5E1FD2];  --�� �������� � �������, ������ � �������������
GO
ALTER TABLE Employees 
drop CONSTRAINT [UQ__Employee__737584F66C7E907F];   

drop trigger [TR_AddNewEmployeers]

insert Employees (Name, DateOfReceipt, Gender) 
values ('Employee1', '2010-11-12', 'Male'),('Employee1', '2012-11-12', 'Female'),
		('Employee4', '2019-11-12', 'Male')

drop function FN_EmploeeHomonym

go
create function FN_EmploeeHomonym()
returns @Homonym table(
Name nvarchar(max) not null,
DateOfReceipt date not null,
Gender nvarchar(10) not null,
CountId int not null
)
as
begin
declare @tmp table (Name nvarchar(max) not null, CountId int not null)
insert into @tmp (Name, CountId)
select Name, count(Id) from Employees group by Name

insert into @Homonym(Name, DateOfReceipt, Gender, CountId )
select e.Name, DateOfReceipt, Gender, t.CountId from Employees as e, @tmp as t where e.Name=t.Name and t.CountId>1

return
end;

select * from FN_EmploeeHomonym()
--7. ���������������� ������� ���������� ���������� � ����
--����������� �������������
ALTER TABLE Clients  
drop CONSTRAINT [UQ__Clients__737584F67485718D];   
GO
INSERT into [Clients]([Name], [Gender], [Email], [Phone], [Discount], [MailingList]) values
(N'Client1', N'Male', N'email1@mail.com', N'+38091', 3, 0),
(N'Client2', N'Male', N'email2@mail.com', N'+38092', 4, 0)

go
create function FN_ClientHomonym()
returns @Homonym table(
Name nvarchar(max) not null,
Gender nvarchar(10) not null,
Email nvarchar(max) not null,
CountId int not null
)
as
begin
declare @tmp table (Name nvarchar(max) not null, CountId int not null)
insert into @tmp (Name, CountId)
select Name, count(Id) from Clients group by Name

insert into @Homonym(Name, Gender, Email, CountId )
select e.Name, Gender, Email, t.CountId from Clients as e, @tmp as t where e.Name=t.Name and t.CountId>1

return
end;

select * from FN_ClientHomonym()


--8. ���������������� ������� ���������� ���������� � ����
--����������� � ��������� �������������.
go
create function FN_AllHomony()
returns @Homonym table(
Name nvarchar(max) not null,
DateOfReceipt date not null default '1991-11-11',
Gender nvarchar(10) not null,
Email nvarchar(max) not null default '-',
CountId int not null
)
as begin
insert into @Homonym(Name, Gender, Email, CountId)
select * from FN_ClientHomonym()
insert into @Homonym(Name, DateOfReceipt, Gender, CountId)
select * from FN_EmploeeHomonym()

return
end;

select * from FN_AllHomony()