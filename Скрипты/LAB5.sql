use UNIVER
select distinct PULPIT.PULPIT_NAME, FACULTY.FACULTY --,needed_p.PROFESSION_NAME
from (select PROFESSION.PROFESSION_NAME from
PROFESSION 
where (PROFESSION_NAME like N'%технологии%' OR PROFESSION_NAME like N'%технология%')) as needed_p
inner join PROFESSION ON PROFESSION.PROFESSION_NAME = needed_p.PROFESSION_NAME
inner join PULPIT on PROFESSION.FACULTY = PULPIT.FACULTY
inner join FACULTY on FACULTY.FACULTY = PULPIT.FACULTY;


--1)
select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT, FACULTY
where
PULPIT.FACULTY = FACULTY.FACULTY and
PULPIT.FACULTY in (select FACULTY from PROFESSION
where (PROFESSION_NAME like N'%технологии%' OR PROFESSION_NAME like N'%технология%'));


select PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on
PULPIT.FACULTY = FACULTY.FACULTY 
where
PULPIT.FACULTY in (select FACULTY from PROFESSION
where (PROFESSION_NAME like N'%технологии%' OR PROFESSION_NAME like N'%технология%'));


select distinct PULPIT.PULPIT_NAME, FACULTY.FACULTY
from PULPIT inner join FACULTY on PULPIT.FACULTY = FACULTY.FACULTY 
inner join PROFESSION ON PROFESSION.FACULTY = PULPIT.FACULTY 
where (PROFESSION_NAME like N'%технологии%' OR PROFESSION_NAME like N'%технология%'); 


select AUDITORIUM_TYPE, AUDITORIUM, AUDITORIUM_CAPACITY AS max_capacity
from AUDITORIUM v
where v.AUDITORIUM_CAPACITY = (
select top(1) vv.AUDITORIUM_CAPACITY from AUDITORIUM vv
where vv.AUDITORIUM_TYPE = v.AUDITORIUM_TYPE 
order by AUDITORIUM_CAPACITY desc);


select FACULTY
from FACULTY
where not exists (select * from PULPIT
where PULPIT.FACULTY = FACULTY.FACULTY);


select top 1
(select avg(NOTE) from PROGRESS
where SUBJECT LIKE N'%СУБД%') [СУБД],
(select avg(NOTE) from PROGRESS
where PROGRESS.SUBJECT LIKE N'БД') [БД],
(select avg(NOTE) from PROGRESS
where PROGRESS.SUBJECT LIKE N'%ОАиП%') [ОАиП]
from PROGRESS;

select AUDITORIUM.AUDITORIUM_CAPACITY,	AUDITORIUM.AUDITORIUM_TYPE
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_CAPACITY <= all (select AUDITORIUM_CAPACITY from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like N'ЛК-П%');

select AUDITORIUM.AUDITORIUM_CAPACITY,	AUDITORIUM.AUDITORIUM_TYPE
from AUDITORIUM
where AUDITORIUM.AUDITORIUM_CAPACITY > any (select AUDITORIUM_CAPACITY from AUDITORIUM
where AUDITORIUM.AUDITORIUM_TYPE like N'ЛК-П%');




use Лешук_Mybase
select Заказы.Передача, Заказы.Вид_рекламы, Заказы.Дата_заказа, Рейтинг
from Заказы, Передачи
where Заказы.Передача = Передачи.Название_передачи and
Заказчик in (select Название_фирмы_заказчика from Заказчики
where Контактное_лицо like N'Нечай-Ницевич%');

select Заказы.Передача, Заказы.Вид_рекламы, Заказы.Дата_заказа, Рейтинг
from Заказы inner join Передачи
on Заказы.Передача = Передачи.Название_передачи and
Заказчик in (select Название_фирмы_заказчика from Заказчики
where Контактное_лицо like N'Нечай-Ницевич%');

select Заказы.Передача, Заказы.Вид_рекламы, Заказы.Дата_заказа, Рейтинг
from Заказы inner join Передачи
on Заказы.Передача = Передачи.Название_передачи
inner join Заказчики on Заказчики.Название_фирмы_заказчика = Заказы.Заказчик
where(Контактное_лицо like N'Нечай-Ницевич%');


select Передача, Длительность_в_минутах
from Заказы a
where Заказчик = (select top(1) Заказчик from Заказы aa
where aa.Передача = a.Передача
order by Длительность_в_минутах desc);

select Название_передачи
from Передачи
where not exists (select * from Заказы
where Заказы.Передача = Передачи.Название_передачи);

select top 1
(select avg(Длительность_в_минутах) from Заказы
where Заказчик LIKE N'Appricot Gaming%') [AG_avgtime],
(select avg(Длительность_в_минутах) from Заказы
where Передача LIKE N'Что? Где? Когда?%') [CGK_avgtime]
from Заказы;

select Передача, Длительность_в_минутах
from Заказы
where Длительность_в_минутах >= (select Длительность_в_минутах from Заказы
where Передача like N'%утки%');

select Передача, Длительность_в_минутах
from Заказы
where Длительность_в_минутах >= any (select Длительность_в_минутах from Заказы
where Передача like N'%500%');

select BDAY, NAME
from STUDENT
where BDAY in (select BDAY from STUDENT 
group by BDAY
having count(BDAY) > 1
)
order by bday asc;