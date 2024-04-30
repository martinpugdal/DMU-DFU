use eksempeldb

drop table if exists ansati
drop table if exists person
drop table if exists firma
drop table if exists postnummer

go

create table postnummer
(
postnr char(4) primary key,
postdistrikt varchar(25)
)

create table person
(
cpr char(10) primary key,
navn varchar(25),
stilling varchar(25),
loen int not null check(loen > 0),
postnr char(4) references postnummer not null,
)

create table firma
(
firmanr int primary key,
firmanavn varchar(25),
postnr char(4) not null,
foreign key (postnr) references postnummer 
)

create table ansati
(
cpr char(10) constraint cprforeign foreign key references person,
firmanr int constraint firmaforeign foreign key references firma
primary key(cpr,firmanr)
)
go

insert into postnummer values('8000','Århus C');
insert into postnummer values('8200','Århus N')
insert into postnummer values('8210','Århus V')
insert into postnummer values('8220','Brabrand')
insert into postnummer values('8240','Risskov')
insert into postnummer values('8310','Tranbjerg J')
insert into postnummer values('8270','Højbjerg')
insert into postnummer values('8250','Egå')
insert into person values('1212121212','Ib Hansen','systemudvikler',250000,'8000')
insert into person values('1313131313','Poul Ibsen','projektleder',500000,'8310')
insert into person values('1414141414','Anna Poulsen','IT-chef',870000,'8250')
insert into person values('1515151515','Jette Olsen','systemudvikler',200000,'8000')
insert into person values('1616161616','Roy Hurtigkoder','programmør',500000,'8210')
insert into firma values(1,'Danske Data','8220')
insert into firma values(2,'Kommunedata','8000')
insert into firma values(3,'LEC','8240')
insert into firma values(4,'Dansk Supermarked','8270')
insert into ansati values('1212121212',2)
insert into ansati values('1313131313',4)
insert into ansati values('1414141414',4)
insert into ansati values('1616161616',2)
