use bigdb
  
drop table big 
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

select COUNT(*) from big
select top 5 * from big


set statistics io on 

-- simple select
select * from big where name = 'Andersen20113'

-- select top
select top 25 * from big order by name

-- finds one record
set statistics io on
declare @t1 datetime, @t2 datetime
set @t1 = getdate()
select * from big where name = 'Andersen20113'
set @t2 = getdate()
select DATEDIFF(ms,@t1,@t2)
go
-- statistics
set statistics io on
set statistics time on
select * from big where name = 'Andersen20113'

-- makes a non-clustered index

create nonclustered index bigindex on big(name)
-- drop an index
drop index bigindex on big

-- makes a clustered index

create clustered index bigindex2 on big(name)

-- drop an index
drop index bigindex2 on big

-- Clean the buffer
-- 
checkpoint
go
dbcc dropcleanbuffers
go



