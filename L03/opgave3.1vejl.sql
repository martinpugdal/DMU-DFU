-- opgave 3.1 løsning

create table medarbejder (
medarbnummer int identity primary key,
navn varchar(30),
loen int,
ledernummer int foreign key references medarbejder 
)
insert into medarbejder values ('Ib',700000,null)
insert into medarbejder values ('Bo',650000,1)
insert into medarbejder values ('Jens',550000,2)
insert into medarbejder values ('Hans',640000,1)
insert into medarbejder values ('Kurt',650000,3)
insert into medarbejder values ('Brian',600000,3)
insert into medarbejder values ('Per',500000,6)
 
-- navne på alle ledere
select distinct m1.navn 
from medarbejder m1 join medarbejder m2 on m1.medarbnummer=m2.ledernummer

-- navne på alle ikke ledere
select distinct navn 
from medarbejder 
where medarbnummer not in (select ledernummer
                           from medarbejder
						   where ledernummer is not null)

-- lønstigning på 5% til de 20%, der tjener mindst og vis dem
update medarbejder
set loen = 1.05*loen
output inserted.navn
where medarbnummer in (select top 20 percent medarbnummer 
                       from medarbejder
					   order by loen) 

select * from medarbejder
go
  with medarbCTE(x)
  as
  (
  select medarbnummer
  from medarbejder
  where ledernummer = 2
  union all
  select medarbnummer
  from medarbejder as m
  join medarbCTE as mc
  on m.ledernummer = mc.x
  )
  select x from medarbCTE 
  go
   with medarbCTE(x,navn)
  as
  (
  select medarbnummer,navn
  from medarbejder
  where ledernummer = 2
  union all
  select medarbnummer,m.navn
  from medarbejder as m
  join medarbCTE as mc
  on m.ledernummer = mc.x
  )
  select x,navn from medarbCTE 


