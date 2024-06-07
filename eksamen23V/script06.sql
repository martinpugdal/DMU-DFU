-- uddrag af OptimeringF24.sql og løsning til opgave 6.2

-- ********************************************
-- Eksempler til visning af execution-planer
-- ********************************************
use eksamen23v

select navn
from person join postnummer on person.postnr=postnummer.postnr
and postdistrikt='Århus C'

select navn,firmanavn 
from person p join ansati a on p.cpr = a.cpr
              join firma f on a.firmanr=f.firmanr



-- **********************************
--        OPTIMIZER HINTS
-- **********************************


select navn,firmanavn 
from person p join ansati a with (index=index2) on p.cpr = a.cpr -- kan ikke køres, da index2 ikke findes
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


-- **********************************
--        REDUCTION FACTOR
-- **********************************

use eksamen23v

drop table if exists big
go
create table big
(
id int,
searchint int,
name char(30),
filler char(196)
)
-- insert BATCH inserts 40000 records
declare @num int
set @num = 50
declare @name char(30)
declare @i int
select @i = 10000
while @i < 50000
begin
  select @name = 'Andersen' + convert(char(6),@i)
  insert into big values(@i,(@i % @num), @name,'hey')
  select @i = @i + 1
end

create index test on big(searchint)
update statistics big
set statistics io on
  
select name from big where searchint=16 

update big set searchint = id % 100 