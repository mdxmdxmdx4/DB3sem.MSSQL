declare ISIT_SUBJ cursor
for select SUBJECTT.SUBJECTT
from SUBJECTT
WHERE SUBJECTT.PULPIT = N'ИСиТ';
declare @tv nchar(20), @t nchar(300) = N'';
OPEN ISIT_SUBJ;
FETCH ISIT_SUBJ into @tv;
while @@FETCH_STATUS = 0
begin
set @t = RTRIM(@tv) + ', ' + @t;
fetch ISIT_SUBJ into @tv;
end;
print N'Предметы кафедры ИСиТ: ' + @t
close ISIT_SUBJ;


declare THNSIPPM_SUBJ CURSOR LOCAL
for select SUBJECTT.SUBJECTT
from SUBJECTT
WHERE SUBJECTT.PULPIT = N'ТНХСиППМ';
declare @tv nchar(20);
open THNSIPPM_SUBJ;
fetch THNSIPPM_SUBJ into @tv;
print '1 >>> '  + @tv
go
declare @tv nchar(20)
fetch THNSIPPM_SUBJ into @tv;
print '2 >>> '  + @tv
go

declare HTEPIMEE_SUBJ CURSOR GLOBAL
for select SUBJECTT.SUBJECTT
from SUBJECTT
WHERE SUBJECTT.PULPIT = N'ХТЭПиМЭЕ';
open HTEPIMEE_SUBJ;
declare @tv nchar(20);
fetch HTEPIMEE_SUBJ into @tv;
print '1 >>> '  + @tv
go
declare @tv nchar(20);
fetch HTEPIMEE_SUBJ into @tv;
print '2 >>> '  + @tv
go
close HTEPIMEE_SUBJ
deallocate HTEPIMEE_SUBJ;

declare @ids int, @gr int, @name nchar(50), @bday date;
declare STDENTS_A1999 CURSOR LOCAL DYNAMIC --DYNAMIC
for select IDSTUDENT, IDGROUP, NAME, BDAY
FROM STUDENT
WHERE BDAY > CAST('1999-01-01' AS date);
open STDENTS_A1999
fetch STDENTS_A1999 INTO @ids, @gr, @name, @bday;
PRINT  N'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
update STUDENT set BDAY = cast('1998-01-01' as date) where IDSTUDENT = 1018;
--DELETE STUDENT where IDSTUDENT = 1010;
INSERT STUDENT(IDGROUP, NAME, BDAY) VALUES (29, N'Дворянинкин Максим Анатольевич', cast('2001-01-01' as date));
while @@FETCH_STATUS = 0
begin
print cast(@ids as varchar(5)) + ' ' + cast(@gr as varchar(5)) + ' ' + @name + ' ' + cast(@bday as varchar(15)) + '.';
fetch STDENTS_A1999 INTO @ids, @gr, @name, @bday;
end;
close STDENTS_A1999;

DECLARE @tc int = 0, @fk nchar(10), @fk_full nchar(55);
declare PRIMER1 cursor local dynamic scroll
for 
select ROW_NUMBER() over (order by FACULTY) N,
FACULTY.FACULTY, FACULTY.FACULTY_NAME
FROM FACULTY;
OPEN PRIMER1;
FETCH first from PRIMER1 into @tc, @fk, @fk_full;
print N'Первая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH last from PRIMER1 into @tc, @fk, @fk_full;
print N'последняя строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH ABSOLUTE 3 from PRIMER1 into @tc, @fk, @fk_full;
print N'Третья строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH next from PRIMER1 into @tc, @fk, @fk_full;
print N'Следующая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH prior from PRIMER1 into @tc, @fk, @fk_full;
print N'Предыдущая строка : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH absolute -2 from PRIMER1 into @tc, @fk, @fk_full;
print N'Вторая строка с конца : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);
FETCH relative -1 from PRIMER1 into @tc, @fk, @fk_full;
print N'Relative -1 : ' + cast(@tc as varchar(3)) +' ' + rtrim(@fk) + ' ' + rtrim(@fk_full);


declare @one int, @two nchar(10), @thr date, @fur int, @stid int = 1012;
declare PRIMER2 CURSOR LOCAL DYNAMIC FOR 
select PROGRESS.IDSTUDENT, PROGRESS.SUBJECT, PROGRESS.PDATE, PROGRESS.NOTE
from PROGRESS inner join STUDENT on  PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
INNER JOIN GROUPP ON GROUPP.IDGROUP = STUDENT.IDGROUP 
WHERE PROGRESS.NOTE < 4
FOR UPDATE;
declare PRIMER3 CURSOR LOCAL DYNAMIC FOR
SELECT * FROM PROGRESS
WHERE IDSTUDENT = @stid;
OPEN PRIMER2;
fetch PRIMER2 into @one, @two, @thr, @fur;
delete PROGRESS where current of PRIMER2;
close PRIMER2;
open PRIMER3
fetch PRIMER3 into @one, @two, @thr, @fur;
update PROGRESS set NOTE = NOTE + 1 where current of PRIMER3;
closE PRIMER3;
 

 -- для БД ЛЕШУК_Mybase
 use Лешук_Mybase

declare FUN_ADS cursor
for select distinct Заказы.Заказчик
from Заказы
WHERE Вид_рекламы = N'Развлечения';
declare @tv nchar(20), @t nchar(300) = N'';
OPEN FUN_ADS;
FETCH FUN_ADS into @tv;
while @@FETCH_STATUS = 0
begin
set @t = RTRIM(@tv) + ', ' + @t;
fetch FUN_ADS into @tv;
end;
print N'Компании, предлагающие развлекательную рекламу: ' + @t
close FUN_ADS;

declare PRIMER_X cursor local dynamic scroll
for 
select ROW_NUMBER() over (order by Заказы.Номер_заказа) N, Передача, Заказчик
FROM Заказы;
DECLARE @num int = 0, @per nchar(25), @zak nchar(25);
OPEN PRIMER_X;
FETCH first from PRIMER_X into @num, @per, @zak;
print N'Первая строка            : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH last from PRIMER_X into @num, @per, @zak;
print N'Последняя строка         : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH ABSOLUTE 3 from PRIMER_X into @num, @per, @zak;
print N'Третья строка            : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH next from PRIMER_X into @num, @per, @zak;
print N'Следующая строка         : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH prior from PRIMER_X into @num, @per, @zak;
print N'Предыдущая строка        : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH absolute -4 from PRIMER_X into @num, @per, @zak;
print N'Четвертая строка с конца : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH relative -2 from PRIMER_X into @num, @per, @zak;
print N'Relative -2              : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
FETCH last from PRIMER_X into @num, @per, @zak;
print N'Relative 2               : ' + cast(@num as varchar(3)) +' ' + rtrim(@per) + ' ' + rtrim(@zak);
close PRIMER_X;


declare order_707 cursor local
for
select Передача, Дата_заказа
from Заказы
where Заказчик = '707 Inc.';
declare @pered nchar(25), @date date;
open order_707;
fetch order_707 into @pered, @date
print '1) >>->>' +' ' + rtrim(@pered) + ' ' + cast(@date as varchar(15));
go
open order_707;
fetch order_707 into @pered, @date
print '2) >>->>' +' ' + rtrim(@pered) + ' ' + cast(@date as varchar(15));

declare order_707g cursor global
for
select Передача, Дата_заказа
from Заказы
where Заказчик = '707 Inc.';
declare @pered1 nchar(25), @date1 date;
open order_707g;
fetch order_707g into @pered1, @date1
print '1) >>->>' +' ' + rtrim(@pered1) + ' ' + cast(@date1 as varchar(15));
go
declare @pered1 nchar(25), @date1 date;
fetch order_707g into @pered1, @date1
print '2) >>->>' +' ' + rtrim(@pered1) + ' ' + cast(@date1 as varchar(15));
go
close order_707g
deallocate order_707g;


--dynamic / static
declare @ids int, @dat date, @name nchar(25), @cust nchar(35);
declare ORDRS_A2021 CURSOR LOCAL dynamic
for select Номер_заказа, Дата_заказа, Передача, Заказчик
FROM Заказы
WHERE Дата_заказа > CAST('2021-06-06' AS date);
open ORDRS_A2021;
PRINT  N'Количество строк : ' + cast(@@CURSOR_ROWS as varchar(5)); 
update Заказы set Дата_заказа = cast('2020-11-11' as date) where Номер_заказа = 1;
DELETE Заказы where Номер_заказа = 11
INSERT Заказы(Номер_заказа, Дата_заказа, Передача, Заказчик, Вид_рекламы, Длительность_в_минутах) VALUES (10, cast('2021-08-12' as date), N'Поле чудес', 'DvoryaninkiN', N'Развлечения', 5);
fetch ORDRS_A2021 INTO @ids, @dat, @name, @cust;
while @@FETCH_STATUS = 0
begin
print cast(@ids as varchar(5)) + ' ' + cast(@dat as varchar(15)) + ' ' + @name + ' ' + @cust + '.';
fetch ORDRS_A2021 INTO @ids, @dat, @name, @cust;
end;
close ORDRS_A2021;



select * from Заказы;