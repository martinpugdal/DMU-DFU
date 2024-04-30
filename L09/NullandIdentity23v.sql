--
-- NULL is the common undefined value for all types
--
-- 
-- The use of NULL in create table
-- Primary key are always not null
-- Unique key are almost not null - may have one null value

drop table if exists person
drop table if exists zipcode


create table zipcode
(
zip char(4) primary key,
postaldistrict varchar(25) not null
);


create table person
(
cpr char(10) primary key,
name varchar(25) not null,
job varchar(25) default ('no job'),
salary int,
zip char(4) not null,
foreign key (zip) references zipcode(zip) 
);


insert into zipcode values('8000','Aarhus C')
insert into zipcode values('8200','Aarhus N')
insert into zipcode values('8210','Aarhus V')
insert into zipcode values('8220','Brabrand')
insert into zipcode values('8240','Risskov')
insert into zipcode values('8310','Tranbjerg J')
insert into zipcode values('8270','Hojbjerg')
insert into zipcode values('8250','Egaa')


-- nulls in insert
-- Two ways to give the value null
-- Either directly
insert into person values('2121212121','Ib Hansen2',null,null,'8000')

-- or to provide a list of not-null attributes
insert into person(cpr,name,zip) values('2222222222','Ib Hansen3','8000')

-- using default instead of null
insert into person values('2323232323','Ib Hansen3',default,null,'8000')

select * from person

insert into person values('1212121212','Ib Hansen','systemdeveloper',250000,'8000')
insert into person values('1313131313','Poul Ibsen','project manager',500000,'8310')
insert into person values('1414141414','Anna Poulsen','IT-manager',870000,'8250')
insert into person values('1515151515','Jette Olsen','systemdeveloper',200000,'8000')
insert into person values('1616161616','Roy Hurtigkoder','programmer',500000,'8210')
insert into person values('1717171718','Hemmelig','programmer',null,'8210')

-- the use of null in conditions
-- When you ask on the value null you use IS and IS NOT
-- You can't use the usual =

Select * from person

-- the following example shows
select *
from person
where salary > 300000 or salary <= 300000

select *
from person
where NOT (salary > 300000 or salary <= 300000)

-- that NULL is neither less, equal to or larger than a value.

select *
from person
where salary > 300000 or salary <= 300000 or salary is null
--
-- shows all person who are not programmers
select *
from person
where job <> 'programmer'

select * from person

-- shows all person who might be programmers
select *
from person
where job = 'programmer' or job is null
-- is OK

-- man kunne tro dette var det samme
select *
from person
where job in ('programmer',null)

-- virker slet ikke
select *
from person
where job not in ('programmer',null)



-- null and T-SQL programming
--
-- a newly declared variabel has the value null
declare @x int
select @x

set @x = @x + 89
select @x
go
declare @x int
select @x=count(*) from person where cpr >= '2421212121'
select @x
go
declare @x int
select @x=count(salary) from person where cpr >= '2421212121'
select @x

-- and the dangerous one
go
declare @x int
select @x=SUM(salary) from person where cpr >= '2421212121'
select @x
go
-- the right solution is  
declare @x int
select @x=isnull(SUM(salary),0) from person where cpr >= '2421212121'
select @x
go
-- or an if 
declare @x int
select @x=SUM(salary) from person where cpr >= '2421212121'
if @x is null 
-- ........


-- Example with identity 

use nullDB

create table t
(
id int identity,
name varchar(50)
)

insert into t values ('rf'),('tt'),('yj'),('bb'),('kj')

select * from t

delete from t where name = 'yj'

select * from t

insert into t values ('ny')

select * from t

delete from t where name = 'ny'

select * from t

delete from t where name = 'ny'

insert into t values ('allernyeste')

select * from t

set identity_insert t on

insert into t(id,name)  values (9,'rf'),(17,'tt'),(29,'yj') 

select * from t

set identity_insert t off

insert into t values ('ny')

select @@IDENTITY

select * from t

begin tran
insert into t values ('ny2')
rollback tran

insert into t values ('ny3')

select * from t

-- Antag ALDRIG, at et identity-felt er fortløbende 
-- nummereret

