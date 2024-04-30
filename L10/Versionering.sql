use eksempeldb
-- Der findes to muligheder for versionering i SQL Server

-- Den første betyder at isolation level read committed 
-- virker med versionering (der checkes ikke for update conflicts 
use master 
alter database eksempeldb set read_committed_snapshot on -- skal kun køres en gang
use eksempeldb
set transaction isolation level read committed

-- Den anden betyder at der anvendes versionering  
-- med check for update conflicts 
use master
alter database eksempeldb set allow_snapshot_isolation on -- skal kun køres en gang
use eksempeldb
set transaction isolation level snapshot


select * from person
-- dirty read
--1
begin tran
insert into person values('19','hans kurt','systemudvikler',400000,'8210')
waitfor delay '00:00:15'
rollback tran
go
use master 
alter database eksempeldb set read_committed_snapshot on -- skal kun køres en gang
use eksempeldb
set transaction isolation level read committed

select * from person

-- lost update låsning
set transaction isolation level repeatable read
begin tran
declare @loen int
select @loen=loen from person where cpr = '1212121212'
waitfor delay '00:00:15'
update person set loen = @loen + 10000 where cpr = '1212121212'
commit tran
go
-- lost update versionering
set transaction isolation level snapshot
begin tran
declare @loen int
select @loen=loen from person where cpr = '1212121212'
waitfor delay '00:00:15'
update person set loen = @loen + 10000 where cpr = '1212121212'
commit tran


-- phantom 

-- eksempel på læsning af konsistente data
-- først uden transaktion

-- 1
select stilling,avg(loen)
from person 
group by stilling

--3
select postnr,avg(loen)
from person 
group by postnr

delete from person where cpr = '21'

-- derefter med transaktioner og snapshot

-- 1
set transaction isolation level snapshot
begin tran
select stilling,avg(loen)
from person 
group by stilling
waitfor delay '00:00:15'
select postnr,avg(loen)
from person 
group by postnr
commit tran




