--Leshuk D. group 7
--1)
select COMPANY, CUST_NUM, avg(AMOUNT) [Средняя_цена заказа]
from dbo.CUSTOMERS inner join dbo.ORDERS on orders.CUST = CUST_NUM
group by CUST_NUM, COMPANY;

--2)
select company
from customers
where not exists (select * from ORDERS
where orders.CUST = CUSTOMERS.CUST_NUM
);

select company
from customers
where not exists (select * from ORDERS
where orders.CUST = CUSTOMERS.CUST_NUM
and (ORDER_DATE not between cast('2007-01-01' as date) and  cast('2008-01-01' as date))
);

	select NAME,  amount [Цена товара]
	from ORDERS o
	inner join SALESREPS on MANAGER = REP
	where AMOUNT = (select top(1) AMOUNT from ORDERS aa
	where o.CUST = aa.CUST
	order by AMOUNT desc)

--MAKSIM DVORYANINKEEN
use kr
select top 3 PRODUCT, DESCRIPTION,  count(*) [Количество]
FROM ORDERS inner join PRODUCTS on ORDERS.PRODUCT = PRODUCTS.PRODUCT_ID
group by product, DESCRIPTION
order by Количество desc


select count(ORDER_NUM) [Num_of_orders], OFFICE, CITY
from OFFICES inner join ORDERS on orders.REP = OFFICES.MGR
group by OFFICE, CITY
order by CITY asc


select distinct NAME
from SALESREPS
where not exists (select * from ORDERS
WHERE ORDERS.REP = SALESREPS.EMPL_NUM) ;

