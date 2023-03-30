---      1)
use UNIVER;

--пример с raw
select rtrim(t.TEACHER) N'Код преподавателя', rtrim(t.TEACHER_NAME) N'ФИО преподавателя', rtrim(t.GENDER) N'Пол', rtrim(t.PULPIT) N'Кафедра'
from TEACHER t
where PULPIT = N'ИСиТ' for xml raw(N'Преподаватель'), root(N'Список_преподавателей'), elements;

--path
select rtrim(t.PULPIT) as '@Pulpit', rtrim(t.TEACHER) N'Код_преподавателя', rtrim(t.TEACHER_NAME) N'ФИО_преподавателя', rtrim(t.GENDER) N'ФИО_преподавателя/пол'
from TEACHER t
where PULPIT = N'ИСиТ' 
for xml path, root(N'Список_преподавателей'), elements;

--- 2)

select  t1.AUDITORIUM, t2.AUDITORIUM_TYPE, t1.AUDITORIUM_CAPACITY
from AUDITORIUM t1 join AUDITORIUM_TYPE t2
on t1.AUDITORIUM_TYPE = t2.AUDITORIUM_TYPE
where t2.AUDITORIUM_TYPE = N'ЛК'
order by t1.AUDITORIUM for xml auto,
root('Список_преподавателей'), elements;

--- 3)


declare @h int = 0,
@x varchar(2000) = N'<?xml version= "1.0" encoding = "windows-1251" ?>
<ROOT>
<subj SUBJECT = "FIS" SUBJECT_NAME = "Fundamentals of Informational Security" PULPIT = "ENG"/>
<subj SUBJECT = "FT" SUBJECT_NAME = "Frequency Theory" PULPIT = "ENG"/>
<subj SUBJECT = "ISP" SUBJECT_NAME = "Inner Systems Programming" PULPIT = "ENG"/>
</ROOT>';
exec sp_xml_preparedocument @h output,@x;
insert SUBJECTT select [SUBJECT],[SUBJECT_NAME],[PULPIT]
from openxml(@h,'/ROOT/subj',0)
with([SUBJECT] nvarchar(10),[SUBJECT_NAME] nvarchar(200),[PULPIT] nvarchar(10))
exec sp_xml_removedocument @h;

select * from SUBJECTT



----    4)

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'Шимко Никита Дмитриевич', cast('25-10-2003' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>АВ</Серия>
<Номер_паспорта>2253151</Номер_паспорта>
<Дата_выдачи>2019.13.11
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Беларусь</Страна>
<Город>Барановичи</Город>
<Улица>Наконечникова</Улица>
</Адрес>
</Контактная_информация>')

update STUDENT set INFO = N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>7123591</Номер_паспорта>
<Дата_выдачи>2018.03.09
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Москва</Город>
<Улица>Дубининская</Улица>
</Адрес>
</Контактная_информация>'
where IDSTUDENT = 1014

select STUDENT.NAME,
INFO.value(N'(/Контактная_информация/Паспортные_данные/Серия)[1]',N'nvarchar(20)')[Серия],
INFO.value(N'(/Контактная_информация/Паспортные_данные/Номер_паспорта)[1]',N'nvarchar(20)')[Номер],
INFO.query(N'/Контактная_информация/Адрес') [Адрес]
from STUDENT
where INFO is not null


--- 5)
drop xml schema collection STUDENT;

CREATE XML SCHEMA COLLECTION STUDENT1 AS
N'<?xml version="1.0" encoding="utf-16" ?>
<xs:schema attributeFormDefault = "unqualified"
elementFormDefault="qualified"
xmlns:xs="http://www.w3.org/2001/XMLSchema">
<xs:element name="Контактная_информация">
<xs:complexType>
<xs:sequence>
<xs:element name="Паспортные_данные" maxOccurs="1" minOccurs="1">
<xs:complexType>
<xs:sequence>
<xs:element name="Серия" type="xs:string"/>
<xs:element name="Номер_паспорта" type="xs:integer"/>
<xs:element name="Дата_выдачи" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
<xs:element name="Адрес">
<xs:complexType>
<xs:sequence>
<xs:element name="Страна" type="xs:string"/>
<xs:element name="Город" type="xs:string"/>
<xs:element name="Улица" type="xs:string"/>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:sequence>
</xs:complexType>
</xs:element>
</xs:schema>';

alter table STUDENT ALTER COLUMN INFO xml(STUDENT1)

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'Пекарев Ефросий Евгеньевич', cast('30-08-2002' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>8974521</Номер_паспорта>
<Дата_выдачи>2018.04.04
</Дата_выдачи>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Урюпинск</Город>
<Улица>Ленина</Улица>
</Адрес>
</Контактная_информация>')

select * from STUDENT where NAME = N'Пекарев Ефросий Евгеньевич'

insert STUDENT(IDGROUP, NAME, BDAY, INFO)
values(51, N'Беков Магомед Иванович', cast('06-07-1999' as date), 
N'<Контактная_информация>
<Паспортные_данные>
<Серия>МР</Серия>
<Номер_паспорта>6712817</Номер_паспорта>
<Дата_выдачи>2015.09.09
</Дата_выдачи>
</Паспортные_данные>
<Паспортные_данные>
<Серия>МР</Серия>
</Паспортные_данные>
<Адрес>
<Страна>Россия</Страна>
<Город>Уфа</Город>
</Адрес>
</Контактная_информация>')



