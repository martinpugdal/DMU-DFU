-- rep af triggere
-- anvender databasen opgave 1.2 fra lektion 1
use opgave2
-- nemt eksempel 
go
create or alter trigger nemtrigger 
on tidsreg
after insert
as
if (select slut from inserted) > GETDATE()
begin
  raiserror('fejl',16,1)
  rollback tran
end
go

-- redundans
-- Man kunne forestille sig at gemme samlet registreret arbejdstid redundant på medarbejder

alter table medarbejder
add samlettid int

update medarbejder
set samlettid = 0
go
create trigger samlettidtrigger
on tidsreg
after insert
as
declare @regtid int
select @regtid = datediff(minute,start,slut) from inserted
update medarbejder
set samlettid = samlettid + @regtid 
where initial = (select initial from inserted)
go

insert into tidsreg values ('OO',null,'2023.08.26 09:00','2023.08.26 10:00')

select * from medarbejder
go
-- kontroller at en medarbejder kun kan registrere tid på en sag, som tilhører en afdeling
-- medarbejderen arbejder i
create or alter trigger delopg2
on tidsreg
after insert
as
if not exists (select * from inserted i join sag s on i.sagsnr=s.sagsnr
                    join arbejderi a on a.afdnr=s.afdnr and i.initial=a.initial) 
					and (select sagsnr from inserted) is not null  
begin
raiserror('fejl',16,1)
rollback tran
end