use bigdb
--

-- ********************************
-- eksempler med systemtabeller
-- ********************************
select * from sysobjects order by name
--
select * from sysobjects where name like 'sys%'
--
select * from sysobjects where name not like 'sys%' 
--
select * from sysobjects where category = 0

select * from sysobjects where type='u'

select * from syscolumns 

select obj.name,col.name 
from syscolumns col,sysobjects obj 
where obj.category = 0 and col.id=obj.id and 
obj.type='u'


SELECT	i.name,  
		ps.index_id,
		ps.index_level,
		ps.index_type_desc,
		ps.page_count,
		ps.record_count,
		ps.min_record_size_in_bytes,
		ps.max_record_size_in_bytes,
		ps.avg_record_size_in_bytes,
		ps.partition_number,
		ps.alloc_unit_type_desc,
		ps.index_depth,
		ps.avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats(DB_ID(), object_id('big'), NULL, NULL , 'DETAILED') AS ps INNER JOIN sys.indexes AS i
				ON ps.object_id = i.object_id AND ps.index_id = i.index_id
	ORDER BY index_id, index_level DESC;


use eksempeldb

-- viser hvornår statistics sidst blev opdateret
declare @tabid int
select @tabid = object_id('person')
select STATS_DATE(@tabid,1)

-- opdaterer DBMS's statistics
update statistics firma
update statistics postnummer

-- eksempel på brug af systemtabeller
-- en stored procedure til at opdatere statistics for alle
-- tabeller i databasen


go
create or alter proc Updateallstatistics
as
declare p cursor
for select name from sysobjects where category = 0 and type = 'u'
declare @name sysname
open p
fetch p into @name
while @@fetch_status != -1
begin
  execute ('update statistics ' + @name)
  fetch p into @name
end
close p
deallocate p
go

-- Viser hvornår statistics blev opdateret på firma
declare @tabid int
select @tabid = object_id('firma')
select STATS_DATE(@tabid,1)
go

exec Updateallstatistics  

-- ***************************
-- Statistics detail
-- **************************
select * from person

create index postindeks on person(postnr)

DBCC SHOW_STATISTICS(person,postindeks)
--DBCC SHOW_STATISTICS(person,[PK__person__D836E70A9CBECDB9])
--DBCC SHOW_STATISTICS(firma,[PK__firma__145703AA2BFF11E1])
-- Der er maksimalt 200 i high score listen

-- ********************************************
-- Eksempler til visning af execution-planer
-- ********************************************
use eksempeldb

select navn
from person join postnummer on person.postnr=postnummer.postnr
and postdistrikt='Århus C'

select navn,firmanavn 
from person p join ansati a on p.cpr = a.cpr
              join firma f on a.firmanr=f.firmanr

insert into firma values(5,'Danske Data2','8220')
insert into firma values(6,'Kommunedata2','8000')
insert into firma values(7,'LEC2','8240')
insert into firma values(8,'Dansk Supermarked2','8270')

select * from firma join postnummer on firma.postnr=postnummer.postnr




-- **********************************
--        OPTIMIZER HINTS
-- **********************************

-- Table hints

-- tving optimizer til at bruge et indeks
-- nedenstående antager, at der er et index2 på ansati

select navn,firmanavn 
from person p join ansati a with (index=index2) on p.cpr = a.cpr
              join firma f on a.firmanr=f.firmanr
--
-- tving den til ikke at bruge index
select navn,firmanavn 
from person p join ansati a with (index=0) on p.cpr = a.cpr
              join firma f on a.firmanr=f.firmanr
 


-- Tving den til at bruge bestemte join-metoder (join hints)
-- kan kun bruges med ny syntaks
select navn,firmanavn 
from person p inner loop join ansati a on p.cpr = a.cpr
              inner hash join firma f on a.firmanr=f.firmanr



-- query hint OPTION field 
select navn,firmanavn 
from person p join ansati a on p.cpr = a.cpr
              join firma f on a.firmanr=f.firmanr
              OPTION (merge join,force order)





-- ********************************************
-- Script til OPGAVE 6.1
-- ********************************************
use big2 
create table big
(
id int,
name char(30),
filler char(200)
)
-- insert BATCH inserts 40000 records
declare @name char(30)
declare @i int
select @i = 10000
while @i < 50000
begin
  select @name = 'Andersen' + convert(char(6),@i)
  insert into big values(@i,@name,'hey')
  select @i = @i + 1
end
go
create table bigtoo
(
id int,
name char(30),
filler char(200)
)
-- insert BATCH inserts 10000 records
declare @name char(30)
declare @i int
select @i = 20000
while @i < 30000
begin
  select @name = 'Andersen' + convert(char(6),@i)
  insert into bigtoo values(@i,@name,'hey')
  select @i = @i + 1
end
--
create table manytomany
(
bigid int,
bigtooid int
)
go
declare @i int
select @i = 10000
while @i < 30000
begin
  insert into manytomany values(round (RAND(@i*@i)*60000,0),round (RAND(@i*(@i-9876))*60000,0))
  select @i = @i + 1
end

