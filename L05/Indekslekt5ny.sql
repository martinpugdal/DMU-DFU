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
-- rebuild genopbygger index, s� der igen er den oprindelige fillfactor
-- rebuild svarer stort set til drop og create
alter index largeind
on big
rebuild 

-- reorganize er billigere end rebuild, men ogs� mindre gennemgribende
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
-- med nedenst�ende query kan man f� et lille indblik i, hvorledes 
-- s�getr�et vil se ud

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



-- som default vil SQL Server s�tte et clustered index p� primary key
-- hvis du gerne ville have at clustered index skulle v�re p� en anden 
-- attribut g�r du som herunder
-- 
create table fun
(
id int primary key nonclustered, -- s� kan du bruge clustered index et andet sted.
name varchar(30)
)
go
-- Til brug i obligatorisk opgave delopgave 6

-- Man kan som tidligere fortalt ogs� s�tte indeks p� en kombination af
-- attributter f.eks.

create index fupindeks1 on big(id,name)

-- man kan dog ikke direkte s�tte indeks p� en beregning
-- som nedenst�ende eksempel viser
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

-- nedenst�ende kan derfor ikke lade sig g�re
create index fupindeks2 on fup((loen-fradrag)*skatteprocent/100)

-- man m� lige en lille omvej
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





	