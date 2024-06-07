use eksamen23v
-- uddrag fra løsning på superligaopgaven (1. afleveringsopgave)
go
create or alter trigger trig1
on matches
for insert,update
as
declare @homeid char(3)
declare @outid char(3)
declare @homegoal int
declare @outgoal int
declare @homepoint int
declare @outpoint int
select @homeid=homeid,@outid=outid,@homegoal=homegoal,@outgoal=outgoal
from inserted
if @homegoal > @outgoal
begin
  set @homepoint = 3
  set @outpoint = 0
end else
  if @homegoal < @outgoal
  begin
    set @homepoint = 0
    set @outpoint = 3
  end
  else
    begin
    set @homepoint = 1
    set @outpoint = 1
  end  
 update teams set nomatches = nomatches + 1,ourgoals = ourgoals + @homegoal,
                  othergoals = othergoals + @outgoal, points = points + @homepoint
              where id = @homeid 
 update teams set nomatches = nomatches + 1,ourgoals = ourgoals + @outgoal,
                  othergoals = othergoals + @homegoal, points = points + @outpoint
              where id = @outid 
go   
create or alter trigger trig2
on matches
for delete,update
as
declare @homeid char(3)
declare @outid char(3)
declare @homegoal int
declare @outgoal int
declare @homepoint int
declare @outpoint int
select @homeid=homeid,@outid=outid,@homegoal=homegoal,@outgoal=outgoal
from deleted
if @homegoal > @outgoal
begin
  set @homepoint = 3
  set @outpoint = 0
end else
  if @homegoal < @outgoal
  begin
    set @homepoint = 0
    set @outpoint = 3
  end
  else
    begin
    set @homepoint = 1
    set @outpoint = 1
  end  
 update teams set nomatches = nomatches - 1,ourgoals = ourgoals - @homegoal,
                  othergoals = othergoals - @outgoal, points = points - @homepoint
              where id = @homeid 
 update teams set nomatches = nomatches - 1,ourgoals = ourgoals - @outgoal,
                  othergoals = othergoals - @homegoal, points = points - @outpoint
              where id = @outid 
 go        

-- 1
insert into matches values('fcm','hvi',1,0,'2023-7-21')
insert into matches values('lyn','fck',1,2,'2023-7-22')
insert into matches values('agf','vej',1,0,'2023-7-23')
insert into matches values('ob','rfc',2,2,'2023-7-23')
insert into matches values('sil','bif',1,2,'2023-7-23')
insert into matches values('fcn','vib',4,1,'2023-7-24')
-- 2
insert into matches values('vib','lyn',2,2,'2023-7-28')
insert into matches values('vej','fck',2,3,'2023-7-29')
insert into matches values('fcm','sil',2,0,'2023-7-30')
insert into matches values('rfc','hvi',2,2,'2023-7-30')
insert into matches values('bif','ob',1,2,'2023-7-30')
insert into matches values('agf','fcn',1,3,'2023-7-31')
-- 3
insert into matches values('sil','vej',2,1,'2023-8-4')
insert into matches values('fck','rfc',4,0,'2023-8-5')
insert into matches values('hvi','agf',0,2,'2023-8-6')
insert into matches values('lyn','fcm',4,1,'2023-8-6')
insert into matches values('fcn','bif',3,1,'2023-8-6')
insert into matches values('ob','vib',1,2,'2023-8-7')
-- 4
insert into matches values('fck','ob',2,1,'2023-8-11')
insert into matches values('vej','fcm',1,2,'2023-8-13')
insert into matches values('rfc','fcn',0,5,'2023-8-13')
insert into matches values('bif','lyn',3,0,'2023-8-13')
insert into matches values('agf','sil',2,2,'2023-8-13')
insert into matches values('vib','hvi',0,0,'2023-8-14')
-- 5
insert into matches values('hvi','fck',0,2,'2023-8-18')
insert into matches values('sil','fcn',2,0,'2023-8-20')
insert into matches values('lyn','rfc',1,0,'2023-8-20')
insert into matches values('fcm','bif',0,1,'2023-8-20')
insert into matches values('ob','agf',1,1,'2023-8-20')
insert into matches values('vib','vej',2,1,'2023-8-21')
-- 6
insert into matches values('rfc','vib',1,0,'2023-8-25')
insert into matches values('fck','sil',1,3,'2023-8-26')
insert into matches values('agf','lyn',1,0,'2023-8-27')
insert into matches values('hvi','ob',1,5,'2023-8-27')
insert into matches values('fcn','fcm',3,0,'2023-8-27')
insert into matches values('vej','bif',0,1,'2023-8-28')
-- 7
insert into matches values('ob','vej',1,2,'2023-9-1')
insert into matches values('sil','hvi',1,0,'2023-9-3')
insert into matches values('lyn','fcn',1,1,'2023-9-3')
insert into matches values('bif','rfc',3,1,'2023-9-3')
insert into matches values('fck','vib',2,0,'2023-9-3')
insert into matches values('fcm','agf',1,1,'2023-9-3')
-- 8
insert into matches values('vib','fcm',2,2,'2023-9-15')
insert into matches values('fcn','fck',2,2,'2023-9-16')
insert into matches values('vej','rfc',1,2,'2023-9-17')
insert into matches values('hvi','lyn',0,1,'2023-9-17')
insert into matches values('agf','bif',0,3,'2023-9-17')
insert into matches values('ob','sil',0,3,'2023-9-18')
-- 9
insert into matches values('lyn','vej',1,1,'2023-9-22')
insert into matches values('sil','vib',2,0,'2023-9-24')
insert into matches values('bif','fck',2,3,'2023-9-24')
insert into matches values('rfc','agf',1,1,'2023-9-24')
insert into matches values('fcm','ob',2,1,'2023-9-24')
insert into matches values('fcn','hvi',0,0,'2023-9-25')
-- 10
insert into matches values('fck','fcm',0,2,'2023-9-30')
insert into matches values('vej','fcn',0,0,'2023-10-1')
insert into matches values('rfc','sil',1,0,'2023-10-1')
insert into matches values('hvi','bif',0,3,'2023-10-1')
insert into matches values('vib','agf',2,1,'2023-10-1')
insert into matches values('ob','lyn',1,2,'2023-10-2')
--
-- 11
insert into matches values('sil','lyn',5,0,'2023-10-6')
insert into matches values('fcn','ob',0,1,'2023-10-8')
insert into matches values('vej','hvi',3,1,'2023-10-8')
insert into matches values('bif','vib',1,0,'2023-10-8')
insert into matches values('fcm','rfc',2,2,'2023-10-8')
insert into matches values('agf','fck',1,1,'2023-10-8')

-- 12
insert into matches values('hvi','sil',1,2,'2023-10-20')
insert into matches values('fck','vej',2,1,'2023-10-21')
insert into matches values('lyn','agf',0,2,'2023-10-22')
insert into matches values('vib','fcn',0,2,'2023-10-22')
insert into matches values('rfc','bif',2,2,'2023-10-23')
insert into matches values('ob','fcm',1,2,'2023-10-23')

-- 13
insert into matches values('fcm','lyn',2,1,'2023-10-27')
insert into matches values('fck','hvi',4,0,'2023-10-28')
insert into matches values('vej','vib',1,1,'2023-10-29')
insert into matches values('sil','ob',0,0,'2023-10-29')
insert into matches values('bif','fcn',2,1,'2023-10-29')
insert into matches values('agf','rfc',2,1,'2023-10-30')

-- 14
insert into matches values('lyn','ob',2,2,'2023-11-4')
insert into matches values('fcn','vej',1,0,'2023-11-5')
insert into matches values('vib','sil',2,1,'2023-11-5')
insert into matches values('rfc','fck',2,4,'2023-11-5')
insert into matches values('hvi','fcm',1,4,'2023-11-5')
insert into matches values('bif','agf',1,1,'2023-11-6')

-- 15
insert into matches values('sil','rfc',1,1,'2023-11-10')
insert into matches values('fck','bif',0,0,'2023-11-12')
insert into matches values('vej','lyn',1,0,'2023-11-12')
insert into matches values('fcm','fcn',2,0,'2023-11-12')
insert into matches values('ob','hvi',0,2,'2023-11-12')
insert into matches values('agf','vib',2,0,'2023-11-12')

-- 16
insert into matches values('hvi','vej',1,1,'2023-11-24')
insert into matches values('vib','fck',2,1,'2023-11-25')
insert into matches values('fcn','agf',0,0,'2023-11-26')
insert into matches values('rfc','ob',0,1,'2023-11-26')
insert into matches values('lyn','bif',3,3,'2023-11-26')
insert into matches values('sil','fcm',1,4,'2023-11-27')

--17
insert into matches values('rfc','vej',0,0,'2023-12-1')
insert into matches values('ob','fcn',1,1,'2023-12-3')
insert into matches values('lyn','sil',2,0,'2023-12-3')
insert into matches values('bif','hvi',4,0,'2023-12-3')
insert into matches values('fck','agf',1,2,'2023-12-3')
insert into matches values('fcm','vib',5,1,'2023-12-4')

--18
insert into matches values('vib','ob',1,2,'2024-2-16')
insert into matches values('fcn','lyn',3,2,'2024-2-18')
insert into matches values('hvi','rfc',1,3,'2024-2-18')
insert into matches values('sil','fck',0,3,'2024-2-18')
insert into matches values('bif','fcm',1,0,'2024-2-18')
insert into matches values('vej','agf',0,0,'2024-2-19')

--
-- shows the scoretable          
select * from teams 
order by points desc,ourgoals-othergoals desc,ourgoals desc 


-- OPGAVE 4
go
create proc calcscoretable
@until datetime
as
declare @t table
(
id char(3),
name varchar(40),
nomatches int,
ourgoals int,
othergoals int,
points int
)
insert into @t select ID,name,0,0,0,0 from teams
declare @homepoint int,@outpoint int
declare p cursor
for select homeid,outid,homegoal,outgoal from matches 
where matchdate <= @until
declare @homeid char(3),@outid char(3),@homegoal int,@outgoal int
open p
fetch p into @homeid,@outid,@homegoal,@outgoal
while @@fetch_status != -1
begin
  if @homegoal > @outgoal
  begin
    set @homepoint = 3
    set @outpoint = 0
  end else
    if @homegoal < @outgoal
    begin
      set @homepoint = 0
      set @outpoint = 3
    end
    else
    begin
      set @homepoint = 1
      set @outpoint = 1
    end  
  update @t set nomatches = nomatches + 1,ourgoals = ourgoals + @homegoal,
                  othergoals = othergoals + @outgoal, points = points + @homepoint
              where id = @homeid 
  update @t set nomatches = nomatches + 1,ourgoals = ourgoals + @outgoal,
                  othergoals = othergoals + @homegoal, points = points + @outpoint
              where id = @outid 
  
  fetch p into @homeid,@outid,@homegoal,@outgoal
end
close p
deallocate p  
select * from @t 
order by points desc,ourgoals-othergoals desc,ourgoals desc 
go 
exec calcscoretable '2023.09.01'
go


-- OPGAVE 5
go
create proc findleader
as
declare @t table
(
id char(3),
name varchar(40),
nomatches int,
ourgoals int,
othergoals int,
points int
)
insert into @t select ID,name,0,0,0,0 from teams
declare @homepoint int,@outpoint int
declare @oldmatchdate datetime
declare @name varchar(40)
declare p cursor
for select homeid,outid,homegoal,outgoal,matchdate 
from matches order by matchdate

declare @homeid char(3),@outid char(3),@homegoal int,@outgoal int,@matchdate datetime
open p
fetch p into @homeid,@outid,@homegoal,@outgoal,@matchdate
set @oldmatchdate=@matchdate
set nocount on
while @@fetch_status != -1
begin
  if @oldmatchdate<@matchdate
  begin
     select top 1 @name=name from @t order by points desc,ourgoals-othergoals desc,ourgoals desc 
     print 'On date ' + cast (@oldmatchdate as varchar) + ' the leader is ' + @name
     set @oldmatchdate=@matchdate
  end
  if @homegoal > @outgoal
  begin
    set @homepoint = 3
    set @outpoint = 0
  end else
    if @homegoal < @outgoal
    begin
      set @homepoint = 0
      set @outpoint = 3
    end
    else
    begin
      set @homepoint = 1
      set @outpoint = 1
    end  
  update @t set nomatches = nomatches + 1,ourgoals = ourgoals + @homegoal,
                  othergoals = othergoals + @outgoal, points = points + @homepoint
              where id = @homeid 
  update @t set nomatches = nomatches + 1,ourgoals = ourgoals + @outgoal,
                  othergoals = othergoals + @homegoal, points = points + @outpoint
              where id = @outid 
  
  fetch p into @homeid,@outid,@homegoal,@outgoal,@matchdate
end
close p
deallocate p 
select top 1 @name=name from @t order by points desc,ourgoals-othergoals desc,ourgoals desc 
     print 'On date ' + cast (@matchdate as varchar) + ' the leader is ' + @name  
go 
exec findleader
go


-- Delopgave 6

drop table teams
go
create table teams
(
Id char(3) primary key nonclustered,
name varchar(40),
nomatches int,
owngoals int,
othergoals int,
points int,
diff as owngoals-othergoals persisted
)



create clustered index testind 
on teams(points desc,diff desc,owngoals desc,id)



select name,nomatches,owngoals,othergoals,points
from teams 

