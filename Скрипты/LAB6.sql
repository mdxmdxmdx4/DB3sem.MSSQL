select min(AUDITORIUM.AUDITORIUM_CAPACITY) [Min_Capacity],
 max(AUDITORIUM.AUDITORIUM_CAPACITY) [Max_Capacity],
 avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Avg_Capacity],
 count(*) [Numb_of_auditoriums],
 sum(AUDITORIUM.AUDITORIUM_CAPACITY) [all_capacity]
from AUDITORIUM;

select AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM_TYPENAME,
SUM(AUDITORIUM_CAPACITY) [Capacity_of_type],
avg(AUDITORIUM.AUDITORIUM_CAPACITY) [Avg_Capacity],
min(AUDITORIUM.AUDITORIUM_CAPACITY) [Min_Capacity],
max(AUDITORIUM.AUDITORIUM_CAPACITY) [Max_Capacity],
count(*) [Numb_of_auditoriums]
from AUDITORIUM inner join AUDITORIUM_TYPE
on AUDITORIUM.AUDITORIUM_TYPE = AUDITORIUM_TYPE.AUDITORIUM_TYPE
group by AUDITORIUM.AUDITORIUM_TYPE, AUDITORIUM_TYPENAME;
  
select *
from (
select
case
when PROGRESS.NOTE like 10 then '10'
when PROGRESS.NOTE between 8 and 9 then '8-9'
when PROGRESS.NOTE between 6 and 7 then '6-7'
when PROGRESS.NOTE between 4 and 5 then '4-5'
end [Оценки], count(*) [Количество]	
from PROGRESS
group by
case 
when PROGRESS.NOTE like 10 then '10'
when PROGRESS.NOTE between 8 and 9 then '8-9'
when PROGRESS.NOTE between 6 and 7 then '6-7'
when PROGRESS.NOTE between 4 and 5 then '4-5'
end
) as T
order by case [Оценки]
when '10' then 1
when '8-9' then 2
when '4-5' then 4
when '6-7' then 3
else 0
end;

select FACULTY.FACULTY,
 GROUPP.PROFESSION,
 GROUPP.COURSEE,
 ROUND(AVG(CAST(PROGRESS.NOTE as float(4))), 2) as [Средняя_оценка]
from FACULTY inner join GROUPP
on FACULTY.FACULTY = GROUPP.FACULTY inner join STUDENT
on STUDENT.IDGROUP = GROUPP.IDGROUP inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
group by 
FACULTY.FACULTY,
GROUPP.PROFESSION,
GROUPP.COURSEE;

select FACULTY.FACULTY,
 GROUPP.PROFESSION,
 GROUPP.COURSEE,
 PROGRESS.SUBJECT,
 ROUND(AVG(CAST(PROGRESS.NOTE as float(4))), 2) as [Средняя_оценка]
from FACULTY inner join GROUPP
on FACULTY.FACULTY = GROUPP.FACULTY inner join STUDENT
on STUDENT.IDGROUP = GROUPP.IDGROUP inner join PROGRESS
on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
Where PROGRESS.SUBJECT like N'%ОАиП%' or PROGRESS.SUBJECT like N'БД%'
group by 
FACULTY.FACULTY,
GROUPP.PROFESSION,
GROUPP.COURSEE,
PROGRESS.SUBJECT;


select FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from FACULTY inner join GROUPP on FACULTY.FACULTY = GROUPP.FACULTY 
inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT;


select FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from FACULTY inner join GROUPP on FACULTY.FACULTY = GROUPP.FACULTY 
inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by rollup  (FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT);

select FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from FACULTY inner join GROUPP on FACULTY.FACULTY = GROUPP.FACULTY 
inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by rollup  (PROGRESS.SUBJECT, GROUPP.PROFESSION, FACULTY.FACULTY);


select FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from FACULTY inner join GROUPP on FACULTY.FACULTY = GROUPP.FACULTY 
inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by cube  (FACULTY.FACULTY, GROUPP.PROFESSION, PROGRESS.SUBJECT);


select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT;

select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ХТиТ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT;



select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ХТиТ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT
union
select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT;



select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ХТиТ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT
union all
select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT;

select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ТОВ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT
except
select GROUPP.PROFESSION, PROGRESS.SUBJECT, avg(PROGRESS.NOTE) [avg_note]
from GROUPP inner join STUDENT on STUDENT.IDGROUP = GROUPP.IDGROUP
inner join PROGRESS on PROGRESS.IDSTUDENT = STUDENT.IDSTUDENT
where GROUPP.FACULTY = N'ХТиТ'
group by GROUPP.PROFESSION, PROGRESS.SUBJECT;

select P1.SUBJECT, P1.NOTE,
(SELECT COUNT(*) from PROGRESS P2
WHERE P2.SUBJECT = P1.SUBJECT 
AND P2.NOTE = P1.NOTE) [Количество]
from PROGRESS P1
group by p1.SUBJECT, p1.NOTE
having NOTE = 8 or NOTE = 9;



-- for Leshuk_Mybase

select max(Стоимость_минуты) [max_price],
min(Стоимость_минуты) [ min_price],
count(Стоимость_минуты) [kolvo],
sum(Стоимость_минуты) [sum_price]
from dbo.Передачи;


select Заказы.Вид_рекламы,
max(Длительность_в_минутах) [max_timing],
count(Длительность_в_минутах) [numer_of_type]
from  Передачи inner join Заказы 
on Передачи.Название_передачи = Заказы.Передача
group by Заказы.Вид_рекламы;

select *
from (
select
case
when Стоимость_минуты > 30 then '>30'
when Стоимость_минуты between 21 and 30 then '21-30'
when Стоимость_минуты between 11 and 20 then '11-20'
when Стоимость_минуты between 1 and 10 then '1-10'
end [Цена_Минуты], count(*) [Количество]	
from Передачи
group by
case 
when Стоимость_минуты > 30 then '>30'
when Стоимость_минуты between 21 and 30 then '21-30'
when Стоимость_минуты between 11 and 20 then '11-20'
when Стоимость_минуты between 0 and 10 then '0-10'
end
) as T
order by case [Цена_Минуты]
when '>30' then 4
when '21-30' then 1
when '11-20' then 2
when '0-10' then 3
else 0
end;

select Заказчики.Название_фирмы_заказчика,
 ROUND(AVG(CAST(Длительность_в_минутах as float(4))), 2) as [Средняя_длительность],
 ROUND(AVG(CAST(Стоимость_минуты as float(4))), 2) as [Средняя_стоимость]
from Передачи inner join Заказы
on Передачи.Название_передачи = Заказы.Передача inner join Заказчики
on Заказы.Заказчик = Заказчики.Название_фирмы_заказчика
group by 
Заказчики.Название_фирмы_заказчика;


select Заказчики.Название_фирмы_заказчика,
 ROUND(AVG(CAST(Длительность_в_минутах as float(4))), 2) as [Средняя_длительность],
 ROUND(AVG(CAST(Стоимость_минуты as float(4))), 2) as [Средняя_стоимость]
from Передачи inner join Заказы
on Передачи.Название_передачи = Заказы.Передача inner join Заказчики
on Заказы.Заказчик = Заказчики.Название_фирмы_заказчика
where Вид_рекламы = N'Развлечение' or Вид_рекламы = N'Трудоустройство'
group by 
Заказчики.Название_фирмы_заказчика;

Select Передача, sum(Длительность_в_минутах) [Суммарная_длительность]
from Заказы
where Вид_рекламы like N'Развлечения' or Вид_рекламы like N'Политика'
gROUP By Передача;

Select Передача, Вид_Рекламы,sum(Длительность_в_минутах) [Суммарная_длительность]
from Заказы
where Вид_рекламы like N'Развлечения' or Вид_рекламы like N'Политика'
gROUP By rollup (Передача,Вид_Рекламы);

Select Передача, Вид_Рекламы,sum(Длительность_в_минутах) [Суммарная_длительность]
from Заказы
where Вид_рекламы like N'Развлечения' or Вид_рекламы like N'Политика'
gROUP By cube (Передача,Вид_Рекламы);


select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = '707 Inc.'
group by Передача
union all
select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = 'Appricot Gaming'
group by Передача;



select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = '707 Inc.'
group by Передача
intersect
select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = 'Appricot Gaming'
group by Передача;

select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = '707 Inc.'
group by Передача
except
select Передача, sum(Длительность_в_минутах) [sum_leng]
from Заказы where Заказчик = 'Appricot Gaming'
group by Передача;


select P1.Передача, P1.Дата_заказа,
(SELECT COUNT(*) from Заказы P2
WHERE P2.Дата_заказа = P1.Дата_заказа 
AND P2.Передача = P1.Передача) [Количество]
from Заказы P1
group by P1.Передача, P1.Дата_заказа
having Дата_заказа > CAST('2021-06-01' as date);


