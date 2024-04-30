use eksempeldb
set transaction isolation level read committed

-- 2
select * from person

use master

-- lost update eks 1 låsning
set transaction isolation level repeatable read
begin tran
declare @loen int
select @loen=loen from person where cpr = '1212121212'
waitfor delay '00:00:15'
update person set loen = @loen + 10000 where cpr = '1212121212'
commit tran

-- lost update eks 2 låsning
update person set loen = loen*1.02 where cpr = '1212121212'
go
use master
use eksempeldb
-- lost update eks 1 versionering
set transaction isolation level snapshot
begin tran
declare @loen int
select @loen=loen from person where cpr = '1212121212'
waitfor delay '00:00:15'
update person set loen = @loen + 10000 where cpr = '1212121212'
commit tran

-- lost update eks 2 versionering
set transaction isolation level snapshot
update person set loen = loen*1.02 where cpr = '1212121212'

-- phantom
-- 2
set transaction isolation level snapshot
insert into person values('21','hans kurt','systemudvikler',4000000,'8210')

