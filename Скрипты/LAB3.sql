use master;
create database Лешук_Mybase;

create table Передачи (
Название_передачи nvarchar(30) not null primary key,
Рейтинг nvarchar(10) ,
Стоимость_минуты smallmoney not null
);


create table Заказчики(
Название_фирмы_заказчика nvarchar(20) not null primary key,
Банковские_реквизиты int not null,
Телефон int not null,
Контактное_лицо nvarchar(50)
);

create table Заказы(
Номер_заказа int not null primary key,
Передача nvarchar(30) not null foreign key references Передачи(Название_передачи),
Заказчик nvarchar(20) not null foreign key references Заказчики(Название_фирмы_заказчика),
Вид_рекламы nvarchar(20) not null,
Дата_заказа date not null,
Длительность_в_минутах int not null
);

alter table dbo.Заказы add Некоторый_столбец int;
alter table dbo.Заказы add Статус nvarchar(12) default 'не выполнен' check(Статус in('выполнен', 'не выполнен'));
alter table dbo.Заказы drop column Некоторый_столбец;
alter table dbo.Заказы drop constraint CK__Заказы__Статус__35BCFE0A;
alter table dbo.Заказы drop constraint DF__Заказы__Статус__34C8D9D1;
alter table dbo.Заказы drop column Статус;

insert into Передачи( Название_передачи, Рейтинг, Стоимость_минуты)
values('+100500', '8.1', 20),	
('Versus', '7.3', 30),
('Хлебоутки', '7.0', 15),
('Следствие вели', '6.5', 15),
('Что? Где? Когда?', '8.6', 23);

insert into dbo.Заказчики (Название_фирмы_заказчика, Банковские_реквизиты, Телефон, Контактное_лицо)
values('707 Inc.', 1213141, 333123142, 'Нечай-Ницевич Д. П.'),
('Appricot Gaming', 9981234, 298109144,'Лопух П. Л.'),
('The Boring Company', 7777777, 110103041, 'Илон М.'),
('Valve Inc.', 8787187, 1234567, 'Гейб Н.');

insert into dbo.Заказы (Номер_заказа, Передача, Заказчик, Вид_рекламы, Дата_заказа, Длительность_в_минутах)
values( 1,'+100500','707 Inc.' ,' Развлечения', CONVERT(date,'2019-09-10'), 4),
(2 ,'Versus','Valve Inc.' ,'Развлечения ',  CONVERT(date,'2021-03-03'),5 ),
( 3,'Хлебоутки','Appricot Gaming' ,' Развлечения', CONVERT(date,'2021-09-17'), 3),
( 4,'Что? Где? Когда?','The Boring Company' ,'Трудоустройство ', CONVERT(datetime,'2022-01-01') , 2);

select * from dbo.Заказчики;
select Рейтинг, Название_передачи from dbo.Передачи;
select Номер_заказа, Передача, Длительность_в_минутах from dbo.Заказы
where Длительность_в_минутах > 3;

select distinct Вид_рекламы from dbo.Заказы;
Select COUNT(*) as Количество_передач from dbo.Передачи;

update dbo.Заказы set Длительность_в_минутах = 7 where Передача = '+100500';
select * from dbo.Заказы;

select * from dbo.Заказы
where Заказчик like '707 Inc.';


select * from dbo.Заказы              
where (Дата_заказа between '2019-01-01' and '2022-01-01') and Длительность_в_минутах in (2,3,4) ;

CREATE DATABASE [Лешук_Mybase]
 ON  PRIMARY 
( NAME = N'Лешук_Mybase', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Лешук_Mybase.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ), 
 FILEGROUP [FG_1]  DEFAULT
( NAME = N'FG_1', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FG_1.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB ),
( NAME = N'FG_1_2', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\FG_1_2.ndf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'Лешук_Mybase_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA\Лешук_Mybase_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT;


create table Передачи (
Название_передачи nvarchar(30) not null primary key,
Рейтинг nvarchar(10) ,
Стоимость_минуты smallmoney not null
) on FG_1;

create table Заказчики(
Название_фирмы_заказчика nvarchar(20) not null primary key,
Банковские_реквизиты int not null,
Телефон int not null,
Контактное_лицо nvarchar(50)
) on FG_1;

create table Заказы(
Номер_заказа int not null primary key,
Передача nvarchar(30) not null foreign key references Передачи(Название_передачи),
Заказчик nvarchar(20) not null foreign key references Заказчики(Название_фирмы_заказчика),
Вид_рекламы nvarchar(20) not null,
Дата_заказа date not null,
Длительность_в_минутах int not null
) on FG_1;



sp_helpindex N'dbo.Передачи';  
--PK__Заказы__8D170B9B989A7EC8, Номер_заказа            - заказы
--PK__Заказчик__AD1B98A1B2104CE3, Название_фирмы_заказчика           -заказчики
--PK__Передачи__67283AA4EC4484F2, Название_передачи        -передачи

CREATE UNIQUE CLUSTERED INDEX [PK__Передачи__67283AA4EC4484F2] ON [dbo].[Передачи]
(
    [Название_передачи  ]
)WITH (DROP_EXISTING = ON, ONLINE = ON) ON [FG_1]
GO