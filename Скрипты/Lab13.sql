use univer;
 ----- 1)
create function COUNT_STUDENTS(@faculty nvarchar(20) = null) returns int
as
begin
declare @rc int = 0;
set @rc = (select count(*)
from STUDENT inner join GROUPP on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join FACULTY ON GROUPP.FACULTY = FACULTY.FACULTY
where FACULTY.FACULTY = @faculty);
return @rc;
end;

declare @f int = dbo.COUNT_STUDENTS(N'ИТ');
PRINT N'Кол-во студентов = ' + cast(@f as varchar(3));

alter function COUNT_STUDENTS(@faculty nvarchar(20), @prof nvarchar(20) = null) returns int
as
begin
declare @rc int = 0;
set @rc = (select count(*)
from STUDENT inner join GROUPP on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join FACULTY ON GROUPP.FACULTY = FACULTY.FACULTY
where FACULTY.FACULTY = @faculty and GROUPP.PROFESSION = @prof);
return @rc;
end;

declare @f int = dbo.COUNT_STUDENTS(N'ИТ', '1-75 02 01');
PRINT N'Кол-во студентов = ' + cast(@f as varchar(3));


select distinct FACULTY.FACULTY, PROFESSION, dbo.COUNT_STUDENTS(faculty.FACULTY, PROFESSION) 
from STUDENT
inner join GROUPP on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join FACULTY on FACULTY.FACULTY = GROUPP.FACULTY


----- 2)
create function FSUBJECTS(@p nchar(20)) returns nchar(300)
as
begin
declare @tv nchar(20);
declare @t nvarchar(300) = N'Дисциплины: ';
declare SubjOnPulpit cursor local
for select SUBJECTT.SUBJECTT from SUBJECTT
where SUBJECTT.PULPIT = @p;
open SubjOnPulpit;
fetch SubjOnPulpit into @tv;
while @@FETCH_STATUS = 0
begin 
set @t = @t+ ',' + rtrim(@tv);
fetch SubjOnPulpit into @tv;
end;
return @t;
end;

select pulpit, dbo.FSUBJECTS(PULPIT)
from PULPIT;

----- 3)

create function FFACPUL(@fac nvarchar(10), @pul nvarchar(10)) returns table
as return
select f.FACULTY, p.PULPIT
from FACULTY f left outer join PULPIT p
on f.FACULTY = p.FACULTY
where f.FACULTY = isnull(@fac, f.FACULTY)
and p.PULPIT = isnull(@pul, p.PULPIT);

select * from dbo.FFACPUL(NULL, NULL);
select * from dbo.FFACPUL(NULL, N'ИСиТ');
select * from dbo.FFACPUL(N'ХТиТ', NULL);
select * from dbo.FFACPUL(N'ИТ', N'ИСиТ');

---  4)

create function FCTEACHER(@pul nvarchar(300)) returns int
as
begin
declare @rc int = (SELECT count(TEACHER.TEACHER) from TEACHER
inner join PULPIT on TEACHER.PULPIT = PULPIT.PULPIT 
where TEACHER.PULPIT = isnull(@pul,TEACHER.PULPIT) );
return @rc;
end;


select PULPIT, DBO.FCTEACHER(PULPIT) [Кол-во преподавателей]
from TEACHER
group by PULPIT;

select distinct DBO.FCTEACHER(NULL) [Всего преподавателей] from TEACHER;


 -------    7) 
 create function FACULTY_REPORT(@c int) returns @fr table
	                        ( [Факультет] nvarchar(50), [Количество кафедр] int, [Количество групп]  int, 
	                                                                 [Количество студентов] int, [Количество специальностей] int )
	as begin 
                 declare cc CURSOR static for 
	       select FACULTY.FACULTY from FACULTY 
                                                    where dbo.COUNT_STUDENTS(FACULTY, NULL) < @c; 
	       declare @f nvarchar(30);
	       open cc;  
                 fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f,  (select count(PULPIT) from PULPIT where FACULTY = @f),
	            (select count(IDGROUP) from GROUPP where FACULTY = @f),   dbo.COUNT_STUDENTS(@f, NULL),
	            (select count(PROFESSION) from PROFESSION where FACULTY = @f)   ); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;

	select * from FACULTY_REPORT(1);

	create function Find_Pulpit_byF(@f nvarchar(10)) returns  int
	as begin
	declare @rc int = (select count(PULPIT) from PULPIT where FACULTY = @f);
	return @rc;
	end;

	create function Find_Group_byF(@f nvarchar(10)) returns  int
	as begin
	declare @rc int =  (select count(IDGROUP) from GROUPP where FACULTY = @f);
	return @rc;
	end;

	create function Find_Prof_byF(@f nvarchar(10)) returns  int
	as begin
	declare @rc int =  (select count(PROFESSION) from PROFESSION where FACULTY = @f) ;
	return @rc;
	end;

	declare @i int = dbo.Find_Prof_byF(N'ИТ')s
	print cast(@i as varchar(5));


alter function FACULTY_REPORT(@c int) returns @fr table
	                        ( [Факультет] nvarchar(50), [Количество кафедр] int, [Количество групп]  int, 
	                                                                 [Количество студентов] int, [Количество специальностей] int )
	as begin 
                 declare cc CURSOR static for 
	       select FACULTY.FACULTY from FACULTY 
                                                    where dbo.COUNT_STUDENTS(FACULTY, NULL) < @c; 
	       declare @f nvarchar(30);
	       open cc;  
                 fetch cc into @f;
	       while @@fetch_status = 0
	       begin
	            insert @fr values( @f,  dbo.Find_Pulpit_byF(@f),
				dbo.Find_Group_byF(@f),   dbo.COUNT_STUDENTS(@f, NULL),
	            dbo.Find_Prof_byF(@f)   ); 
	            fetch cc into @f;  
	       end;   
                 return; 
	end;

		select * from FACULTY_REPORT(1);



-- Leshuk_Mybase

use Лешук_Mybase;

create function COUNT_Orders(@f nvarchar(20) = null) returns int
as
begin
declare @rc int = 0;
set @rc = (select count(Номер_заказа)
from Заказы inner join Заказчики on Заказы.Заказчик = Заказчики.Название_фирмы_заказчика
where Заказчики.Название_фирмы_заказчика = @f);
return @rc;
end;

declare @f int = dbo.COUNT_Orders(N'707 Inc.');
PRINT N'Кол-во заказов = ' + cast(@f as varchar(3));

alter function COUNT_Orders(@f nvarchar(20), @vid nvarchar(20)) returns int
as
begin
declare @rc int = 0;
set @rc = (select count(*)
from Заказы inner join Заказчики on Заказы.Заказчик = Заказчики.Название_фирмы_заказчика
where Заказчики.Название_фирмы_заказчика = @f and Заказы.Вид_рекламы = @vid);
return @rc;
end;

declare @f int = dbo.COUNT_Orders(N'707 Inc.', N'Развлечения');
PRINT N'Кол-во заказов = ' + cast(@f as varchar(3));


alter function FORDERS(@tz nchar(20)) returns nchar(300)
as
begin
declare @tv nchar(20);
declare @t nvarchar(300) = N'Заказанные эфиры: ';
declare ZkOrder cursor local
for select Передача from Заказы
where Заказчик = @tz;
open ZkOrder;
fetch ZkOrder into @tv;
while @@FETCH_STATUS = 0
begin 
set @t = @t+ ',' + rtrim(@tv);
fetch ZkOrder into @tv;
end;
return @t;
end;

select Название_фирмы_заказчика, dbo.FORDERS(Название_фирмы_заказчика)
from Заказчики;

--exec sp_rename 'old_title' , 'new_title'