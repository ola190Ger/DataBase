--Задание 1. К базе данных «Спортивный магазин» из практического задания к этому модулю создайте следующие триггеры:
use SportShop

--1. При добавлении нового товара триггер проверяет его наличие на складе, если такой товар есть и новые данные о
--товаре совпадают с уже существующими данными, вместо
--добавления происходит обновление информации о количестве товара

if OBJECT_ID('TR_addGoods_insertORupdate', 'TR') is not null
begin
  drop trigger TR_addGoods_insertORupdate;
end;
go

create trigger TR_addGoods_insertORupdate
on [Goods] 
instead of insert
as
if not exists (select * from Goods join inserted as ins on Goods.Name=ins.Name)
  insert into [Goods]([Name], [Kind], Amount, CostPrice, Manufacturer, SellPrice) 
  select [Name], [Kind], Amount, CostPrice, Manufacturer, SellPrice from inserted
else
  update [Goods]
  set Amount=(select Amount from inserted),
		CostPrice=(select CostPrice from inserted),
			SellPrice=(select SellPrice from inserted)
			where Name=(select Name from inserted)

--=========================TEST=================
 insert into [Goods] ([Name], [Kind], Amount, CostPrice, Manufacturer, SellPrice) 
 values
('Good21', 'Kind55', 3, 13.5, 'Fabric2', 222)
select * from Goods

--2. При увольнении сотрудника триггер переносит информацию
--об уволенном сотруднике в таблицу «Архив сотрудников»

if OBJECT_ID('TR_DeleteEmployeer', 'TR') is not null
begin
  drop trigger TR_DeleteEmployeer;
end;
go

if OBJECT_ID('ArchiveEmployees','U') is null
		begin
		create table dbo.ArchiveEmployees(
		  [Id] int not null identity(1, 1) primary key,
		  [Name] nvarchar(100) not null unique check ([Name] <> N''),
		  [DateOfReceipt] date not null,
		  [Gender] nvarchar(100) not null,
		  );
		print('Table create');
		end;
else
	begin
	 print('Table exists');
	end;
go

--use SportShop
create trigger TR_DeleteEmployeer
on Employees 
instead of delete
as
if not exists(select * from Employees e join deleted d on e.Name= d.Name or e.Id=d.Id)
begin
print('Not Found=> not delete');
end;
else
begin
		print('Employees adding in ArchiveEmployees');
		insert into ArchiveEmployees (Name, [DateOfReceipt],[Gender]) 
		select e.Name, e.[DateOfReceipt],e.[Gender] from Employees e join deleted d on e.Id=d.Id or e.Name=d.Name

	print('Employees is find and delete');
	delete Employees where Employees.Id=(Select id from deleted);
end;

--=========================TEST=================
delete Employees where id=2
insert into ArchiveEmployees (Name, [DateOfReceipt],[Gender]) values ('sasha', '2005-12-1', N'Female')
select * from ArchiveEmployees
drop table ArchiveEmployees


--3. Триггер запрещает добавлять нового продавца, если количество существующих продавцов больше 7.

if OBJECT_ID('TR_AddNewEmployeers', 'TR')is not null
begin
  drop trigger TR_AddNewEmployeers;
end;
go

create trigger TR_AddNewEmployeers
on Employees
instead of insert
as
begin
if(select COUNT(Id) from Employees)<=6
	insert into Employees ([Name], [DateOfReceipt], [Gender])
	select [Name], [DateOfReceipt], [Gender] from inserted
else
	print 'FULL STATE.'
end;

--=========================TEST=================
INSERT into [Employees]([Name], [DateOfReceipt], [Gender]) values
(N'Employee8', '2010-09-10', N'Female')
select * from Employees;

go
--Задание 2. К базе данных «Музыкальная коллекция» из
--практического задания модуля «Работа с таблицами и представлениями 
--в MS SQL Server» создайте следующие триггеры:
use MusicCollection

--1. Триггер не позволяющий добавить уже существующий
--в коллекции альбом

if OBJECT_ID('TR_NotAddDisc','TR') is not null
begin
drop trigger TR_NotAddDisc;
end;
go


if OBJECT_ID('TR_AddDisc','TR') is not null
begin
drop trigger TR_AddDisc;
end;
go
--use MusicCollection;
create  trigger TR_AddDisc
on Discs
instead of insert
as
begin
if exists(select * from Discs join inserted on inserted.Name=Discs.Name) 
	print 'Discs exists. Cann`t add discs'
else
	insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate])
	select [Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate] from inserted
end;
--=========================TEST=================
insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate]) values
(N'DiscAS11', 5, 4, N'Review3', 6, SYSDATETIME())
select* from Discs;

go

--2. Триггер не позволяющий удалять диски группы The Beatles

if OBJECT_ID('TR_DeleteIfNotBeatles','TR') is not null
begin
drop trigger TR_DeleteIfNotBeatles
end;
go

create trigger TR_DeleteIfNotBeatles
on Artists
instead of delete
as
begin
if (select deleted.Name from deleted) = 'The Beatles'
 print 'You cann`t delete "The Beatles"';
else
 begin
	declare  @ArtistName nvarchar(30);
	set @ArtistName= convert(text,(select deleted.Name from deleted));
    print N'It`s not "The Beatles". Can delete '+@ArtistName;
    delete Artists where Artists.Name=(select deleted.Name from deleted);
 end;
end;
--=========================TEST=================
   delete Artists where Artists.Name='The Beatles';
   delete Artists where Artists.Name='ArtistForDrop1';
   select * from Artists
  go

--3. При удалении диска триггер переносит информацию об
--удаленном диске в таблицу «Архив»

if OBJECT_ID('TR_IfDeleteAddInArchive','TR') is not null
begin
drop trigger TR_IfDeleteAddInArchive
end;
go

if OBJECT_ID('DiscsArhive','U') is null
begin
create table DiscsArhive(
  [Id] int not null identity(1, 1) primary key,
  [Name] nvarchar(100) not null unique check ([Name] <> N''),
  [ArtistId] int not null,
  [StyleId] int not null,
  [PublisherId] int not null,
  [ReleaseDate] date not null,
  [Review] nvarchar(max) not null check (Review <> N'')
  );
end;
else
 print 'Table exists'
go

create trigger TR_IfDeleteAddInArchive
on Discs
instead of delete
as
begin
--declare @DiscName nvarchar(max)
--set @DiscName=convert(text,(select ds.[Name] from Discs ds join deleted dl on ds.Id=dl.Id or dl.Name=ds.Name));

 insert into DiscsArhive ([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate])
 select ds.[Name], ds.[ArtistId], ds.[StyleId], ds.[Review], ds.[PublisherId], ds.[ReleaseDate] from Discs ds join deleted dl on ds.Id=dl.Id or dl.Name=ds.Name--@DiscName
 print N'Disc "'--+@DiscName+ '" add in "DiscsArhive"';
 print N'"'--+@DiscName + '" DELETED';

delete Discs where Discs.Id=(select Id from deleted )--@DiscName

end;
go

--drop table DiscsArhive
--=========================TEST=================
delete Discs where id=1
select * from Discs
select * from DiscsArhive

--4. Триггер не позволяющий добавлять в коллекцию диски
--музыкального стиля «Dark Power Pop».

if OBJECT_ID('TR_AddDisc','TR') is not null
begin
drop trigger TR_AddDisc;
end;
go

if OBJECT_ID('TR_NotAddDisc','TR') is not null
begin
drop trigger TR_NotAddDisc;
end;
go
--use MusicCollection;
create  trigger TR_NotAddDisc
on Discs
instead of insert
as
begin
if (select Styles.Name from Styles where Styles.Id=(select inserted.StyleId from inserted)) = 'Dark Power Pop'
	print 'Discs in style "Dark Power Pop". Cann`t add discs'
else
	insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate])
	select [Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate] from inserted
end;
--=========================TEST=================
insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate]) values
(N'D-AS11', 3, 4, N'Rev3', 5, SYSDATETIME())

select* from Discs;
insert into Styles (Name) values ('Dark Power Pop') --id=6
select * from Styles
insert into [Discs]([Name], [ArtistId], [StyleId], [Review], [PublisherId], [ReleaseDate]) values
(N'D-AS12', 3, 6, N'Rev3', 3, SYSDATETIME())

--Задание 3. К базе данных «Продажи» из практического
--задания модуля «Работа с таблицами и представлениями в
--MS SQL Server» создайте следующие триггеры:
--1. При добавлении нового покупателя триггер проверяет
--наличие покупателей с такой же фамилией. При нахождении совпадения триггер записывает об этом информацию
--в специальную таблицу
--2. При удалении информации о покупателе триггер переносит
--его историю покупок в таблицу «История покупок»
--3. При добавлении продавца триггер проверяет есть ли он в
--таблице покупателей, если запись существует добавление
--нового продавца отменяется
--4. При добавлении покупателя триггер проверяет есть ли он
--в таблице продавцов, если запись существует добавление
--нового покупателя отменяется
--5. Триггер не позволяет вставлять информацию о продаже
--таких товаров: яблоки, груши, сливы, кинза.