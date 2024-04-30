use bigtest

drop table names
Create table names
(
id int identity,
name char(15)
)
insert into names values('Anders'),('Andreas'),('Arne'),('Børge'),('Bo'),('Birger'),('Claus'),('Dennis'),('Erik'),('Elo')
insert into names values('Frede'),('Frederik'),('Freddy'),('Gert'),('Gunnar'),('Hans'),('Helge'),('Ib'),('Jens'),('Jørgen')
insert into names values('Lars'),('Mogens'),('Niels'),('Per'),('Rolf')
-- names indeholder nu 25 drengenavne med numre 1 til 25 


drop table big 
go
create table big
(
id int,
firstname char(15),
lastname char(15),
filler char(200)
)
-- insert BATCH inserts 40000 records
declare @firstname char(15)
declare @lastname char(15)
declare @i int
select @i = 10000
while @i < 50000
begin
  select @firstname = name from names where id=(select round(RAND()*24,0)+1)
  select @lastname = name from names where id=(select round(RAND()*24,0)+1)
  set @lastname = rtrim(@lastname) + 'sen'
  insert into big values(@i,@firstname,@lastname,'hey')
  select @i = @i + 1
end
go
-- big indeholder 40000 records med et tilfældigt fornavn (blandt de 25) og et tilfældigt 
-- efternavn = et tilfældigt fornavn (blandt de 25) efterfulgt af 'sen'

select top 15 * from big

select count(distinct firstname) from big
select count(distinct lastname) from big
select firstname,lastname,count(*)
from big 
group by firstname,lastname

-- Queryfornavn
select * from big where firstname = 'Erik' -- Reductionfactor = 4%

-- Queryefternavn
select * from big where lastname = 'Fredesen' -- Reductionfactor = 4%

-- Queryfuldenavn
select * from big where firstname = 'Erik' and lastname = 'Fredesen' -- Reductionfactor = 0,16%



create index firstnameindeks on big(firstname)
create index lastnameindeks on big(lastname)
create index fullnameindeks on big(firstname,lastname)

set statistics io on

-- Vi vil nu undersøge om disse indeks anvendes (på grund af reduktionfactor) 

select * from big where firstname = 'Erik' 
select * from big where lastname = 'Fredesen' 
select * from big where firstname = 'Erik' and lastname = 'Fredesen' 

-- Helt forventet at de to første indeks ikke vil blive anvendt


drop index firstnameindeks on big
drop index lastnameindeks on big
drop index fullnameindeks on big

-- Lille snak om locator

-- Vi ændrer nu det første indeks (på firstname) til clustered
-- for at se hvad det ændrer

create clustered index firstnameindeks on big(firstname)
create index lastnameindeks on big(lastname)
create index fullnameindeks on big(firstname,lastname)


select * from big where firstname = 'Erik' 
select * from big where lastname = 'Fredesen' 
select * from big where firstname = 'Erik' and lastname = 'Fredesen' 

-- Det clusteret index på firstname gør det sammensatte indeks (fullnameindeks)
-- overflødigt i denne sammenhæng

-- hvad hvis vi tvinger den til at bruge fullnameindeks

select * from big where firstname = 'Erik' and lastname = 'Fredesen' 
select * from big with (index = fullnameindeks) 
where firstname = 'Erik' and lastname = 'Fredesen' 

-- et kig på statistics viser at det var korrekt ikke at bruge fullnameindeks

drop index firstnameindeks on big
drop index lastnameindeks on big
drop index fullnameindeks on big


-- Problemstilling omkring covered indeks
-- kun relevant ved nonclustered indeks

-- Jeg antager at følgende indeks er lavet
create index fullnameindeks on big(firstname,lastname)

-- Selecter nu kun lastname

-- Query 1
select lastname from big where firstname = 'Ib'
-- Query 2
select count(*) from big where lastname = 'Ibsen'

-- Query 3
select lastname,id from big where firstname = 'Ib'

-- I dette tilfælde vil fullnameindeks være et covered indeks for Query 1 og 2
-- da resultatet findes ved kun at løbe gennem søgetræet og man ikke er ude at kigge i 
-- de "rigtige" records 

-- Hvis et indeks skal være covered for en query kræver det at queryen KUN arbejder med attributter
-- der er en del af det pågældende indeks

-- Man har et alternativ til at lave det sammensatte indeks
-- Dette alternativ kan anvendes i de situationer, hvor man ikke har queries med 
-- WHERE-betingelser, der indeholder både firstname og lastname, men kun firstname

drop index fullnameindeks on big
create index fullnameindeks on big(firstname) INCLUDE (lastname)

-- Query 1
select lastname from big where firstname = 'Ib'

-- Query 2
select lastname,id from big where firstname = 'Ib'

