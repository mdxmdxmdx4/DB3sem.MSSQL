create database UNIVER on primary
( name = N'UNIVER_mdf', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UNIVER_mdf.mdf', 
   size = 10240Kb, maxsize=UNLIMITED, filegrowth=1024Kb),
( name = N'UNIVER_ndf', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\ER_ndf.ndf', 
   size = 10240KB, maxsize=1Gb, filegrowth=25%),
filegroup FG1
( name = N'UNIVER_fg1_1', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UNIVER_fgq-1.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%),
( name = N'UNIVER_fg1_2', filename = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UNIVER_fgq-2.ndf', 
   size = 10240Kb, maxsize=1Gb, filegrowth=25%)
log on
( name = N'UNIVER_log', filename=N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\UNIVER_log.ldf',       
   size=10240Kb,  maxsize=2048Gb, filegrowth=10%);


   CREATE TABLE AUDITORIUM_TYPE(
AUDITORIUM_TYPE nchar(10) PRIMARY KEY,
AUDITORIUM_TYPENAME nvarchar(30)) on FG1;

   CREATE TABLE AUDITORIUM 
          (     AUDITORIUM   nchar(20)  primary key,              
      AUDITORIUM_TYPE  nchar(10) foreign key references  
                                                 AUDITORIUM_TYPE(AUDITORIUM_TYPE), 
                AUDITORIUM_CAPACITY  int default 1  
                                            check  (AUDITORIUM_CAPACITY between 1 and 300),  
                AUDITORIUM_NAME  nvarchar(50)                                     
          ) on FG1;

	create table FACULTY(
		  FACULTY nchar(10) primary key not null,
		  FACULTY_NAME nvarchar(50) default '???'
		  ) on FG1;

	create table PULPIT (
		  PULPIT nchar(20) primary key,
		  PULPIT_NAME nvarchar(100),
		  FACULTY nchar(10) foreign key references FACULTY(FACULTY) NOT NULL
		  ) on FG1;

	create table SUBJECTT(
		  SUBJECTT nchar(10) primary key,
		  SUBJECT_NAME nvarchar(100) unique,
		  PULPIT nchar(20) foreign key references PULPIT(PULPIT) not null
		  ) on FG1;
		  
	create table PROFESSION(
		  PROFESSION nchar(20) primary key, 
		  FACULTY nchar(10) foreign key references FACULTY(FACULTY)         ,
		  PROFESSION_NAME nvarchar(100),
		  QUALIFICATION nvarchar(50)
		  ) on FG1;



	create table GROUPP(
		  IDGROUP int primary key  , 
		  FACULTY  nchar(10) foreign key references FACULTY(FACULTY),
		  PROFESSION   nchar(20) foreign key references PROFESSION(PROFESSION),
		  YEAR_FIRST smallint not null,
		  COURSEE AS (YEAR(GETDATE()) - YEAR_FIRST + 1),
		check (YEAR_FIRST < YEAR(GETDATE()) + 2)
		  ) on FG1;

	create table STUDENT(
		   IDSTUDENT int identity(1000, 1) primary key ,
		   IDGROUP int foreign key references GROUPP(IDGROUP),
		   NAME nvarchar(100),
		   BDAY date,
		   STAMP timestamp,
		   INFO xml default null,
		   FOTO varbinary(max) default null
		  ) on FG1;

	create table PROGRESS(
		  SUBJECT nchar(10) foreign key references SUBJECTT(SUBJECTT),
		  IDSTUDENT int foreign key references STUDENT(IDSTUDENT),
		  PDATE date,
		  NOTE int check(NOTE between 1 and 10)
		  ) ON FG1;

		  create table TEACHER
 (   TEACHER    nchar(10)  constraint TEACHER_PK  primary key,
     TEACHER_NAME  nvarchar(100), 
     GENDER     char(1),
     PULPIT   nchar(20) constraint TEACHER_PULPIT_FK foreign key 
                         references PULPIT(PULPIT)
 );


insert into AUDITORIUM_TYPE( AUDITORIUM_TYPE, AUDITORIUM_TYPENAME)
values ('ЛБ-Х', 'Химическая лаборатория'),
('ЛБ-К', 'Компьютерный класс'),
('ЛБ-СК', 'Спец. компьютерный класс'),
('ЛК', 'Лекционная'),
('ЛБ-П', 'Лекционная с уст. проектором');


use UNIVER
select * from dbo.AUDITORIUM;
use UNIVER
select * from dbo.PROGRESS;


select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from dbo.AUDITORIUM inner join dbo.AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from dbo.AUDITORIUM inner join dbo.AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE 
and
(AUDITORIUM_TYPE.AUDITORIUM_TYPENAME  Like N'Компьютер%');



select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM, AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from AUDITORIUM, AUDITORIUM_TYPE
where (AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE) and (AUDITORIUM_TYPE.AUDITORIUM_TYPENAME  Like N'Компьютер%');


select FACULTY.FACULTY, PULPIT.PULPIT, SUBJECTT.SUBJECTT, GROUPP.PROFESSION, STUDENT.NAME,
case
when (PROGRESS.NOTE between 6 and 6) then 'six'
when (PROGRESS.NOTE between 7 and 7) then 'seven'
when (PROGRESS.NOTE between 8 and 8) then 'eight'
else 'another mark'
end as MARK	
from FACULTY inner join PULPIT on PULPIT.FACULTY = FACULTY.FACULTY
inner join SUBJECTT on SUBJECTT.PULPIT = PULPIT.PULPIT
inner join PROGRESS on SUBJECTT.SUBJECTT = PROGRESS.SUBJECT
INNER JOIN STUDENT on STUDENT.IDSTUDENT = PROGRESS.IDSTUDENT 
inner join GROUPP on GROUPP.IDGROUP = student.IDGROUP
order by 1,2,3,4,5 asc, MARK desc;

select FACULTY.FACULTY, PULPIT.PULPIT, SUBJECTT.SUBJECTT, GROUPP.PROFESSION, STUDENT.NAME,
case
when (PROGRESS.NOTE between 6 and 6) then 'six'
when (PROGRESS.NOTE between 7 and 7) then 'seven'
when (PROGRESS.NOTE between 8 and 8) then 'eight'
else 'another mark'
end as MARK
from PROGRESS INNER JOIN STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
            INNER JOIN GROUPP on STUDENT.IDGROUP = GROUPP.IDGROUP 
			INNER JOIN SUBJECTT on PROGRESS.SUBJECT = SUBJECTT.SUBJECTT 
			INNER JOIN PULPIT on SUBJECTT.PULPIT = PULPIT.PULPIT
			inner join  FACULTY on PULPIT.FACULTY = FACULTY.FACULTY
			order by (
			case
			when (PROGRESS.NOTE between 6 and 6) then 3
			when (PROGRESS.NOTE between 7 and 7) then 1
			when (PROGRESS.NOTE between 8 and 8) then 2
			else 4
			end
			);


			select FACULTY.FACULTY, PULPIT.PULPIT, SUBJECTT.SUBJECTT, GROUPP.PROFESSION, STUDENT.NAME
			from PROGRESS 
			INNER JOIN STUDENT on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
            INNER JOIN GROUPP on STUDENT.IDGROUP = GROUPP.IDGROUP 
			INNER JOIN SUBJECTT on PROGRESS.SUBJECT = SUBJECTT.SUBJECTT 
			INNER JOIN PULPIT on SUBJECTT.PULPIT = PULPIT.PULPIT
			inner join  FACULTY on PULPIT.FACULTY = FACULTY.FACULTY;


select PULPIT.PULPIT, isnull(TEACHER.TEACHER, '***') TEACHER	
FROM PULPIT left outer join TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT;

select PULPIT.PULPIT, TEACHER	
FROM TEACHER left outer join PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT;

select PULPIT.PULPIT, isnull(TEACHER.TEACHER, '***') TEACHER	
FROM TEACHER RIGHT outer join PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT;

select isnull(PULPIT.PULPIT, '***') PULPIT, isnull(TEACHER.TEACHER, '***') TEACHER	
FROM TEACHER full outer join PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT;

select isnull(PULPIT.PULPIT, '***') PULPIT, isnull(TEACHER.TEACHER, '***') TEACHER	
FROM PULPIT full outer join TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT;

select isnull(PULPIT.PULPIT, '***') PULPIT, isnull(TEACHER.TEACHER, '***') TEACHER	
FROM PULPIT INNER join TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT;

select TEACHER.TEACHER_NAME, PULPIT.PULPIT
FROM TEACHER full outer join PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT
where PULPIT.PULPIT is null;

select TEACHER.TEACHER_NAME, PULPIT.PULPIT
FROM PULPIT full outer join TEACHER
ON PULPIT.PULPIT = TEACHER.PULPIT
where TEACHER is null;

select PULPIT.PULPIT, TEACHER_NAME
FROM TEACHER full outer join PULPIT
ON PULPIT.PULPIT = TEACHER.PULPIT
where PULPIT.PULPIT is not null;

select AUDITORIUM.AUDITORIUM, AUDITORIUM_TYPE.AUDITORIUM_TYPENAME
from dbo.AUDITORIUM cross join dbo.AUDITORIUM_TYPE
where AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE;




use Лешук_Mybase
select Заказы.Номер_заказа, Заказчики.Название_фирмы_заказчика, Заказы.Дата_заказа
from Заказчики full outer join Заказы
on Заказы.Заказчик = Заказчики.Название_фирмы_заказчика;

select Заказы.Номер_заказа, Передачи.Название_передачи, Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах as Стоимость, Заказчики.Название_фирмы_заказчика,
case
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 0 and 50) then 'low'
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 50 and 140) then 'middle'
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 140 and 1000) then 'large'
else 'another type'
end as Бюджет
from Заказы INNER JOIN Передачи on Заказы.Передача = Передачи.Название_передачи 
inner join Заказчики on Заказчики.Название_фирмы_заказчика = Заказы.Заказчик;

select Заказы.Номер_заказа, Передачи.Название_передачи, 
Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах as Стоимость, Заказчики.Название_фирмы_заказчика,
case
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 0 and 50) then 'low'
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 50 and 140) then 'middle'
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 140 and 1000) then 'large'
else 'another type'
end as Бюджет
from Заказы INNER JOIN Передачи on Заказы.Передача = Передачи.Название_передачи 
inner join Заказчики on Заказчики.Название_фирмы_заказчика = Заказы.Заказчик
order by (
case
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 0 and 50) then 1
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 50 and 140) then 3
when ((Передачи.Стоимость_минуты * Заказы.Длительность_в_минутах) between 140 and 1000) then 2
end
);

select * from Заказы cross join Передачи
where Заказы.Передача = Передачи.Название_передачи
and Вид_рекламы like N'Развлечения';

select isnull(Номер_заказа, '101010') Cтатус_заказа, Название_передачи, Рейтинг from Заказы full outer join Передачи
on Заказы.Передача = Передачи.Название_передачи
where Заказчик is null;

select Номер_заказа, Название_передачи, Рейтинг, Длительность_в_минутах from Заказы full outer join Передачи
on Заказы.Передача = Передачи.Название_передачи
where Заказчик is not null
order by Рейтинг desc;

select Номер_заказа, Название_передачи, Рейтинг, Длительность_в_минутах from Заказы full outer join Передачи
on Заказы.Передача = Передачи.Название_передачи
order by Рейтинг desc;