use UNIVER
create view [Преподаватель]
as 
select TEACHER.TEACHER [Код],
TEACHER_NAME [Имя],
GENDER [Пол],
TEACHER.PULPIT [Кафедра]
from TEACHER;


create view [Количество кафедр] as
select fc.FACULTY_NAME [Факультет], count(pu.PULPIT) as [Количетсво кафедр]
from dbo.FACULTY fc inner join PULPIT pu
on fc.FACULTY = pu.FACULTY
group by fc.FACULTY_NAME;

select * from [Количество кафедр];
select * from [Преподаватель];


create view Аудитории(Аудитория, [Название_Аудитории]) as
select AUDITORIUM, AUDITORIUM_NAME
from AUDITORIUM
WHERE AUDITORIUM_TYPE = N'ЛК';

select * from Аудитории;
insert Аудитории values(N'102-1', N'102-1');
delete Аудитории where [Аудитория] = '102-1%';
update Аудитории set Аудитория = N'666-06' where Аудитория = N'102-1';
select * from Аудитории;


create view Лекционные_Аудитории(Аудитория, [Название_Аудитории], [Тип_аудитории]) as
select AUDITORIUM, AUDITORIUM_NAME, AUDITORIUM_TYPE
from AUDITORIUM
WHERE AUDITORIUM_TYPE = N'ЛК' with check option;

select * from Лекционные_Аудитории;
insert Лекционные_Аудитории values(N'100-3а', N'100-3а', N'ЛБ-К');
select * from Лекционные_Аудитории;
select * from AUDITORIUM;
delete Лекционные_Аудитории where Аудитория = N'100-3а';

create view Дисциплины([Код], [Наименование_дисциплины], [Кафедра]) as
select top 7 SUBJECTT.SUBJECTT, 
SUBJECTT.SUBJECT_NAME ,
SUBJECTT.PULPIT
from SUBJECTT
order by  SUBJECTT.SUBJECTT, 
SUBJECTT.SUBJECT_NAME ,
SUBJECTT.PULPIT;

select *  from Дисциплины; 

alter view [Количество кафедр] with schemabinding as
select fc.FACULTY_NAME [Факультет], count(pu.PULPIT) as [Количетсво кафедр]
from dbo.FACULTY fc inner join dbo.PULPIT pu
on fc.FACULTY = pu.FACULTY
group by fc.FACULTY_NAME;

select * from [Количество кафедр];


sp_help [Количество кафедр];






use Лешук_Mybase;

create view [Заказы_на_рекламу] as
select Передача, Дата_заказа, Длительность_в_минутах
from Заказы;

create view [Отчет_фирм] as
select zak.Название_фирмы_заказчика [Компания], count(per.Заказчик) as [Количество заказов]
from Заказчики zak inner join  Заказы per on zak.Название_фирмы_заказчика = per.Заказчик
group by zak.Название_фирмы_заказчика;

select * from Отчет_фирм;

create view [С_Зимы](Номер, Передача, Вид_рекламы, Дата, Длительность, Заказчик) as
select Номер_заказа, Передача, Вид_рекламы, Дата_заказа, Длительность_в_минутах, Заказчик from Заказы
where Дата_заказа > cast('2022-01-01' as date);
select * from С_Зимы;
insert С_Зимы values (9, '+100500', N'Политика', '2021-03-10', 3, 'The Boring Company');


create view [С_Весны](Номер, Передача, Вид_рекламы, Дата, Длительность, Заказчик) as
select Номер_заказа, Передача, Вид_рекламы, Дата_заказа, Длительность_в_минутах, Заказчик from Заказы
where Дата_заказа > cast('2022-03-01' as date) with check option;

insert С_Весны values (10, '+100500', N'Развлечения', '2020-03-10', 3, 'The Boring Company');


create view [Первые_пять](Передача, Длительность, Дата, Заказчик) as
select top 5 Передача, Длительность_в_минутах, Дата_заказа, Заказчик
from	Заказы
order by Дата_заказа;

select * from Первые_пять;


alter view [Отчет_фирм] with schemabinding as
select zak.Название_фирмы_заказчика [Компания], count(per.Заказчик) as [Количество заказов]
from dbo.Заказчики zak inner join  dbo.Заказы per on zak.Название_фирмы_заказчика = per.Заказчик
group by zak.Название_фирмы_заказчика;

select * from Отчет_фирм;
