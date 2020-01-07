--������� 1. ��� ���� ������ ����������� ������� ��
--������������� ������� ������ ���������, �������� ��������� � ���������������� ������� �������� ���������
--�������� ���������:
use SportShop
--1. �������� ��������� ���������� ������ ����������
--� ���� �������

go
create procedure PR_FullInfoGoods as
begin
select * from Goods
end;
 
execute PR_FullInfoGoods

--2. �������� ��������� ���������� ������ ����������
--� ������ ����������� ����. ��� ������ ��������� � �������� ���������.
--��������, ���� � �������� ���������
--������� �����, ����� �������� ��� �����, ������� ����
--� �������(Kind2)

go
create procedure PR_FindGood
	@kind nvarchar(max)
as
begin
select * from Goods where Kind=@kind
end;

execute PR_FindGood 'Kind2'

--3. �������� ��������� ���������� ���-3 ����� ������ ��������. 
--���-3 ������������ �� ���� �����������

go
create procedure PR_Top3Clients
as
begin
select top 3 * from Clients order by id
end;
--==============TEST===================
execute PR_Top3Clients

--4. �������� ��������� ���������� ���������� � �����
--�������� ��������. ���������� ������������ �� �����
--����� ������ �� �� �����
go
create procedure PR_BestEmployee
as
begin
select top 1 Employees.Name, SUM(SellPrice*Amount) from Employees, Sells where EmployeeId=Employees.Id group by Employees.Name
end;

execute PR_BestEmployee

--5. �������� ��������� ��������� ���� �� ���� ���� �����
--���������� ������������� � �������. �������� ������������� ��������� � �������� ���������. 
--�� ������ ������
--�������� ��������� ������ ������� yes � ��� ������, ����
--����� ����, � no, ���� ������ ���

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

--6. �������� ��������� ���������� ���������� � ����� ���������� ������������� ����� �����������.
--������������ ����� ����������� ������������ �� ����� ����� ������

go
create procedure PR_BestManufacturer
as
begin
select top 1 Goods.Manufacturer, sum(Sells.SellPrice*Sells.Amount) from Sells, Goods where GoodId=Goods.Id group by Goods.Manufacturer
end;

execute PR_BestManufacturer

--7. �������� ��������� ������� ���� ��������, ������������������ ����� ��������� ����. ���� ��������� � ��������
--���������. ��������� ���������� ���������� ���������
--�������.

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

--������� 2. ��� ���� ������ ������������ ���������� ��
--������������� ������� ������ ������� � ��������� � ��������������� � MS SQL Server� �������� ��������� ��������
--���������:
go
use MusicCollection
--1. �������� ��������� ���������� ������ ���������� � ����������� ������

go
create procedure PR_AllInfoDiscs
as
begin
select * from Discs
end;

execute PR_AllInfoDiscs

--2. �������� ��������� ���������� ������ ����������
--� ���� ����������� ������ ����������� ��������. �������� �������� ��������� � �������� ���������

go
create procedure PR_PublisherDiscs
	@Publisher nvarchar(max)
as
begin
select * from Discs, Publishers where PublisherId=Publishers.Id and Publishers.Name=@Publisher 
end;

execute PR_PublisherDiscs 'Publisher1'

--3. �������� ��������� ���������� �������� ������ ����������� �����. ������������ ����� ������������ �� 
--���������� ������ � ���������

go
create procedure PR_BestSyle
as
begin
select top 1 Styles.Name, count(Discs.Id) from Styles, Discs where StyleId=Styles.Id group by Styles.Name order by Count(Discs.Id) desc
end;

execute PR_BestSyle


--4. �������� ��������� ���������� ���������� � ����� ����������� ����� � ���������� ����������� �����.
--�������� ����� ��������� � �������� ���������, ���� �������� �����
--all, ������ ��� �� ���� ������
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


--5. �������� ��������� ������� ��� ����� ��������� �����.
--�������� ����� ��������� � �������� ���������. ���������
--���������� ���������� ��������� ��������

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

--6. �������� ��������� ���������� ���������� � �����
--������� ������ � ����� ��������. �������� � ���������
--������������ �� ���� �������
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

--7. �������� ��������� ������� ��� ����� � �������� ������� ���� �������� �����. 
--����� ��������� � ��������
--���������. ��������� ���������� ���������� ���������
--��������.
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
