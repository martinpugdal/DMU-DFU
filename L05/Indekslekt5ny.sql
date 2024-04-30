use bigdb
go
set statistics time on
set statistics io on
 
select * from big where name = 'Andersen20113'

create clustered index largeind on big(name) 
with fillfactor = 70,PAD_index
go
select * from big where name = 'Andersen20113'
go
-- rebuild genopbygger index, så der igen er den oprindelige fillfactor
-- rebuild svarer stort set til drop og create
alter index largeind
on big
rebuild 

-- reorganize er billigere end rebuild, men også mindre gennemgribende
alter index largeind
on big
reorganize 

-- Hvis man vil definere en default fillfactor   
sp_configure
GO
sp_configure 'show advanced options', 1;
GO
RECONFIGURE;
GO
sp_configure 'fill factor', 90;
GO
RECONFIGURE;
GO


drop index largeind on big
go
-- med nedenstående query kan man få et lille indblik i, hvorledes 
-- søgetræet vil se ud

create clustered index largeind on big(name)
create index nonclusind on big(id)

SELECT	i.name,  
		ps.index_id,
		ps.index_level,
		ps.index_type_desc,
		ps.page_count,
		ps.record_count,
		ps.min_record_size_in_bytes,
		ps.max_record_size_in_bytes,
		ps.avg_record_size_in_bytes,
		ps.partition_number,
		ps.alloc_unit_type_desc,
		ps.index_depth,
		ps.avg_fragmentation_in_percent
	FROM sys.dm_db_index_physical_stats(DB_ID(), object_id('big'), NULL, NULL , 'DETAILED') AS ps INNER JOIN sys.indexes AS i
				ON ps.object_id = i.object_id AND ps.index_id = i.index_id
	ORDER BY index_id, index_level DESC;



-- som default vil SQL Server sætte et clustered index på primary key
-- hvis du gerne ville have at clustered index skulle være på en anden 
-- attribut gør du som herunder
-- 
create table fun
(
id int primary key nonclustered, -- så kan du bruge clustered index et andet sted.
name varchar(30)
)
go
-- Til brug i obligatorisk opgave delopgave 6

-- Man kan som tidligere fortalt også sætte indeks på en kombination af
-- attributter f.eks.

create index fupindeks1 on big(id,name)

-- man kan dog ikke direkte sætte indeks på en beregning
-- som nedenstående eksempel viser
create table fup
(
cpr char(10),
loen int,
fradrag int,
skatteprocent int
)
insert into fup values('12',100000,30000,50)
insert into fup values('13',200000,50000,40)

select (loen-fradrag)*skatteprocent/100 as skat
from fup

-- nedenstående kan derfor ikke lade sig gøre
create index fupindeks2 on fup((loen-fradrag)*skatteprocent/100)

-- man må lige en lille omvej
drop table fup

create table fup
(
cpr char(10),
loen int,
fradrag int,
skatteprocent int,
skat as (loen-fradrag)*skatteprocent/100 persisted
)
insert into fup values('12',100000,30000,50)
insert into fup values('13',200000,50000,40)

create clustered index fupindeks3 on fup(skat)





	