use MusicCollection

--������� 1. ��� ������� ���������� ��������� �� ��������� � ���� ������ ������������ ����������, ���������
--� ������������ ������� ��� ����� ������. �������� ��������� �������������:
--1. ������������� ���������� �������� ���� ������������
create view All_Executors
as
Select Artists.Name from Artists
--+++++++++TEST+++++++++++++++++
select * from All_Executors
--2. ������������� ���������� ������ ���������� � ���� ������: �������� �����, �������� �����, ������������ �����,
--����������� ����� �����, �����������
create view AllAboutSong
as
select Songs.Name as Song, Discs.Name as Disc, Songs.Duration as Duration, Styles.Name as Style, Artists.Name
	from Songs,Discs,Styles,Artists
	where DiscId=Discs.Id and Songs.StyleId=Styles.Id and Songs.ArtistId=Artists.Id
--+++++++++TEST+++++++++++++++++
select * from AllAboutSong

--3. ������������� ���������� ���������� � �����������
--������ ���������� ������. ��������, The Beatles
create view DiscsOfBeatles
as
Select Discs.Name as 'The Beatles' from Artists, Discs where ArtistId=Artists.Id and Artists.Name='The Beatles'
--+++++++++TEST+++++++++++++++++
select * from DiscsOfBeatles
--4. ������������� ���������� �������� ������ �����������
--� ��������� �����������. ������������ ������������ ��
--���������� ������ � ���������
create view BestArtists1
as
select top 1 Artists.Name as artist, count(Discs.Id) as countDiscs 
	from Artists join Discs on ArtistId=Artists.Id
		group by Artists.Name
--+++++++++TEST+++++++++++++++++
select * from BestArtists1

--5. ������������� ���������� ���-3 ����� ���������� � ��������� ������������. 
--������������ ������������ �� ���������� ������ � ���������
create view BestArtists3
as
select top 3 Artists.Name as artist, count(Discs.Id) as countDiscs 
	from Artists join Discs on ArtistId=Artists.Id
		group by Artists.Name
--+++++++++TEST+++++++++++++++++
select * from BestArtists3

--6. ������������� ���������� ����� ������ �� ������������
--����������� ������.
create view LongestAlbum
as
select top 1 Discs.Name as Disc, sum(Songs.Duration) as Long
	from Discs join Songs on DiscId=Discs.Id
		group by Discs.Name
		order by sum(Songs.Duration) desc
--+++++++++TEST+++++++++++++++++
select * from LongestAlbum

use MusicCollection
--������� 2. ��� ������� ���������� ��������� �� ��������� � ���� ������ ������������ ����������, ���������
--� ������������ ������� ��� ����� ������:
--1. �������� ����������� �������������, ������� ��������
--��������� ����� �����
create view ADDStyles
as
select Name from Styles
--+++++++++Add+++++++++++++++++
insert into ADDStyles(Name) values (N'Rock'), (N'RnB')
--+++++++++TEST+++++++++++++++++
select* from ADDStyles
--2. �������� ����������� �������������, ������� ��������
--��������� ����� �����
create view AddSongs
as
select Songs.Name , DiscId, StyleId, ArtistId, Duration  from Songs
--+++++++++Add+++++++++++++++++
insert into AddSongs (Name , DiscId, StyleId, ArtistId, Duration) 
	values (N'SSS1', 1, 1, 2, 6),
			(N'SSS2', 1, 2, 2, 4),
			(N'SSS3', 1, 3, 2, 3),
			(N'SSS4', 1, 4, 2, 4),
			(N'SSS5', 1, 4, 2, 5)
--+++++++++TEST+++++++++++++++++
select * from AddSongs

--3. �������� ����������� �������������, ������� ��������
--��������� ���������� �� ��������

--create view AddPublishers
--as
--select Name, Country from Publishers
----+++++++++Add+++++++++++++++++
--insert into AddPublishers (Name,Country) values
--							(N'AsiaRecords',N'Vietnam'),
--							(N'AscanaRec',N'Georgia'),
--							(N'RomanianVoice',N'Romania'),
--							(N'BestUA',N'Ukraine')
----+++++++++TEST+++++++++++++++++
--select * from AddPublishers

create view UpdatePublishers
as
select Name, Country from Publishers
--+++++++++Update+++++++++++++++++
update UpdatePublishers
set Country='China' where Name='AsiaRecords'
--+++++++++TEST+++++++++++++++++
select * from UpdatePublishers

--4. �������� ����������� �������������, ������� ��������
--������� ������������
Insert into Artists (Name) 
	values (N'ArtistForDrop1'),	(N'ArtistForDrop2'),
			(N'ArtistForDrop3'), (N'ArtistForDrop4')
select * from Artists
--+++++++++Create View+++++++++++++++++
create view DropArtists
as
select Name from Artists
--+++++++++Drop+++++++++++++++++
Delete from DropArtists where Name= 'ArtistForDrop2'
--+++++++++TEST+++++++++++++++++
select * from DropArtists
--5. �������� ����������� �������������, ������� ��������
--��������� ���������� � ���������� �����������. ��������, Muse.
insert into Artists (Name) values (N'Muse')
select * from Artists
--+++++++++Create View+++++++++++++++++
create view UpdateAllInfoIsArtists5
as
select Artists.Name as Artist, 
	Discs.Name as Disc, ArtistId as ArtistId, PublisherId as PublisherId, StyleId as StyleId, ReleaseDate as Date, Review as Review, 
	Styles.Name as Style, 
	Publishers.Name as Publisher, Publishers.Country as Country
	from Artists left join Discs on ArtistId=Artists.Id 
						left join Styles on StyleId=StyleId 
						left join Publishers on PublisherId=Publishers.Id 
						where Artists.Name='Muse'
--+++++++++Update+++++++++++++++++
update UpdateAllInfoIsArtists5 
set Disc=N'MuseDisk1/4',
	ArtistId=(select Artists.Id from Artists where  Artists.Name=N'Muse'),
	PublisherId=2, StyleId=5,
	Date=SYSDATETIME(), 
	Review= N'Muse_Review' 
	where  Disc=N'DiscA2S3'
update UpdateAllInfoIsArtists5
set	Style= 'Jazz' where StyleId=3
--update UpdateAllInfoIsArtists5
--set	Publisher= 'KingsVoice',
--	Country ='UK' where Disc=N'DiscA1S2'
--+++++++++TEST+++++++++++++++++
select * from UpdateAllInfoIsArtists5 where Artist='Muse' and Disc=N'MuseDisk1/4'		

--������� 3. ��� ������� ���������� ��������� �� ��������� � ���� ������ ��������, ��������� � ������������
--������� ��� ����� ������:
--1. �������� ����������� �������������, ������� ����������
--���������� � ���� ���������
--2. �������� ����������� �������������, ������� ����������
--���������� � ���� �����������
--3. �������� ����������� �������������, ������� ����������
--���������� � ���� �������� ����������� ������. ��������, �����
--4. �������� �������������, ������������ ��� �������������� ������
--5. �������� �������������, ������������ ���������� � ����� �������� ��������. ���������� ������ ���������
--�������� �� ������������ ����� ����� ������
--6. �������� �������������, ������������ ���������� � ����� �������� ����������. ���������� ������ ���������
--���������� �� ������������ ����� ����� �������.
--����������� ����� CHECK OPTION, SCHEMABINDING,
--ENCRYPTION ���, ��� ��� ���������� ��� �������.

