drop table fakturalinie2
drop table fakturalinie
drop table faktura
drop table kunde
drop table vare
drop table varegruppe
go
create table varegruppe
(
varegruppeid int identity primary key,
varegruppenavn varchar(40) unique
)
create table vare
(
vareid int identity primary key,
EANnr char(13) unique,
varenavn varchar(40), 
varegruppeid int foreign key references varegruppe not null, 
antalpaalager int,
varebeskrivelse varchar(600),
pris decimal(8,2)
)
create table kunde
(
kundeid int identity primary key,
kundetype char(3),
kundenavn varchar(60),
kundetlf char(8),
kundeadresse varchar(100),
kundepostnr char(4)
)
create table faktura
(
fakturaid int identity primary key,
kundenr int foreign key references kunde not null,
fakturadato date,
betalt bit
)
create table fakturalinie
(
fakturalinieid int identity primary key,
fakturanid int foreign key references faktura not null,
vareid int foreign key references vare not null,
antal int
) 
-- alternativ, der skal ikke findes indeks for denne 
create table fakturalinie2
(
fakturaid int foreign key references faktura,
vareid int foreign key references vare,
antal int, 
primary key (fakturaid,vareid)
)