use tempdb
exec sp_addtype cprtype,'char(10)'
go


create table testperson
(
cpr cprtype,
name varchar(25)
)
go
create rule cprrule
as isdate(substring(@x,5,2)+substring(@x,3,2)+substring(@x,1,2))=1 

go
sp_bindrule cprrule,cprtype

-- sp_unbindrule cprtype
-- drop rule cprrule

insert into testperson values('2212603611 ','OK') -- OK with date and modulus 11
insert into testperson values('1002893211','OK too') -- OK with date and modulus 11
insert into testperson values('1002895211','not OK') -- OK date wrong modulus 11
insert into testperson values('3002893217','wrong date') -- wrong date
go


-- Modulus 11 check

--2212603611 -- cprnummer, der skal checkes
--4327654321 -- en fast streng for cpr-registeret

--2*4+2*3+1*2+2*7+6*6+0*5+3*4+6*3+1*2+1*1 = 99
--Hvis cpr er korrekt går 11 op i summen


--2*4+2*3+1*2+2*7+6*6+0*5+3*4+6*3+1*2+1*1=99 --et tal hvor 11 går op
go
