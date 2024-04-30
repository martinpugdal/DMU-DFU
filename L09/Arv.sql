-- N+1 table solution
create table persontable
(
cpr char(10) primary key,
name varchar(40),
address varchar(40),
telephone char(16)
)
create table studenttable
(
cpr char(10) foreign key references persontable unique,
mobilephone char(16)
)
create table teachertable
(
cpr char(10) foreign key references persontable unique,
officephone char(16),
officenumber char(12)
)
go
create view person as
select * from persontable
go
create view student
as 
select p.cpr as cpr,name,address,telephone,mobilephone 
from studenttable s join persontable p on s.cpr=p.cpr
go
create view teacher
as 
select p.cpr as cpr,name,address,telephone,officenumber,officephone
from teachertable t join persontable p on t.cpr=p.cpr
go
create trigger studentinsert
on student
instead of insert
as
  insert into persontable select cpr,name,address,telephone from inserted
  insert into studenttable select cpr,mobilephone from inserted
go
create trigger studentdelete
on student
instead of delete
as
  delete from studenttable where cpr in (select cpr from deleted)
  delete from persontable where cpr in (select cpr from deleted)
go
create trigger studentupdate
on student
instead of update
as
  update studenttable set cpr = i.cpr,mobilephone = i.mobilephone 
  from inserted i where studenttable.cpr = i.cpr
  update persontable set cpr = i.cpr,name = i.name, address = i.address,telephone = i.telephone 
  from inserted i where persontable.cpr = i.cpr
  -- there is a problem if you change cpr
go
-- there should be three triggers for teacher as well
--
insert into student values('1','ib','byvej','23232323','45454545')
insert into student values('2','per','bygade','23239999','45459999')
go
select * from persontable
select * from studenttable
go
update student set name = 'hans' where cpr = '1'
go 
delete from student where cpr = '2' 
go

--
--
drop view student
drop view teacher
drop view person
drop table teachertable
drop table studenttable
drop table persontable
--
-- N table solution

create table studenttable
(
cpr char(10) primary key,
name varchar(40),
address varchar(40),
telephone char(16),
mobilephone char(16)
)
create table teachertable
(
cpr char(10) primary key,
name varchar(40),
address varchar(40),
telephone char(16),
officephone char(16),
officenumber char(12)
)
go
create view person as
select cpr,name,address,telephone
from studenttable
union
select cpr,name,address,telephone
from teachertable
go
create view student
as 
select * 
from studenttable
go
create view teacher
as 
select * 
from teachertable
go
-- 
drop view student
drop view teacher
drop view person
drop table teachertable
drop table studenttable
drop table persontable

-- 1-table solution
go
create table persontable
(
cpr char(10) primary key,
name varchar(40),
address varchar(40),
telephone char(16),
mobilephone char(16),
officephone char(16),
officenumber char(12),
type char(1) -- for example P, S or T 
)
go
create view student
as 
select cpr,name,address,telephone,mobilephone 
from persontable 
where type = 'S'
go
create view teacher
as 
select cpr,name,address,telephone,officenumber,officephone
from persontable
where type = 'T'
go
create view person
as 
select cpr,name,address,telephone 
from persontable 
go
create trigger studentinsert
on student
instead of insert
as
  insert into persontable select cpr,name,address,telephone,NULL,NULL,'S' from inserted 
go
-- there should be a trigger for teacher as well
 
insert into student values('1','ib','byvej','23232323','45454545')
insert into student values('2','per','bygade','23239999','45459999')
go
select * from persontable

go
update student set name = 'hans' where cpr = '1'
go 
delete from student where cpr = '2' 
go