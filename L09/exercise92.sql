
-- old no history table
create table item
(
itemno int identity(1,1) primary key,
itemname varchar(25),
price decimal(7,2)
)
insert into item values('pommes frites',17),('small burger',25),('checken nuggets',28),('hot wings',27)
--
--
-- new system with history
create table itemnew
(
itemno int identity(1,1) primary key,
itemname varchar(25)
)
create table histprice
(
itemno int foreign key references itemnew,
price decimal(7,2),
fromdate datetime
)
--
--
-- queries used by the old system
select price from item where itemno = 2
insert into item(itemname,price) values ('big burger',45)
update item set price = 50 where itemno = 4
delete from item where itemno = 3  

