-- udvalg af IndexIntrolekt4 og Indekslekt5ny
use eksamen23v
drop table if exists big 

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

set statistics io on

-- simple select
select * from big where name = 'Andersen20113'

-- select top
select top 25 * from big order by name


create index bigindex on big(name)

-- simple select
select * from big where name = 'Andersen20113'

-- select top
select top 25 * from big order by name

drop index bigindex on big
create clustered index bigindex2 on big(name)

-- simple select
select * from big where name = 'Andersen20113'

-- select top
select top 25 * from big order by name

drop index bigindex2 on big
create clustered index bigindex3 on big(name) with fillfactor = 70,PAD_index

alter index bigindex3
on big
rebuild

drop table if exists fun

create table fun
(
id int primary key nonclustered, 
name varchar(30)
)
 

