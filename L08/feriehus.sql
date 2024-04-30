create database ferieugenormaliseret
create database ferieugedenormaliseret
waitfor delay '00:00:15'
go
use ferieugenormaliseret
drop table if exists booking
drop table if exists ferieuge
drop table if exists feriebolig
drop table if exists omraade
drop table if exists land
drop table if exists kunde



create table kunde (
kundeid int identity primary key,
kundenavn varchar(30),
kundeadresse varchar(40),
postnr char(4),
kundetlf char(12)
)

create table land
(landekode char(2) primary key,
land varchar(30) not null
)

create table omraade
(
omraadeid int identity primary key,
omraadenavn varchar(30) not null,
landekode char(2) references land not null,
unique(omraadenavn,landekode)
)

create table feriebolig
(boligid int identity primary key, 
maxpersoner int not null,
afstandvand int,
afstandindkoeb int,
kvadratmeter int,
kvalitet int check(kvalitet between 1 and 5) not null,
omraadeid int references omraade not null 
)
create table ferieuge 
(ferieugeid int identity primary key,
 pris int not null,
 ugenummer int not null,
 ferieboligid int not null references feriebolig  
 )

create table booking
(bookingid int identity primary key,
ferieugeid int not null references ferieuge,
kundeid int not null references kunde,
bookingdato date,
betalt bit
)


insert into kunde values ('Ib Hansen','nyvej 4','8000','85785485') 
insert into kunde values ('Jan Jensen','gammelvej 9','8210','44445485') 
insert into land values ('sp','Spanien')
insert into land values ('it','Italien')
insert into land values ('fr','Frankrig')
insert into omraade values ('Nice','fr')
insert into omraade values ('Costa del Sol','sp')
insert into omraade values ('Mallorca','sp')
insert into omraade values ('Sardinien','it')
insert into feriebolig values (8,500,1000,88,4,2)
insert into feriebolig values (4,200,1500,75,3,2)
insert into feriebolig values (6,700,700,80,3,2)
insert into feriebolig values (6,800,400,80,2,3)
insert into feriebolig values (6,1500,200,100,2,1)
insert into ferieuge values(10000,23,1)
insert into ferieuge values(10000,24,1)
insert into ferieuge values(10000,25,1)
insert into ferieuge values(12000,26,1)
insert into ferieuge values(14000,27,1)
insert into ferieuge values(14000,28,1)
insert into ferieuge values(14000,29,1)
insert into ferieuge values(13000,30,1)
insert into ferieuge values(13000,31,1)
insert into ferieuge values(10000,28,2)
insert into ferieuge values(10000,29,2)
insert into ferieuge values(10000,30,2)
insert into ferieuge values(10500,28,3)
insert into ferieuge values(11000,29,3)
insert into ferieuge values(11000,30,3)
insert into ferieuge values(10000,27,4)
insert into ferieuge values(10000,28,4)
insert into ferieuge values(10000,29,4)
insert into booking values(4,1,'2024.2.4',1)
insert into booking values(7,1,'2024.2.14',1)
insert into booking values(11,1,'2024.2.24',1)



-- **************************************
-- ************ NY DATABASE *************


use ferieugedenormaliseret
drop table if exists booking
drop table if exists ferieugebolig
drop table if exists omraade
drop table if exists land
drop table if exists kunde


create table kunde (
kundeid int primary key,
kundenavn varchar(30),
kundeadresse varchar(40),
postnr char(4),
kundetlf char(12)
)

create table land
(
land varchar(30) primary key
)

create table omraade
(

omraadenavn varchar(30) not null,
land varchar(30) references land not null,
primary key (omraadenavn,land)
)

create table ferieugebolig
(ferieugeid int primary key,
boligid int, 
maxpersoner int not null,
afstandvand int,
afstandindkoeb int,
kvadratmeter int,
kvalitet int check(kvalitet between 1 and 5) not null,
omraade varchar(30) not null,
landenavn varchar(30) not null,
foreign key (omraade,landenavn) references omraade, 
 pris int not null,						-- fra ferieuge
 ugenummer int not null,				-- fra ferieuge
 booked bit,							-- redundant
 )

 create table booking
(bookingid int primary key,
ferieugeid int not null references ferieugebolig,
kundeid int not null references kunde,
bookingdato date,
betalt bit
)

insert into kunde select * from ferieugenormaliseret.dbo.kunde
insert into land select land from ferieugenormaliseret.dbo.land
insert into omraade select omraadenavn,land 
   from ferieugenormaliseret.dbo.omraade o join 
        ferieugenormaliseret.dbo.land l on l.landekode = o.landekode
insert into ferieugebolig

select f.ferieugeid,boligid,maxpersoner,afstandvand,afstandindkoeb,kvadratmeter,
kvalitet,o.omraadenavn,l.land,pris,ugenummer,case when b.ferieugeid is null then 0 else 1 end as booked
from ferieugenormaliseret.dbo.land l
   join ferieugenormaliseret.dbo.omraade o on l.landekode = o.landekode
   join ferieugenormaliseret.dbo.feriebolig fb on fb.omraadeid=o.omraadeid
   join ferieugenormaliseret.dbo.ferieuge f on f.ferieboligid = fb.boligid
	left join ferieugenormaliseret.dbo.booking b on f.ferieugeid=b.ferieugeid

insert into booking select * from ferieugenormaliseret.dbo.booking

