use eksamen23v
drop table if exists konto

create table konto
(
kontonr int identity(1001,1) primary key,
kontoejer char(10), 
oprettet date not null,
saldo decimal(14,2) not null
)
insert into konto values('12','1998.05.01',1000)
insert into konto values('12','2011.08.09',2500)
insert into konto values('13','2015.04.04',9000)
insert into konto values('13','2014.01.28',1400)
insert into konto values('14','2012.01.01',500)