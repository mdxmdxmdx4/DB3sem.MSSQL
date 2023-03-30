
-- #1
create procedure dbo.OrderChange
@orderchange int, @date date, @cust int, @rep int, @qty int
as
begin try
update ORDERS set ORDER_DATE =@date, CUST = @cust, REP = @rep, QTY = @qty where ORDER_NUM = @orderchange
end try 
begin catch 
print N'Номер ошибки: ' + cast(error_number() as varchar(6));
		print N'Сообщение: ' + error_message()
		print N'Уровень: ' + cast(error_severity() as varchar(6));
		print N'Метка: ' + cast(error_state() as varchar(8));
		print N'Номер строки: ' + cast(error_line() as varchar(8));
		if ERROR_PROCEDURE() is not null
		print N'Имя процедуры:' + error_procedure();
		return -1;
end catch

exec dbo.OrderChange @orderchange = 112961, @date = '2022-01-01', @cust = 2103, @rep = 101, @qty = 31

--#2
alter function  dbo.Employees() returns nvarchar(20)
as begin
declare @rv nvarchar(20);
set @rv = (select NAME
from  SALESREPS
where not exists (select * from ORDERS
where orders.REP = SALESREPS.EMPL_NUM
))
if len(@rv) <= 0
return '-1'
return @rv
end;

declare @i nvarchar(20);
set @i = dbo.Employees();
print N'Работники, не совершивших заказы:' + @i; 

--#3
alter function dbo.OFFICESSEEK(@off nvarchar(20)) returns nvarchar(50)
as begin
declare @rc nvarchar(20), @tv nvarchar(50) = '';
declare aaa Cursor for
select OFFICES.OFFICE
from OFFICES
where OFFICES.REGION like @off;
open aaa;
fetch aaa into @rc;
while @@FETCH_STATUS = 0
begin
set @tv = @rc + ', ' + @tv;
fetch aaa into @rc;
end;
if len(@rc) <= 0 
return '-1'
return @tv;
end;
 
declare @r nvarchar(20) = '';
set @r = dbo.OFFICESSEEK(N'Eastern');
print @r;