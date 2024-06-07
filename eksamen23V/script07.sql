-- Dele af script historikF24 og l�sning opgave 9.2

use eksamen23V
drop table if exists item
drop view if exists item
drop table if exists histprice
drop table if exists itemnew


go
create table item
(
itemno int identity(1,1) primary key,
itemname varchar(25),
price decimal(7,2)
)
go
insert into item values('pommes frites',17),('small burger',25),('checken nuggets',28),('hot wings',27)



go
create table itemnew
(
itemno int identity(1,1) primary key,
itemname varchar(25)
)
go
create table histprice
(
itemno int foreign key references itemnew,
price decimal(7,2),
fromdate datetime
)
go


set identity_insert itemnew on
go
insert into itemnew(itemno,itemname)
select itemno, itemname
from item
go
set identity_insert itemnew off
go
insert into histprice(itemno,price,fromdate)
select itemno, price,GETDATE()
from item
go

drop table item
go


create view item
as
select i.itemno, i.itemname, hs.price
from itemnew i join histprice hs on i.itemno = hs.itemno
where 
fromdate = (select max(fromdate)from histprice h2 
where fromdate<= getdate() and h2.itemno=i.itemno)
go


go
create or alter  trigger iteminsert
on item
instead of insert
as
insert into itemnew select itemname from inserted
insert into histprice (itemno, price, fromdate)
select @@identity, price, getdate() 
from inserted
go

create or alter trigger itemupdate
on item
instead of update
as
if update(itemname)
    update itemnew 
    set itemname = (select itemname from inserted)
    where itemno = (select itemno from inserted)
if update(price)
   insert into histprice (itemno, price, fromdate)
     select itemno, price, getdate()
     from inserted
go




create trigger itemdelete
on item
instead of delete
as
delete from histprice
where itemno = (select itemno from deleted)
delete from itemnew
where itemno = (select itemno from deleted)
go

-- queries used by the old system
select price,itemname from item where itemno = 2
insert into item(itemname,price) values ('big burger',45)
update item set price = 50 where itemno = 4
delete from item where itemno = 3

select * from item
select * from itemnew
select * from histprice