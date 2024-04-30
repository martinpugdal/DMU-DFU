use tempdb

-- SQL Server har to slags typer til tal med decimaler
--
-- til fast præcision findes typerne decimal og numeric, de to typer er ens
-- maksimalt 38 cifre 
--
-- BRUG ALDRIG bare decimal uden noget bagefter ALTID decimal(  ,  )
declare @fup decimal -- <- ALDRIG sådan her

-- til flydende tal findes typerne float og real. 
-- Reelt findes kun float(24) og float(53). Real = float(24).

declare @x  decimal(8,2)  -- @x indeholder 8 cifre heraf to efter komma.
declare @y float -- det samme som float(53)
declare @z real 
set @x = 23.347
select @x 
set @y =  2934739878.09758
set @z = 2934739878.09758
select @y
select @z

-- Man bør aldrig sammenligne to flydende tal med =
if @y = @z  
print 'de er ens'
else 
print 'de er ikke ens'
-- Spørg i stedet om de er næsten ens. f.eks. 
if @y - @z < 0.001 
print 'de er næsten ens'
else
print 'de er ikke ens'

-- vær opmærksom på, at aggregate funktionen på int afrunder til int
create table tal
( t int)
insert into tal values (3),(5),(8)
select avg(t) from tal
-- kan løses med 
select avg(cast (t as decimal(6,2))) from tal
-- eller den hurtige
select avg(t * 1.0) from tal 


select @@language 
go
drop table if exists dato
go
create table dato
(
d datetime
)
go
insert into dato values(getdate()) -- virker sproguafhængigt
insert into dato values('11:53') -- virker sproguafhængigt

-- virker med US_english (men ikke med danish)
insert into dato values('2022-01-30 11:53')
insert into dato values('2022-01-30')
insert into dato values('2022.01.30 11:55')
insert into dato values('January 31 2022')
insert into dato values('2022 31 January')

-- virker med dansk men ikke med US-english
insert into dato values('30-01-2022 11:53')
insert into dato values('30-01-2022')
insert into dato values('30.01.2022 11:55')
insert into dato values('Januar 31 2022')
insert into dato values('2022 31 Januar')

--Ëksempler på brugbare funktioner på date, time og datetime 
-- datediff
-- datepart herunder year, month og day
-- isdate
-- dateadd

-- Anvendte forkortelser
 -- yy for year
 -- mm for month
 -- dd for day
 -- wk for week 
 -- hh for hour
 -- mi for minute
 -- ss for second
 -- ms for millisecond

-- DATEDIFF
-- bruges til at beregne forskel på to tidspunkter/datoer
-- datediff(part,starttid,sluttid)

select DATEDIFF(mi,'2024.1.29 8:30',getdate())
select DATEDIFF(minute,'2024.1.29 8:30',getdate())

-- DATEPART

-- bruges til at udtrække en del af en dato/tidspunkt
declare @t datetime = '2023.9.6 10:00'
select DATEPART(hour,@t)
select DATEPART(DAY,GETDATE())
-- nogle findes som direkte funktioner, andre gør ikke
select MONTH(@t) -- findes lige som year og day
select hour(@t)  -- findes ikke

-- ISDATE

-- Bruges til at undersøge om en CHAR/VARCHAR 
-- svarer til en valid dato

select ISDATE('2023.2.29')
select ISDATE('2024.2.27')

-- DATEADD

-- Bruges til lægge noget til/trække noget fra en dato
-- f.eks en måned frem eller for 4 dage siden
declare @t2 datetime = '2024.2.5 10:00'
select DATEADD(HOUR,12,@t2)
select DATEADD(day,-100,@t2)
