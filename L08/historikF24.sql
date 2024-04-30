-- the following script is made to show, how history can be implemented
-- error-handling is NOT implemented
use tempdb
-- no history
create table item
(
itemno int identity(1,1) primary key,
itemname varchar(25),
price decimal(7,2)
)
drop table if exists histprice
drop table if exists item

-- with history
create table item
(
itemno int identity(1,1) primary key,
itemname varchar(25)
)
create table histprice
(
itemno int foreign key references item,
price decimal(7,2),
fromdate datetime,
todate datetime
)
insert into item values
	('pommes frites'),
	('chickens')
insert into histprice values
     (1,'13.50','2024-01-01','2024-01-10'),
     (1,'16.50','2024-01-10',null)
insert into histprice values
     (2,'35.00','2024-01-01','2024-02-01'),
     (2,'40.00','2024-02-01',null)
--    
select itemno,price,fromdate,todate from histprice order by itemno 


-- find the price for all items on a given date and time using a stored procedure
drop proc if exists spfindprice
go
create proc spfindprice
@day datetime
as
select itemname,price
from item i join histprice h on i.itemno = h.itemno
where
(fromdate <= @day and
@day < todate or
 fromdate <= @day and
todate is null)
go
exec spfindprice '2024-01-19'
go
-- find the price for one item on a given day using a function
create function fufindprice (@day datetime,@itemno int)
returns decimal(7,2)
as
BEGIN
return (select price
from histprice 
where itemno = @itemno and
(fromdate <= @day and
@day < todate or
 fromdate <= @day and
todate is null))
END     
go
select dbo.fufindprice('2024.01.26',2)
go    
create proc spupdateprice
-- assumes itemno already exists 
@itemno int,
@newprice decimal(7,2),
@fromdate datetime
as
update histprice set todate = @fromdate where itemno =@itemno and todate is null
insert into histprice values(@itemno,@newprice,@fromdate,null)
go
exec spupdateprice 1,'32.00','2024.2.28'

select dbo.fufindprice('2024.02.01',1)
--
