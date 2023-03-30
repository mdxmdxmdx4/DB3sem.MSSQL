use UNIVER
exec sp_helpindex 'AUDITORIUM_TYPE'
exec sp_helpindex 'AUDITORIUM'
exec sp_helpindex 'FACULTY'
exec sp_helpindex 'GROUPP'
exec sp_helpindex 'PROFESSION'
exec sp_helpindex 'PULPIT'
exec sp_helpindex 'STUDENT'
exec sp_helpindex 'SUBJECTT'
exec sp_helpindex 'TEACHER';

create table #EXPLRE (
TIND int,
TFIELD varchar(100)
);

set nocount on;
declare @i int = 0
while @i < 1001
begin
insert #EXPLRE(TIND,TFIELD)
values(floor(23456*rand()), replicate('str', 4))
if (@i  % 100 = 0) print @i
set @i = @i + 1
end;
select * from #EXPLRE
where TIND between 1500 and 2500 order by TIND;
-- = 0.0066
checkpoint;

DBCC DROPCLEANBUFFERS;
create clustered index #EXPLRE_CL on #EXPLRE(TIND asc);
select * from #EXPLRE
where TIND between 1500 and 2500 order by TIND;
--0.0033

create table #EX
(TKEY int,
CC int identity(1,1),
TF varchar(40));	

set nocount on
declare @ii int = 0
while @ii < 1000
begin
insert #EX(TKEY, TF)
values(floor(30000*rand()), REPLICATE(N'строка', 6));
set @ii = @ii + 1;
end;
select count(*) [num_of_strings] from #EX;
select * from #EX;
select * from #EX Where TKEY > 1500 and  CC < 4500;
--0.0095
create index #EX_NONCLU on #EX(TKEY,CC)

select * from #EX Where TKEY > 1500 and  CC < 4500;
--0.0095
SELECT *  from #EX order by TKEY, CC;

select * from #EX wheRE TKEY = 1971 and CC > 3;
--0.0032


create table #THIRDTABLE (
FIRSTR int,
SECONDR varchar(100),
THIRDR float
)

set nocount on
declare @iii int = 0
while @iii < 1000
begin
insert #THIRDTABLE(FIRSTR,SECONDR, THIRDR)
values(floor(30000*rand()), REPLICATE(N'строка', 10), 0.464*floor(30000*rand()));
set @iii = @iii + 1;
end;

select * from #THIRDTABLE;
select THIRDR from #THIRDTABLE WHERE FIRSTR > 1555;
--0.0117
create index #THIRDTABLE_FIRSTR_X on #THIRDTABLE(FIRSTR) include (THIRDR);
select THIRDR from #THIRDTABLE WHERE FIRSTR > 1555;
--0.0063

create table #FOURT(
TKEY INT);

set nocount on
declare @a int = 0
while @a < 1222
begin
insert #FOURT(TKEY)
values(floor(34139*rand()));
set @a = @a + 1;
end;

select * from #FOURT;

SELECT * FROM #FOURT where TKEY between 5000 and 20000;
--0.006
SELECT * FROM #FOURT where TKEY = 17812;
--0.0061
create index #FOURT_WHERE on #FOURT(TKEY) where (TKEY >= 5000 AND TKEY < 20000);
SELECT * FROM #FOURT where TKEY >= 5000 and  TKEY < 20000;
--0.0038

set nocount on
declare @ii int = 0
while @ii < 1000
begin
insert #EX(TKEY, TF)
values(floor(30000*rand()), REPLICATE(N'нест', 6));
set @ii = @ii + 1;
end;

select * from #EX;
create index #EX_TKEY on #EX(TKEY);

INSERT top(100000) #EX(TKEY, TF) select TKEY, TF from #EX;
select count(*) from #EX;

SELECT name [Индекс], avg_fragmentation_in_percent
        FROM sys.dm_db_index_physical_stats(DB_ID('tempdb'), 
        OBJECT_ID('#EX'), NULL, NULL, NULL) ss
        join  sys.indexes on ss.object_id = sys.indexes.object_id and ss.index_id = sys.indexes.index_id  
     WHERE name is not null;
-- приблизительно 95%

alter index #EX_TKEY on #EX reorganize;  
alter index #EX_NONCLU ON #EX rebuild with(online = off) 

drop index #EX_TKEY on #EX;
CREATE INDEX #EX_TKEY ON #EX(TKEY)
with (fillfactor = 65);

insert top(50)percent into #EX(TKEY, TF)
select TKEY, TF FROM #EX;


USE Лешук_Mybase;

exec sp_helpindex N'Заказчики'
exec sp_helpindex N'Заказы'
exec sp_helpindex N'Передачи'

select * from dbo.Заказы;
-- 0,00329
create index #Order on Заказы(Номер_заказа asc);
--drop index #Order on Заказы;
select * from dbo.Заказы
where Номер_заказа between 1 and 10
order by Номер_заказа;

create index #Combinated on Заказы(Номер_заказа, Передача, Заказчик);
select * from Заказы where Номер_заказа > 3 and Передача like '%о%' ;
--0.00328
select * from Заказы where Номер_заказа = 8 and Дата_заказа > CAST('2019-01-01' as date) and Передача like '%а%';
--0.00328

create index #Cover on Заказы(Номер_заказа) include (Длительность_в_минутах)
select Длительность_в_минутах 
from Заказы
where Номер_заказа > 2
--0.00328

select Длительность_в_минутах from Заказы where Длительность_в_минутах > 2 and Длительность_в_минутах < 10 ;

create index #Order_where on Заказы(Длительность_в_минутах) where (Длительность_в_минутах > 2 and  Длительность_в_минутах < 10)

 SELECT name [Индекс], avg_fragmentation_in_percent
        FROM sys.dm_db_index_physical_stats(DB_ID('Лешук_Mybase'), 
        OBJECT_ID('Заказы'), NULL, NULL, NULL) ss
        join  sys.indexes on ss.object_id = sys.indexes.object_id and ss.index_id = sys.indexes.index_id  
                                                                                                    WHERE name is not null;
alter index #Order on Заказы reorganize;