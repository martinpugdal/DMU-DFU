
use eksamen23V
-- trigger eksempel
go
create or alter trigger delaccount
on konto 
for delete
as
if exists(select * from deleted where saldo <> 0)
begin
  raiserror('Account could not de deleted',16,1)
  rollback tran
end  

-- eksempel til array
drop table if exists student
drop table if exists grades
go
create table student 
(
studentno int,
name varchar(30)
);

create table grades
(
studentno int,
grade int
);
insert into student values (1,'clever boy');
insert into student values (2,'fool');
insert into grades values (1,11);
insert into grades values (1,13);
insert into grades values (1,9);
insert into grades values (1,10);
insert into grades values (1,13);
insert into grades values (2,5);
insert into grades values (2,3);
insert into grades values (2,7);
insert into grades values (2,6);
insert into grades values (2,6);


-- eksempel til cursor
declare @counter int
declare @totalloen int
set @counter = 0
set @totalloen = 0
declare p cursor
for select loen from person
declare @loen int
open p
fetch p into @loen
while @@fetch_status != -1
begin
  set @totalloen = @totalloen + @loen 
  set @counter = @counter +1  
  fetch p into @loen
end
close p
deallocate p
select @totalloen/@counter
 