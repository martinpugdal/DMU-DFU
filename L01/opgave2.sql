use school;
drop table if exists tidsreg
drop table if exists sag
drop table if exists arbejderi
drop table if exists medarbejder 
drop table if exists afdeling 

create table afdeling
(
afdnr int primary key identity,
afdnavn varchar(30) unique not null
)
create table medarbejder
(
initial char(4) primary key,
cpr char(10) unique not null,
navn varchar(30) not null
)
create table arbejderi
(
afdnr int foreign key references afdeling,
initial char(4) foreign key references medarbejder,
primary key(afdnr,initial)
)
create table sag
(
sagsnr int primary key identity(1000,1),
overskrift varchar(50),
sagsbeskrivelse varchar(4000),
afdnr int foreign key references afdeling not null
) 
create table tidsreg
(
tidsregid int primary key identity,
initial char(4) foreign key references medarbejder not null,
sagsnr int foreign key references sag,
start datetime not null,
slut datetime not null,
check (start<slut)
) 
-- DET ER DET LETTESTE AT ANBRINGE TRIGGERE HER
go

 
-- inserts
insert into afdeling values
('Faktureringssystemer'),('Lagersystemer'),('Web-shops'),('Test'),('Support')
insert into medarbejder values
('OO','1201931233','Ole Olsen'),('MH','0909905673','Mikkel Hansen'),
('RL','0408753363','Rasmus Lauge'),('JV','1412962323','Jonas Vingeg�rd'),
('AA','2212812222','Anja Andersen'),('VA','0505871233','Viktor Axelsen')
insert into arbejderi values
(1,'AA'),(1,'RL'),(1,'JV'),(2,'MH'),(3,'AA'),(3,'OO'),(3,'VA'),(5,'MH'),(5,'JV')
insert into sag values
('For lange svartider','Skide tr�ls',1),
('Forkert formattering','',1),
('Ikke korrekt afrunding','',2),
('Indtastningsfelt for kort','bonder�v ',2),
('Ingenting virker','',3),
('Problem med �,�,�','',4),
('Sort sk�rm','',4) 
insert into tidsreg values ('OO',NULL,'2023.01.23 08:13','2023.01.23 12:00')
insert into tidsreg values ('OO',null,'2023.01.23 12:30','2023.01.23 17:00')
insert into tidsreg values ('OO',NULL,'2023.01.24 07:53','2023.01.24 18:00')
insert into tidsreg values ('OO',NULL,'2023.01.25 08:00','2023.01.25 19:00')
insert into tidsreg values ('OO',null,'2023.01.26 08:13','2023.01.26 16:20')
insert into tidsreg values ('AA',null,'2022.12.10 08:00','2022.12.10 16:30')
insert into tidsreg values ('AA',1000,'2022.12.11 08:27','2022.12.11 16:36')
insert into tidsreg values ('AA',1000,'2022.12.12 08:30','2022.12.12 16:08')
insert into tidsreg values ('AA',1001,'2022.12.13 08:02','2022.12.13 12:30')
insert into tidsreg values ('AA',1004,'2022.12.13 12:31','2022.12.13 16:36')
insert into tidsreg values ('JV',1001,'2023.1.12 07:32','2023.1.12 15:34')
insert into tidsreg values ('JV',1001,'2023.1.13 08:07','2023.1.13 11:18')
insert into tidsreg values ('JV',1000,'2023.1.13 11:32','2023.1.13 16:48')
insert into tidsreg values ('JV',null,'2023.1.14 6:32','2023.1.14 18:48')
insert into tidsreg values ('RL',1000,'2023.1.12 07:09','2023.1.12 22:34')
insert into tidsreg values ('RL',1001,'2023.1.13 07:07','2023.1.13 11:18')
insert into tidsreg values ('RL',1001,'2023.1.13 11:40','2023.1.13 16:00')
insert into tidsreg values ('RL',1001,'2023.1.14 8:00','2023.1.14 18:00')
insert into tidsreg values ('MH',1002,'2023.1.23 07:45','2023.1.23 12:34')
insert into tidsreg values ('MH',1002,'2023.1.23 12:54','2023.1.23 16:18')
insert into tidsreg values ('MH',null,'2023.1.24 8:00','2023.1.24 16:00')
insert into tidsreg values ('MH',1005,'2023.1.25 8:00','2023.1.25 16:00')

-- OPGAVER

-- Opgave A
-- Find numre p� de sager, som tilh�rer afdelinger
-- som initial MH arbejder i
SELECT sagsnr
FROM sag
WHERE afdnr IN (
    SELECT afdnr FROM arbejderi WHERE initial = 'MH'
)

-- Opgave B 
-- Find initial p� alle medarbejdere, der har registreret tid 
-- p� sager, hvor teksten svartid indg�r i overskriften 
SELECT initial
FROM tidsreg
JOIN sag ON tidsreg.sagsnr = sag.sagsnr
WHERE sag.overskrift LIKE '%svartid%'

-- Opgave C
-- find for hver afdeling alle de intialer, der arbejder i afdelingen
SELECT afdeling.afdnavn, arbejderi.initial
FROM afdeling
JOIN arbejderi ON arbejderi.afdnr=afdeling.afdnr
-- JOIN medarbejder ON medarbejder.initial=arbejderi.initial

-- Opgave D
-- Ovenst�ende kan virke lidt uoverskuelig fordi der kommer 
-- en svarlinje for hver kombination af afdeling og initial
-- pr�v at lave den, s� der kun kommer en linje per afdeling 
-- og alle initialer kommer i en lang linje
-- Hint STRING_AGG
SELECT afdeling.afdnavn, STRING_AGG(arbejderi.initial, '') as afdeling_medarbejdere
FROM afdeling
JOIN arbejderi ON arbejderi.afdnr=afdeling.afdnr
-- JOIN medarbejder ON medarbejder.initial=arbejderi.initial
GROUP BY afdeling.afdnavn

-- Opgave E
-- find alle tidsregistreringer p� sagen med sagsnr 1002
SELECT *
FROM tidsreg
WHERE sagsnr = 1002

-- Opgave F
-- find hvor mange minutter der samlet er registreret 
-- p� sagen med sagsnr 1002 
-- Hint datediff
SELECT DATEDIFF(MINUTE, start, slut) AS antalMinutterRegisteret
FROM tidsreg
WHERE sagsnr = 1002

-- Opgave G
-- Find hvor mange minutter hver medarbejder 
-- samlet har registreret p� sagen med sagsnr 1002 
-- svaret skal indeholder medarbejderens initial, navn og tidsforbruget
SELECT tidsreg.initial, medarbejder.navn, SUM(DATEDIFF(MINUTE, tidsreg.start, tidsreg.slut)) as tidsforbruget
FROM tidsreg
JOIN medarbejder ON tidsreg.initial=medarbejder.initial
WHERE tidsreg.sagsnr = 1002
GROUP BY tidsreg.initial, medarbejder.navn

-- Opgave H
-- Find det samlede tidsforbrug for hver afdeling på hver enkelt sag
-- der skal vises afdelingens navn, sagens overskrift og 
-- tidsforbruget skal vises i hele timer
SELECT afdeling.afdnavn, sag.overskrift, SUM(DATEDIFF(HOUR, tidsreg.start, tidsreg.slut)) as tidsforbruget
FROM sag
JOIN tidsreg ON tidsreg.sagsnr=sag.sagsnr
JOIN afdeling ON sag.afdnr=afdeling.afdnr
GROUP BY afdeling.afdnavn, sag.overskrift

-- Opgave I
-- Find det samlede tidsforbrug for hver afdeling på hver enkelt sag
-- der skal vises afdelingens navn, sagens overskrift og 
-- tidsforbruget skal vises i hele timer
-- kun de 5 sager med størst tidsforbrug skal vises
SELECT TOP(5) afdeling.afdnavn, sag.overskrift, SUM(DATEDIFF(HOUR, tidsreg.start, tidsreg.slut)) as tidsforbruget
FROM sag
JOIN tidsreg ON tidsreg.sagsnr=sag.sagsnr
JOIN afdeling ON sag.afdnr=afdeling.afdnr
GROUP BY afdeling.afdnavn, sag.overskrift
ORDER BY tidsforbruget DESC

-- Opgave J 
-- Find de sager, der endnu ikke er blevet tidsregistreret på
-- i indeværende år
-- HINT year
--fiks det her, vi nåede hertil
SELECT sag.sagsnr, YEAR(tidsreg.start) as start_år, YEAR(tidsreg.slut) as slut_år
FROM sag
JOIN tidsreg on sag.sagsnr = tidsreg.sagsnr
WHERE YEAR(GETDATE()) <> YEAR(tidsreg.start)
AND YEAR(GETDATE()) <> YEAR(tidsreg.slut)

-- Opgave K
-- Som det fremgår kan man enten registrere på en sag
-- eller uden sag (NULL).
-- Find for hver medarbejder hvor meget vedkommende samlet har registreret
-- på sager
 

-- Opgave L
-- Find for hver medarbejder hvor meget vedkommende samlet 
-- har registreret uden sager


-- Opgave M
-- Kan du sammens�tte de to foreg�ende queries 
-- s� man kan se b�de den samlede registrerede tid med sager
-- og det registrerede uden sager - sv�r og lidt lumsk



