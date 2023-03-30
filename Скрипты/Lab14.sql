 --        1)
create table TR_AUDIT (
ID int identity,    --номер
STMT nvarchar(20) check(STMT in ('INS','DEL','UPD')),  --DML-оператор
TRNAME nvarchar(50),        --имя триггера
CC nvarchar(300)        -- комментарий
);

create trigger Trig_Teacher_ins
on TEACHER after INSERT
as declare	
@a1 nchar(10), @a2 nvarchar(100), @a3 nchar(10), @a4 nchar(20), @in nvarchar(300);
print N'Операция вставки: ';
set @a1 = (select [TEACHER] from inserted);
set @a2 = (select [TEACHER_NAME] FROM INSERTED);
set @a3 = (select [GENDER] from inserted);
set @a4 = (select [PULPIT] from inserted);
set @in = rtrim(@a1) +', '+ @a2 +', ' + rtrim(@a3)+ ', '+ rtrim(@a4);
insert into TR_AUDIT values('INS', 'Trig_Teacher_ins', @in);
return;

insert TEACHER values
(N'ДВР', N'Дворянинкин Максимильян Геннадьевич', N'м', N'ИСиТ');
select * from TR_AUDIT;

---   2)

create trigger TR_TEACHER_DEL
on TEACHER after delete
as declare	
@a1 nchar(10), @a2 nvarchar(100), @a3 nchar(10), @a4 nchar(20), @in nvarchar(300);
print N'Удаление: ';
set @a1 = (select [TEACHER] from deleted);
set @a2 = (select [TEACHER_NAME] FROM deleted);
set @a3 = (select [GENDER] from deleted);
set @a4 = (select [PULPIT] from deleted);
set @in = rtrim(@a1) +', '+ @a2 +', ' + rtrim(@a3)+ ', '+ rtrim(@a4);
insert into TR_AUDIT values('DEL', 'TR_TEACHER_DEL', @in);
return;

delete TEACHER where TEACHER = N'ГЦ'
select * from TR_AUDIT;



---    3)


alter trigger TR_TEACHER_UPD
on TEACHER after update
as declare	
@a1 nchar(10), @a2 nvarchar(100), @a3 nchar(10), @a4 nchar(20), @in nvarchar(300);
    print N'Событие: UPDATE'; 
set @a1 = (select [TEACHER] from inserted);
set @a2 = (select [TEACHER_NAME] FROM inserted);
set @a3 = (select [GENDER] from inserted);
set @a4 = (select [PULPIT] from inserted);
set @in = rtrim(@a1) +', '+ @a2 +', ' + rtrim(@a3)+ ', '+ rtrim(@a4);
set @a1 = (select [TEACHER] from deleted);
set @a2 = (select [TEACHER_NAME] FROM deleted);
set @a3 = (select [GENDER] from deleted);
set @a4 = (select [PULPIT] from deleted);
set @in = rtrim(@a1) +', '+ @a2 +', ' + rtrim(@a3)+ ', '+ rtrim(@a4) + @in;
    insert into TR_AUDIT values('UPD','TR_TEACHER_UPD', @in); 
return;  

UPdate TEACHER SET PULPIT = N'ХПД' where TEACHER.TEACHER = N'МХВ'
select * from TR_AUDIT;



-- 4)

alter trigger TR_TEACHER   on TEACHER after INSERT, DELETE, UPDATE  
as
declare @a11 nchar(10), @a21 nvarchar(100), @a31 nchar(10), @a41 nchar(20), @in1 nvarchar(300);
declare @ins int = (select count(*) from inserted),
              @del int = (select count(*) from deleted); 
if  @ins > 0 and  @del = 0  
begin 
     print N'Событие: INSERT';
set @a11 = (select [TEACHER] from inserted);
set @a21 = (select [TEACHER_NAME] FROM INSERTED);
set @a31 = (select [GENDER] from inserted);
set @a41 = (select [PULPIT] from inserted);
set @in1 = rtrim(@a11) +', '+ @a21 +', ' + rtrim(@a31)+ ', '+ rtrim(@a41);
     insert into TR_AUDIT values('INS', 'TR_TEACHER', @in1);
end; 
else		  	 
if @ins = 0 and  @del > 0  
begin 
    print N'Событие: DELETE';
set @a11 = (select [TEACHER] from deleted);
set @a21 = (select [TEACHER_NAME] FROM deleted);
set @a31 = (select [GENDER] from deleted);
set @a41 = (select [PULPIT] from deleted);
set @in1= rtrim(@a11) +', '+ @a21 +', ' + rtrim(@a31)+ ', '+ rtrim(@a41);
insert into TR_AUDIT values('DEL', 'TR_TEACHER', @in1);
end; 
else	  
if @ins > 0 and  @del > 0  
begin 
print N'Событие: UPDATE'; 
set @a11 = (select [TEACHER] from inserted);
set @a21 = (select [TEACHER_NAME] FROM inserted);
set @a31 = (select [GENDER] from inserted);
set @a41 = (select [PULPIT] from inserted);
set @in1 = rtrim(@a11) +', '+ @a21 +', ' + rtrim(@a31)+ ', '+ rtrim(@a41);
set @a11 = (select [TEACHER] from deleted);
set @a21 = (select [TEACHER_NAME] FROM deleted);
set @a31 = (select [GENDER] from deleted);
set @a41 = (select [PULPIT] from deleted);
set @in1 = rtrim(@a11) +', '+ @a21 +', ' + rtrim(@a31)+ ', '+ rtrim(@a41) + @in1;
    insert into TR_AUDIT values('UPD','TR_TEACHER', @in1); 
end;  
return;  


insert TEACHER values  (N'ДМДК', N'Демидко Марина Николаевна',  N'ж',  N'ИСит');
delete TEACHER where TEACHER.TEACHER = N'РВКС';
update TEACHER set PULPIT = N'ТДП' where TEACHER.TEACHER = N'ДМДК';

select * from TR_AUDIT;


-- 5)
alter table TEACHER  add constraint PULPIT_NN CHECK(PULPIT IS NOT NULL);		
	update TEACHER set PULPIT = NULL where TEACHER.TEACHER = N'ДМДК';
	select * from TR_AUDIT;


-- 6)
create trigger TR_TEACHER_DEL1 on TEACHER after delete  
as print 'TR_TEACHER_ DEL1';
insert TR_AUDIT values('DEL', 'TR_TEACHER_DEL1', 'TR_TEACHER_DEL1')
return;  

create trigger TR_TEACHER_DEL2 on TEACHER after delete  
as print 'TR_TEACHER_ DEL2';
insert TR_AUDIT values('DEL', 'TR_TEACHER_DEL2', 'TR_TEACHER_DEL2')
return; 

create trigger TR_TEACHER_DEL3 on TEACHER after delete  
as print 'TR_TEACHER_ DEL3';
insert TR_AUDIT values('DEL', 'TR_TEACHER_DEL3', 'TR_TEACHER_DEL3')
return;  


delete TEACHER where TEACHER.TEACHER = N'ДМДК'
select * from TR_AUDIT;



select t.name, e.type_desc 
from sys.triggers  t join  sys.trigger_events e  
on t.object_id = e.object_id  
where OBJECT_NAME(t.parent_id) = 'UNIVER' and 
e.type_desc = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL3', 
	                        @order = 'First', @stmttype = 'DELETE';

exec  SP_SETTRIGGERORDER @triggername = 'TR_TEACHER_DEL2', 
	                        @order = 'Last', @stmttype = 'DELETE';

delete TEACHER where TEACHER.TEACHER = N'ПРКП'
select * from TR_AUDIT;

 ----          7)
 create trigger TEACHER_TRAN
 on TEACHER after insert, update, delete
 as declare @c int = (select count(*) from TEACHER)
 if(@c > 2)
 begin
 raiserror('Кол-во учителей больше установленного!', 10, 1);
 rollback;
 end;
 return;

 update TEACHER Set TEACHER.TEACHER = N'НСК' where TEACHER.TEACHER = N'НСКВ';
 select * from TR_AUDIT;

 -----    8)

create trigger FAC_INSTEAD_OF
on FACULTY instead of DELETE
as raiserror(N'Удаление запрещено!', 10, 1);
return;

delete from FACULTY where FACULTY.FACULTY = N'ИТ';
							
drop trigger dbo.Trig_Teacher_ins
drop trigger dbo.TR_TEACHER_DEL  
drop trigger dbo.TR_TEACHER_UPD
drop trigger dbo.TR_TEACHER
drop trigger dbo.TR_TEACHER_DEL1
drop trigger dbo.TR_TEACHER_DEL2
drop trigger dbo.TR_TEACHER_DEL3
drop trigger dbo.TEACHER_TRAN
drop trigger dbo.FAC_INSTEAD_OF


---- 9)

alter trigger DDL_UNIVER on database for DDL_DATABASE_LEVEL_EVENTS
as
--declare @i int = 12;
--print cast(@i as varchar(3))
declare @t varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/EventType)[1]', 'varchar(50)');
declare @t1 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectName)[1]', 'varchar(50)');
declare @t2 varchar(50) = EVENTDATA().value('(/EVENT_INSTANCE/ObjectType)[1]', 'varchar(50)');
if @t1 in (select name from sys.objects WHERE type='U')
begin
print N'Тип события: ' + @t;
print N'Имя объекта: ' + @t1;
print N'Тип объекта: ' + @t2;
raiserror ('Операции с таблицей запрещены',16,1);
rollback;
end;

--alter table GROUPP drop column COURSE;
--ALTER TABLE STUDENT Drop COLUMN stamp;
alter table TEACHER drop column gender;
create table asd(
K int not null
);

--drop TRIGGER dbo.DDL_UNIVER;
DROP TRIGGER [DDL_UNIVER] ON DATABASE