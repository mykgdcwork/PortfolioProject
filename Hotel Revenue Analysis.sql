use [ProjectPortfolio 3]

Select * from dbo.[2018];
Select * from dbo.[2019];
Select * from dbo.[2020];
Select * from dbo.market_segment;
Select * from dbo.meal_cost;

---Accessing all three tables together using CTE

with Hotels as
(
select * from dbo.[2018]
union
select * from dbo.[2019]
union
select * from dbo.[2020]
)
Select * from Hotels

---- Joining tables----

left join market_segment 
on Hotels.market_segment = market_segment.market_segment
left join meal_cost 
on meal_cost.meal = Hotels.meal

---- Revenue by Year----
with Hotels as
(
select * from dbo.[2018]
union
select * from dbo.[2019]
union
select * from dbo.[2020]
)

Select 
	arrival_date_year as "Year", 
	round(Sum((stays_in_week_nights+stays_in_weekend_nights)*adr),2) as Revenue 
from Hotels
group by arrival_date_year


---- Total Night stays AND PERCENT by weekday vs weekend ----

with Hotels as
(
select * from dbo.[2018]
union 
select * from dbo.[2019]
union 
select * from dbo.[2020]
)
Select 

	SUM(stays_in_week_nights) as Week_Nights 
	,SUM(stays_in_weekend_nights) as Weekend_Nights
	,SUM(stays_in_week_nights) + SUM(stays_in_weekend_nights) as Total_Nights 
	,SUM(STAYS_IN_WEEK_NIGHTS)/(SUM(STAYS_IN_WEEK_NIGHTS)+SUM(stays_in_weekend_nights))*100 AS 'WEEK NIGHT PERCENT'
	,SUM(STAYS_IN_WEEKEND_NIGHTS)/(SUM(STAYS_IN_WEEK_NIGHTS)+SUM(stays_in_weekend_nights))*100 AS 'WEEKEND NIGHT PERCENT'
from Hotels

