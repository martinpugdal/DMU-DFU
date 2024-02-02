use school;
drop table if exists faktura
drop table if exists kunde

create table kunde
(
kundeid int primary key,
kundenavn varchar(20),
postnr char(4)
)
insert into kunde values(1,'Ib','8270'),(2,'Bo','8000'),(3,'Claus','8240'),
(4,'Dan','8000'),(5,'Elo','8270'),(6,'Frede','8270')
--
-- 3 forskellige definitioner af faktura
--

-- definition 1
create table faktura
(
fakturaid int primary key,
kundeid int foreign key references kunde,
fakturadato date
)

-- definition 2
-- create table faktura
-- (
-- fakturaid int primary key,
-- kundeid int foreign key references kunde on delete cascade on update cascade,
-- fakturadato date
-- )

-- definition 3
-- create table faktura
-- (
-- fakturaid int primary key,
-- kundeid int foreign key references kunde on delete set null,
-- fakturadato date
-- )

insert into faktura values(1,5,'2023.07.09')
insert into faktura values(2,2,'2023.01.09')
insert into faktura values(3,5,'2023.01.13')
insert into faktura values(4,null,'2023.01.13')


-- insert into faktura
-- values(5,9,'2023.01.13')

-- update faktura
-- set kundeid = 23
-- where fakturaid = 1

-- delete from kunde
-- where kundeid = 2

update kunde
set kundeid = 13
where kundeid = 5