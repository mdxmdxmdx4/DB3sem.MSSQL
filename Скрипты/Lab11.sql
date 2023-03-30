--    1)    
	set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )	            
	drop table X;   

	declare @c int, @flag char = 'r';           -- commit или rollback?
	SET IMPLICIT_TRANSACTIONS  ON   -- включ. режим неявной транзакции
	CREATE table X(K int );                         -- начало транзакции 
		INSERT X values (1),(2),(3);
		set @c = (select count(*) from X);
		print N'количество строк в таблице X: ' + cast( @c as varchar(2));
		if @flag = 'c'  commit;                   -- завершение транзакции: фиксация 
	          else   rollback;                                 -- завершение транзакции: откат  
      SET IMPLICIT_TRANSACTIONS  OFF   -- выключ. режим неявной транзакции
	
	if  exists (select * from  SYS.OBJECTS       -- таблица X есть?
	            where OBJECT_ID= object_id(N'DBO.X') )
	print N'таблица X есть';  
      else print N'таблицы X нет'



declare @c1 int;
set implicit_transactions on
create table V (FIRST nchar(5));
insert V values (N'раз'),(N'два'),(N'три'),(N'пятьы');
set @c1 = (select count(*) from V);
		print N'количество строк в таблице X: ' + cast( @c1 as varchar(2));
		if @c1 <= 3 commit;
		else rollback;
		set implicit_transactions off;

		if  exists (select * from  SYS.OBJECTS       -- таблица есть?
	            where OBJECT_ID= object_id(N'DBO.V') )
	print N'таблица V есть';  
      else print N'таблицы V нет'

	        set nocount on
	if  exists (select * from  SYS.OBJECTS        -- таблица есть?
	            where OBJECT_ID= object_id(N'DBO.V') )	            
	drop table V;  

--  2)

use UNIVER
begin try
begin tran
--insert GROUPP(IDGROUP, FACULTY, PROFESSION, YEAR_FIRST) values (51, N'ИТ', '1-89 02 02', 2021);
--delete GROUPP where IDGROUP = 31;
update GROUPP set FACULTY = N'ИТ' where YEAR_FIRST = 2015;
--alter table GROUPP drop column IDGROUP;
truncate table GROUPP;
commit tran;
end try
begin catch
print N'Ошибка: ' + case
when error_number() = 547 and patindex('%FK%', error_message()) > 0
then N'Несоответствие внешнего  ключа'
when error_number() = 2627 and patindex('%PK%', error_message()) > 0 
then N'Дублирование строки недопусимо'
else N'Неизвестная ошибка, ' + cast(error_number() as varchar(5)) + error_message()
end;
if @@TRANCOUNT > 0 rollback tran;
end catch;



------3)
declare @point varchar(32)
begin try
begin tran
delete AUDITORIUM where AUDITORIUM.AUDITORIUM = '322-1'
set @point = 'p1'; save tran @point;
insert AUDITORIUM values (N'439-3а', N'ЛБ-К', 15, N'439-3а');
set @point = 'p2'; save tran @point
update AUDITORIUM set AUDITORIUM_TYPE = 'Секретная' where AUDITORIUM_CAPACITY = 15;
set @point = 'p3'; save tran @point
truncate table AUDITORIUM;
set @point = 'p4'; save tran @point
insert AUDITORIUM values (N'439-3а', N'ЛБ-К', 15, N'439-3а');
commit tran;
end try
begin catch
print N'Ошибка: ' + case when error_number() = 2627 and patindex('%PK%', error_message()) > 0 
THEN N'Дублирование аудитории'
when error_number() = 547 and patindex('%FK%', error_message()) > 0
then N'Несоответствие внешнего  ключа'
when error_number() = 4712
then N'Невозможно применить TRUNCATE'
else N'Неизвестная ошибка' + cast(error_number() as varchar(5)) + error_message()
end;
if @@TRANCOUNT > 0
begin
print N'контрольная точка: ' + @point;
rollback tran @point;
commit tran;
end;
end catch;


----------------------4)
---A---
set transaction isolation level READ UNCOMMITTED
begin transaction
----------t1---------
select @@SPID, N'insert PROGRESS'N'результат', *
FROM SUBJECTT where SUBJECTT LIKE(N'СУБД%');
select @@SPID, N'update PROGRESS'N'результат', * from PROGRESS
where SUBJECT LIKE(N'СУБД%');

----------t2-------- 
---B---
begin transaction
select @@SPID
insert PROGRESS values(N'СУБД', 1041, CAST('2022-01-01' AS DATE), 6);
update PROGRESS set SUBJECT = N'СУБД' where SUBJECT = N'БД%'
-----------t1-----------
-----------t2-----------
rollback;


-------------------5)
------A--------
set transaction isolation level READ COMMITTED
begin transaction
select COUNT(*) from PROGRESS where SUBJECT = N'СУБД';
----------------t1---------
----------------t2---------
select N'update PROGRESS'N'результат', count(*)
from PROGRESS where SUBJECT = N'СУБД';
commit;

----B----
begin transaction
---------t1-------
update PROGRESS set SUBJECT = N'СУБД'
where SUBJECT = N'БД'
commit;
------t2----------

 

-----------6)---------
    ------A------
set transaction isolation level repeatable read
begin transaction
select IDSTUDENT from PROGRESS where SUBJECT =  N'СУБД';
---------t1-------
---------t2-------
select case 
when IDSTUDENT = 1000 THEN N'insert Заказы' else ''
end N'результат', IDSTUDENT
FROM PROGRESS WHERE SUBJECT =  N'СУБД';
commit;

     ------B--------
begin transaction
-----------t1-----------
insert PROGRESS values(N'СУБД', 1000, CAST('2016-01-29' AS DATE), 6)
COMMIT;
-------------t2--------

----- 7)
    ---A---
set transaction isolation level SERIALIZABLE
begin transaction
delete PROGRESS where IDSTUDENT = 1000;
INSERT PROGRESS values(N'СУБД', 1000, CAST('2016-06-12' AS DATE), 7);
update PROGRESS set IDSTUDENT = 1000 WHERE SUBJECT = N'СУБД%';
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'СУБД%';
------------t1-------
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'СУБД%';
commit;

-----B----
begin transaction
delete PROGRESS where IDSTUDENT = 1000;
INSERT PROGRESS values(N'СУБД', 1000, CAST('2016-06-12' AS DATE), 7);
update PROGRESS set IDSTUDENT = 1000 WHERE SUBJECT = N'СУБД%';
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'СУБД%';
-------------t1-----------
commit;
select IDSTUDENT from PROGRESS WHERE SUBJECT = N'СУБД%';
----------------t2-----------


------- 8)
begin tran
insert STUDENT values(51, N'Полевой Дмитрий Тимофеевич', 2004-03-28);
begin tran
update PROGRESS set IDSTUDENT = 1042 WHERE IDSTUDENT = 1001;
commit
if @@TRANCOUNT > 0
rollback;
select
(select count(*) from progress where IDSTUDENT = 1042) 'E. of 1042',
(select count(*) from STUDENT WHERE NAME = N'Полевой%')  'Student';