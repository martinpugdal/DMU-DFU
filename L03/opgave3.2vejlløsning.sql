use opgave2

-- 3.2.1
go
create view medarbfoedt as
select initial, navn, cast (substring(cpr,5,2)+substring(cpr,3,2)+substring(cpr,1,2) as date) as foedsel
from medarbejder

select * from medarbfoedt

-- 3.2.3
select navn,year(getdate())-year(foedsel)
            - case 
			    when month(getdate()) < month(foedsel) then 1
				when month(getdate()) = month(foedsel) and day(getdate()) < day(foedsel) then 1
				else 0
			  end
from medarbfoedt

-- 3.2.4
select day(foedsel),month(foedsel)
from medarbfoedt 
group by day(foedsel),month(foedsel)
having count(*) > 1

-- 3.2.5
select initial,min(start),max(slut) 
from tidsreg
group by initial,cast(start as date)

-- 3.2.6
go
create view starslut as
select initial,min(start) st,max(slut) sl 
from tidsreg
group by initial,cast(start as date)

select * from starslut

-- 3.2.7
declare p cursor
for select * from starslut order by initial,st
declare @init char(4),@start datetime,@slut datetime
declare @oldinit char(4)
declare @oldslut datetime 
open p
fetch p into @init,@start,@slut
while @@fetch_status != -1
begin
  if @oldinit = @init and datediff(mi,@oldslut,@start) < 11*60
    select @init,' overtrådt ',@oldslut,@start
  set @oldinit = @init
  set @oldslut = @slut
  fetch p into @init,@start,@slut
end
close p
deallocate p
 
select * from tidsreg
