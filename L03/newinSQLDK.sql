
-- ***************************************
-- Example with transactions and try catch
-- ***************************************

insert into Person values('12','Paul','systemudvikler',400000,'8000')
insert into Person values('13','Jan','programmør',340000,'8000')

-- transaction with runtime error - no automatic rollback
set xact_abort off
begin tran
insert into Person values('16','Pauline','systemudvikler',500000,'8000')
insert into Person values('17','Britney','programmør',340000000000,'8000')
commit tran
--
select * from person

-- a correct transactional solution (but not the best)
begin tran
insert into Person values('18','Pauline','systemudvikler',500000,'8000')
if @@error = 0
 begin 
   insert into Person values('19','Britney','programmør',340000000000,'8000')
   if @@error = 0 
     commit tran
   else
     rollback tran 
 end
else
  rollback tran
go 
--
select * from person
--
-- a solution a bit better but still not the best
begin tran
declare @error int
insert into Person values('18','Pauline','systemudvikler',500000,'8000')
set @error = @@error
if @error = 0
   insert into Person values('19','Britney','programmør',340000000000,'8000')
set @error = @error + @@error
if @error = 0
-- new insert
set @error = @error + @@error
if @error = 0
    commit tran
else
    rollback tran 
go
 -- a solution using try catch
begin tran
Begin try
  insert into Person values('21','Pauline','systemudvikler',500000,'8000')
  insert into Person values('22','Britney','programmør',340000000000,'8000')
  commit tran
  print 'all well'
end try
begin catch
  rollback tran
  print 'error occured'
  print error_message()
end catch  
go
--
insert into Person values('31','Peter','systemudvikler',420000,'8000')
insert into Person values('32','Roy','programmør',540000,'8000')
select * from person

-- *******************
-- the new TOP command
-- *******************

-- example old top
 select top 2 navn,loen
 from person
 order by loen desc
 
 -- now it can be used with percent
 select top 25 percent navn,loen
 from person
 order by loen desc
 
 select * from person
 -- now it can be used with update and delete
 update top (25) percent person set loen = loen*2  


 -- well it did not work, so we try something else
 update Person set loen = loen * 2 where cpr in 
 (select top (25) percent cpr from Person order by loen asc)
 
 -- but we did not use the top in the update any longer !!!!
 
 select * from person 
 -- ************************
 --  OUTPUT command
 -- ************************
 
 delete from Person output deleted.* where loen < 700000
 -- the delete har now returned a result-set as a select would have done.
 
 -- you can also use it with a table variable

 delete from ansati
 declare @resulttable table 
 (
 name varchar(30),
 salary int
 ) 
  delete from Person output deleted.navn,deleted.loen into @resulttable
   where loen < 810000
 select * from @resulttable
 --

 select * from person
 
insert into Person values('34','Peter the second','systemudvikler',420000,'8000')
insert into Person values('35','Roy the second','programmør',540000,'8000')

 -- ******************************
 -- COMMON TABLE EXPRESSIONS (CTE)
 -- ******************************
 -- here is a normal example of the use of CTE
 -- finds the average salary among the half with the highest salary
 go
 WITH derige(cpr)
 AS (select top 50 percent cpr
    from Person
    order by loen desc)
    
 select AVG(p.loen)
 from Person p, derige r
 where p.cpr=r.cpr  
 go
 -- this is the same as 
 select AVG(p.loen)
 from Person p,
    (select top 50 percent cpr
    from Person
    order by loen desc) as r
 where p.cpr=r.cpr 
 
 -- ************************
 --     CTE and recursion
 -- ************************
 create table fatherson
 (father varchar(20),
  son varchar(20)
  )
  -- This means that BeBob is the father of Bob and Alan and so on
  insert into fatherson values('BeBob','Bob')
  insert into fatherson values('BeBob','Alan')
  insert into fatherson values('BeBeBob','BeBob')
  insert into fatherson values('BeBeBob','BeAlan')
  insert into fatherson values('BeBeBeBob','BeBeBob')
  insert into fatherson values('BeBeBeBeBob','BeBeBeBob')
  insert into fatherson values('BeBeBeBeBob','BeBeBeAlan')
  insert into fatherson values('BeBeBeAlan','BeBeAlan')
  insert into fatherson values('BeBeAlan','BeAlan2')
  

  --
  -- I want all the descendants of BeBeBeBob'
  -- This can de done with a big union
  select son 
  from fatherson
  where father = 'BeBeBeBob'
  union
  select f2.son 
  from fatherson f1, fatherson f2
  where f2.father = f1.son and f1.father = 'BeBeBeBob'  
  union
  select f3.son 
  from fatherson f1, fatherson f2,fatherson f3
  where f3.father= f2.son and f2.father = f1.son and f1.father = 'BeBeBeBob' 
  
  
  
  -- this is impossible if you do not know the how deep to go
  go
  -- this problem can be solved, if we use CTE to make recursion
  with fathsonCTE(x)
  as
  (
  select son
  from fatherson
  where father = 'BeBeBeBob'
  union all
  select f.son
  from fatherson as f
  join fathsonCTE as ff
  on f.father = ff.x
  )
  select x from fathsonCTE  
  
  


-- 
  -- ******************* 
  -- New 2008 stuff
  -- *******************
  declare @d date
  declare @t time
  declare @dt datetime
  set @d = GETDATE()
  set @t = GETDATE()
  set @dt = GETDATE()
  select @d
  select @t
  select @dt
  --
  go
  declare @dt date
  declare @dt2 datetime
  set @dt = '2024.2.5'
  set @dt2 = getdate()
  if @dt = @dt2
  select 'ens'
  else
  select 'ikke ens'  

  declare @x int
  declare @y int
  set @x = 7
  set @y = 9
  set @x += @y
  select @x,@y