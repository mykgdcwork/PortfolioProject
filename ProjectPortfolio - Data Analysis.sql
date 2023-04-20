---Project 1 - Data Analysis
use [ProjectPortfolio 1]
Select * from customers;
Select * from date;
Select * from markets;
Select * from products;
Select * from transactions;


---Create Currency Table to convert other currancies into INR

drop table if exists AnnualCurrencyTable
Create table AnnualCurrencyTable 
(
Year date,
Currency varchar (15),
INR_Rate int
)

--Insert data into currency table

insert into AnnualCurrencyTable(Year, Currency, INR_Rate)
values('2017', 'USD', 65.0966),
	  ('2018', 'USD', 68.4113),
	  ('2019', 'USD', 70.4059),
	  ('2020', 'USD', 74.1322),
	  ('2017', 'INR', 1),
	  ('2018', 'INR', 1),
	  ('2019', 'INR', 1),
	  ('2020', 'INR', 1)
	  ;

Select * from AnnualCurrencyTable

---Delete INR rows from table as INR rate will always be 1 

Delete AnnualCurrencyTable where Currency='INR'

--Total Revenue (SalesAmount*CurrencyRate)

Select 
	--Year(transactions.order_date) as 'Order_Year',
	--transactions.sales_amount, 
	--transactions.currency,
	'Total Revenue' = SUM(case 
	when Year(transactions.order_date) = 2017 and transactions.currency = 'USD' then (transactions.sales_amount)*65.0966
	when Year(transactions.order_date) = 2018 and transactions.currency = 'USD' then (transactions.sales_amount)*68.4113
	when Year(transactions.order_date) = 2019 and transactions.currency = 'USD' then (transactions.sales_amount)*70.4059
	when Year(transactions.order_date) = 2020 and transactions.currency = 'USD' then (transactions.sales_amount)*74.1322
	else (transactions.sales_amount)*1
	end)
from transactions

--Total Sales
Select SUM(transactions.sales_qty) as TotalSales from transactions

--Total Profit Margin
Select SUM(transactions.profit_margin) as ProfitMargin from transactions

--Top 10 customers by Revenue
Select 
	top(10) customers.custmer_name, 
	'Total Revenue' = SUM(case 
	when Year(transactions.order_date) = 2017 and transactions.currency = 'USD' then (transactions.sales_amount)*65.0966
	when Year(transactions.order_date) = 2018 and transactions.currency = 'USD' then (transactions.sales_amount)*68.4113
	when Year(transactions.order_date) = 2019 and transactions.currency = 'USD' then (transactions.sales_amount)*70.4059
	when Year(transactions.order_date) = 2020 and transactions.currency = 'USD' then (transactions.sales_amount)*74.1322
	else (transactions.sales_amount)*1
	end) 
	from customers join transactions 
	on customers.customer_code=transactions.customer_code 
	group by custmer_name
	order by 2 desc  

--Top 5 Markets by Revenue
Select 
	top(5) markets.markets_name, 
	'Total Revenue' = SUM(case 
	when Year(transactions.order_date) = 2017 and transactions.currency = 'USD' then (transactions.sales_amount)*65.0966
	when Year(transactions.order_date) = 2018 and transactions.currency = 'USD' then (transactions.sales_amount)*68.4113
	when Year(transactions.order_date) = 2019 and transactions.currency = 'USD' then (transactions.sales_amount)*70.4059
	when Year(transactions.order_date) = 2020 and transactions.currency = 'USD' then (transactions.sales_amount)*74.1322
	else (transactions.sales_amount)*1
	end) 
	from markets join transactions 
	on markets.markets_code=transactions.market_code 
	group by markets_name
	order by 2 desc


---Top 5 sales qty by Market

Select 
	Top(5) markets.markets_name as MarkerName,
	SUM(transactions.sales_qty) as TotalSales
from transactions join markets
on transactions.market_code=markets.markets_code
group by markets_name
order by 2 desc

---Top 5 Products by Revenue

Select 
	Top(5) products.product_code as Products,
	'Total Revenue' = SUM(Case
	when Year(transactions.order_date) = 2017 and transactions.currency = 'USD' then (transactions.sales_amount)*65.0966
	when Year(transactions.order_date) = 2018 and transactions.currency = 'USD' then (transactions.sales_amount)*68.4113
	when Year(transactions.order_date) = 2019 and transactions.currency = 'USD' then (transactions.sales_amount)*70.4059
	when Year(transactions.order_date) = 2020 and transactions.currency = 'USD' then (transactions.sales_amount)*74.1322
	else (transactions.sales_amount)*1
	end)  
from transactions join products
on transactions.product_code=products.product_code
group by products.product_code
order by 2 desc


---Revenue trend by year
Select Distinct(year(date.date)) from date

Select 
	date.year as 'DateYear',
	'Total Revenue' = SUM(Case
	when Year(transactions.order_date) = 2017 and transactions.currency = 'USD' then (transactions.sales_amount)*65.0966
	when Year(transactions.order_date) = 2018 and transactions.currency = 'USD' then (transactions.sales_amount)*68.4113
	when Year(transactions.order_date) = 2019 and transactions.currency = 'USD' then (transactions.sales_amount)*70.4059
	when Year(transactions.order_date) = 2020 and transactions.currency = 'USD' then (transactions.sales_amount)*74.1322
	else (transactions.sales_amount)*1
	end)  
from transactions join date
on transactions.order_date=date.cy_date
group by date.year
order by 1 