drop table if exists person

Create table Person
(
navn varchar(30),
stilling varchar(30),
loen int
)
insert into Person values('Paul','systemudvikler',400000)
insert into Person values('Jan','programmør',340000)

-- Dette er en BATCH - den fejler på grund af stavefejl
inserd into Person values('Pauline','systemudvikler',400000)
insert into Person values('Britney','programmør',340000)
--
-- Dette er en BATCH - den første sætning fejler, fordi lønnen overstiger MAXINT
-- Den anden gennemføres
insert into Person values('Pauline','system developer',40000000000)
insert into Person values('Britney','programmer',340000)
--
select * from person
--
-- Det er nogle gange svært at gennemskue hvilke fejl, der er compiletime 
-- og hvilke der er runtime 
--  
--
-- Brugen af GO
-- Eksemplet tidligere
inserd into Person values('Pauline','systemudvikler',400000)
go
insert into Person values('Britney','programmør',340000)
--
select * from Person

-- globale variable
-- starter altid med @@
-- Man kan ikke selv lave globale variable -
-- man kan kun bruge dem SQL Server stiller til rådighed
-- eksempler
-- der er et sæt globale variable per connection
select @@ROWCOUNT -- antal records berørt af sidste SQL-sætning
select @@ERROR -- fejlkode fra seneste SQL-sætning - 0 betyder ingen fejl
select @@identity -- sidst uddelte identityværdi
 
-- almindelige variable starter med @

-- dette er et eksempel på variable og variables scope
--
declare @s varchar(20)
set @s = 'Hej med dig'
select @s

-- Et andet eksempel på assignment
declare @i int
declare @j int
select @i=count(*),@j=max(loen) from Person
select @i,@j
--
-- Nedenstående er en farlig brug af SELECT (normalt en fejl)
go
declare @s varchar(20)
select @s=navn from Person
select @s
print @s

-- Et eksempel med IF
declare @i int
declare @svar varchar(50)
select @i=count(*) from Person
IF @i > 0
  set @svar = 'Der er ' + cast (@i as varchar) + ' records i tabellen'
ELSE
  set @svar = 'Tabellen er tom'
select @svar 
go
-- WHILE eksempel 
declare @i int = 1 
declare @produkt int = 1
while @i <= 5
begin
  set @produkt = @produkt * @i
  set @i = @i +1
end
select @produkt       
 
-- CASE eksempel
  
SELECT navn,
 CASE stilling
  WHEN 'systemudvikler' THEN 'system developer'
  WHEN 'programmør' THEN 'programmer'
  ELSE 'something else'
  END
FROM person

SELECT navn,
 CASE 
  WHEN loen < 48000 THEN 0
  WHEN loen between 48000 and 500000 THEN (loen-48000)*0.37
  ELSE (500000-48000)*0.37+(loen-500000)*0.52
  END as skat
FROM person

go
-- EXECUTE eksempel
-- bruges til at lave dynamisk kode
declare @tabnavn varchar(30)
select @tabnavn = 'person'
execute ('select * from ' + @tabnavn)

go

-- CURSOR eksempel
declare p cursor
for select navn,loen from person
declare @navn varchar(30),@loen int
open p
fetch p into @navn,@loen
while @@fetch_status != -1
begin
  print @navn
  print convert(varchar(20),@loen)
  select @navn,@loen
  fetch p into @navn,@loen
end
close p
deallocate p
--
-- Top ikke en procedural udvidelse
select top 2 *
from person
order by loen
-- 
-- Tabel variable
-- eneste mulighed for at gemme flere af en slags
-- T-SQLs eneste konstruktion, der minder om en collection 

declare @t table (stilling varchar(30),loen int)
insert into @t select stilling,loen from Person
insert into @t values('golfspiller',2000000) 
select * from @t

-- nedlæggelse af @t sker automatisk når den løber ud af scope 
