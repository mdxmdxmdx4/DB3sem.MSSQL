--       LEVEL 1

-- TASK1 
select COMPANY, count(*) [Кол-во заказов], AVG(AMOUNT) [Средняя_стоимость]
from ORDERS
inner join CUSTOMERS on CUST = CUSTOMERS.CUST_NUM
group by COMPANY
order by  [Средняя_стоимость];

-- TASK2
select NAME, AMOUNT
from ORDERS inner join SALESREPS on ORDERS.REP = SALESREPS.EMPL_NUM
where ORDERS.AMOUNT > 15000
order by AMOUNT

--TASK3
select MFR_ID [ID_производителя], count(*) [Количество_товаров], AVG(PRICE) [Средняя_стоимость]
from PRODUCTS
group by MFR_ID

--TASK4	
select company
from customers
where not exists (select * from ORDERS
where orders.CUST = CUSTOMERS.CUST_NUM
);

--TASK5
select distinct ORDERS.ORDER_NUM, ORDERS.ORDER_DATE, ORDERS.CUST, ORDERS.REP, ORDERS.MFR, ORDERS.PRODUCT, ORDERS.QTY
from ORDERS inner join SALESREPS on ORDERS.REP = SALESREPS.EMPL_NUM
inner join OFFICES on OFFICES.OFFICE = SALESREPS.REP_OFFICE
where OFFICES.REGION = N'Eastern'



--           LEVEL 2

--TASK1
create procedure dbo.TASK1 
				@off int, @city varchar(15), @region varchar(10), @mgr int, @targ decimal(9, 2), @sales decimal(9, 2)
as
begin try
insert OFFICES values(@off, @city, @region, @mgr, @targ, @sales)
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
end catch;

exec dbo.TASK1 @off = 777, @city ='Panama', @region = 'CA', @mgr =  108, @targ = 444444, @sales = 435412

exec dbo.TASK1 @off = 777, @city ='Belarus', @region = 'WEU', @mgr =  101, @targ = 242974, @sales = 135412

--TASK4
create procedure dbo.TASK2 @mfr varchar(20)
as
declare @rc int = 0
begin
IF not exists (select MFR_ID from PRODUCTS where MFR_ID = @MFR)
return -1
else
begin
set @rc = (select count(*) from PRODUCTS where MFR_ID = @mfr) 
print N'Кол-во продуктов у производителя с кодом ' + @mfr + ': ' + cast(@rc as varchar(3))
return @rc
end
end;

declare @dd int = 0
exec @dd = dbo.TASK2 @mfr = 'ACI'
print N'Результат процедуры: ' + cast(@dd as varchar(3))

declare @ddd int = 0
exec @ddd = dbo.TASK2 @mfr = 'asd'
print N'Результат процедуры: ' + cast(@ddd as varchar(3))


--TASK5
create procedure dbo.TASK5 @cust varchar(20), @dstart date, @dend date
as
declare @rc int = 0
begin
IF not exists (select COMPANY from CUSTOMERS where COMPANY = @cust)
return -1
else
begin
set @rc = (select count(*) from ORDERS inner join CUSTOMERS on ORDERS.CUST = CUSTOMERS.CUST_NUM where COMPANY = @cust
AND ORDER_DATE between @dstart AND @dend) 
print N'Кол-во заказов: ' + cast(@rc as varchar(3))
return @rc
end
end;


declare @dd int = 0
exec @dd = dbo.TASK5 @cust = 'Zetacorp', @dstart = '01-01-2007', @dend = '02-02-2008'
print N'Результат процедуры: ' + cast(@dd as varchar(3))

declare @dv int = 0
exec @dv = dbo.TASK5 @cust = '707 Inc.', @dstart = '01-01-2007', @dend = '02-02-2008'
print N'Результат процедуры: ' + cast(@dv as varchar(3))



--TASK2
CREATE function TASK2TRUE(@company nvarchar(20)) returns int
as
begin
declare @rc int = 0;
IF not exists (select COMPANY from CUSTOMERS where COMPANY = @company)
set @rc = -1
else
set @rc = (select count(*) from ORDERS inner join CUSTOMERS on ORDERS.CUST = CUSTOMERS.CUST_NUM where COMPANY = @company)
return @rc
end;

select Company, dbo.TASK2TRUE(COMPANY)
from CUSTOMERS

declare @i int = 0;
set @i = dbo.TASK2TRUE('707');
print N'Результат функции: ' + cast(@i as varchar(3))


--TASK3

alter function dbo.TASK3(@price decimal(9, 2)) returns int
as
begin
declare @rc int = 0
set @rc = 
(select COUNT(employees) from  (
select distinct  EMPL_NUM as [employees]
from SALESREPS inner join ORDERS
on orders.REP = SALESREPS.EMPL_NUM
WHERE ORDERS.AMOUNT > @price
) as subquery)
return @rc
end;

declare @ii int = 0;
set @ii = dbo.TASK3(35000);
print N'Кол-во работников с ценой заказа > заданной: ' + cast(@ii as varchar(3))

declare @iii int = 0;
set @iii = dbo.TASK3(1);
print N'Кол-во работников с ценой заказа > заданной: ' + cast(@iii as varchar(3))

