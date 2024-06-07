use eksamen23v
drop table if exists matches
drop table if exists teams
go
create table teams
(
Id char(3) primary key,
name varchar(40),
nomatches int,
ourgoals int,
othergoals int,
points int
)
create table matches
(
id int identity(1,1),
homeid char(3) foreign key references teams(id),
outid char(3) foreign key references teams(id),
homegoal int,
outgoal int,
matchdate date
)
insert into teams values('agf','AGF',0,0,0,0)
insert into teams values('fck','FC København',0,0,0,0)
insert into teams values('rfc','Randers FC',0,0,0,0)
insert into teams values('vib','Viborg',0,0,0,0)
insert into teams values('lyn','Lyngby',0,0,0,0)
insert into teams values('ob','OB',0,0,0,0)
insert into teams values('fcm','FC Midtjylland',0,0,0,0)
insert into teams values('bif','Brøndby IF',0,0,0,0)
insert into teams values('fcn','FC Nordsjælland',0,0,0,0)
insert into teams values('vej','Vejle',0,0,0,0)
insert into teams values('sil','Silkeborg',0,0,0,0)
insert into teams values('hvi','Hvidovre',0,0,0,0)
