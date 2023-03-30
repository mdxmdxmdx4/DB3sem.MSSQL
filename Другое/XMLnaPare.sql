use kr;

create table Details(
Info xml);

--declare @x xml, @h int = 0;
--set @x = (select  rtrim(ORDER_NUM)  N'Details/Num', rtrim(CUST) N'Details/Customer', 
--rtrim(ORDER_DATE) N'Details/Date', rtrim(AMOUNT) N'Details/Amount'
--from ORDERS
--where ORDERS.ORDER_DATE between cast('2007-01-02' as date) and cast('2008-01-02' as date)
--for xml path,root('Статистика'), elements);
--exec sp_xml_preparedocument @h output, @x;  -- подготовка документа 
--    select * from openxml(@h, 'Cтатистика/Details', 0)
--	with([Num] nvarchar(20), [Customer] nvarchar(20), [Date] nvarchar(20), Amount nvarchar(20))
--	exec sp_xml_removedocument @h


declare @h int = 0,
@x varchar(2000) = N'<?xml version= "1.0" encoding = "windows-1251" ?>
<ROOT>
<Details ORDER_NUM = "1234" ORDER_DATE = "2007-03-04" CUST = "2117" REP =  "106" MFR ="REI" PRODUCT = "2A44L" QTY = "1" AMOUNT ="702,00"/>
<Details ORDER_NUM = "9991" ORDER_DATE = "2008-01-01"  CUST = "2103" REP = "106" MFR = "ACI" PRODUCT = "2A44L" QTY= "2" AMOUNT ="104,00" />
<Details ORDER_NUM = "4313" ORDER_DATE = "2008-07-07" CUST = "2101" REP = "106" MFR = "ACI" PRODUCT = "2A44L" QTY = "3" AMOUNT = "202,00"/>
</ROOT>';
exec sp_xml_preparedocument @h output,@x;
insert ORDERS select [ORDER_NUM], [ORDER_DATE],[CUST], [REP], [MFR], [PRODUCT], [QTY], [AMOUNT]
from openxml(@h,'/ROOT/Details',0)
with([ORDER_NUM] nvarchar(10),[ORDER_DATE] date,[CUST] int, [REP] int, [MFR] Nchar(3), [PRODUCT] Nchar(5), [QTY] int, [AMOUNT] decimal)
exec sp_xml_removedocument @h;
