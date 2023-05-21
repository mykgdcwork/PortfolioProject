Use [ProjectPortfolio 3]

Select * from [DataProfessionalSurvey]

---Total Survey Participents

Select count([Unique ID]) as TotalSurveyParticipents
from dbo.DataProfessionalSurvey

------------------------------------------------------------------------------


---Average Age of Survey Participents

Select 
	Round(Avg([Q10 - Current Age]),0) as AverageAgeofParticipents 
from dbo.DataProfessionalSurvey;

------------------------------------------------------------------------------

---Patricipants COUNTRIERS of Survey

Select
[Q11 - Which Country do you live in?],
COUNT([Q11 - Which Country do you live in?]) as TOTALPatricipants
from dbo.DataProfessionalSurvey
group by [Q11 - Which country do you live in?]
ORDER BY 2 DESC

---CLEANED UP OTHER COUNTRIES INTO JUST OTHER AS THERE WERE LOST OF OTHER LISTED INTO OTHER CATEGERY

---USING SELF JOIN AND REPLACE FUNCTION, REPLACED ALL OTHER COUNTRIES INTO OTHER

SELECT 
	A.[Q11 - Which Country do you live in?], 
	B.[Q11 - Which Country do you live in?], 
	REPLACE(A.[Q11 - Which Country do you live in?], A.[Q11 - Which Country do you live in?], 'OTHER')
FROM dbo.DataProfessionalSurvey A JOIN dbo.DataProfessionalSurvey B
ON A.[Unique ID]=B.[Unique ID]
where A.[Q11 - Which Country do you live in?] like 'Other%'

UPDATE A
SET [Q11 - Which Country do you live in?] = 
REPLACE(A.[Q11 - Which Country do you live in?], A.[Q11 - Which Country do you live in?], 'OTHER')
FROM dbo.DataProfessionalSurvey A JOIN dbo.DataProfessionalSurvey B
ON A.[Unique ID]=B.[Unique ID]
where A.[Q11 - Which Country do you live in?] like 'Other%'

------------------------------------------------------------------------------

---How difficult was it for you to break into Data

WITH CategoryRating (DifficultytoBreak, Rating) AS
(
SELECT 
	[Q7 - How difficult was it for you to break into Data?] as DifficultytoBreak,
	Count([Q7 - How difficult was it for you to break into Data?]) as RATING
	FROM dbo .DataProfessionalSurvey
	GROUP BY [Q7 - How difficult was it for you to break into Data?]
),

Total as( 
	SELECT 
	Count([Q7 - How difficult was it for you to break into Data?]) as TOTALRATING
	FROM dbo .DataProfessionalSurvey
)

Select 
		DifficultytoBreak, 
		Rating,
		CONVERT(decimal(15,2),RATING /CONVERT(decimal(15,2), TOTALRATING))*100 as RatingPercent
		from CategoryRating, Total

------------------------------------------------------------------------------
--Happiness with work life balance

Use [ProjectPortfolio 3]
Select 
round(Avg([Q6 - How Happy are you in your Current Position with the follow1]),2) 
from [DataProfessionalSurvey]

--Happiness with Salary

Select 
round(Avg([Q6 - How Happy are you in your Current Position with the followi]),2) 
from [DataProfessionalSurvey]

------------------------------------------------------------------------------
----Favorite Programming Language

--1. Clean up the Current roles, merge all other roles into Other
Select 
Distinct([Q1 - Which Title Best Fits your Current Role?])
from [DataProfessionalSurvey]
order by 1

Select 
	A.[Q1 - Which Title Best Fits your Current Role?], 
	B.[Q1 - Which Title Best Fits your Current Role?],
	REPLACE(A.[Q1 - Which Title Best Fits your Current Role?], A.[Q1 - Which Title Best Fits your Current Role?], 'Other')
from [DataProfessionalSurvey] A join [DataProfessionalSurvey] B on
A.[Unique ID]=B.[Unique ID]
where A.[Q1 - Which Title Best Fits your Current Role?] like 'Other%'

Update A
Set [Q1 - Which Title Best Fits your Current Role?]=	REPLACE(A.[Q1 - Which Title Best Fits your Current Role?], A.[Q1 - Which Title Best Fits your Current Role?], 'Other')
from [DataProfessionalSurvey] A join [DataProfessionalSurvey] B on
A.[Unique ID]=B.[Unique ID]
where A.[Q1 - Which Title Best Fits your Current Role?] like 'Other%'

---2. Favorite Programming Language (Replace, Update, CTE and Joins)

Select Distinct([Q5 - Favorite Programming Language])
from [DataProfessionalSurvey]
order by 1

--Cleaned up column to merge all others in signle Other
Select 
A.[Q5 - Favorite Programming Language], 
B.[Q5 - Favorite Programming Language],
REPLACE(A.[Q5 - Favorite Programming Language],A.[Q5 - Favorite Programming Language],'Other')
from [DataProfessionalSurvey] A join [DataProfessionalSurvey] B
on A.[Unique ID]=B.[Unique ID]
where A.[Q5 - Favorite Programming Language] like 'Other%'

--Updated column
Update A
Set [Q5 - Favorite Programming Language] = REPLACE(A.[Q5 - Favorite Programming Language],A.[Q5 - Favorite Programming Language],'Other')
from [DataProfessionalSurvey] A join [DataProfessionalSurvey] B
on A.[Unique ID]=B.[Unique ID]
where A.[Q5 - Favorite Programming Language] like 'Other%'

---

With Python as (
Select 
[Q1 - Which Title Best Fits your Current Role?],
count([Q5 - Favorite Programming Language]) as Python
from [DataProfessionalSurvey]
where ([Q5 - Favorite Programming Language])= 'python' 
group by [Q1 - Which Title Best Fits your Current Role?]
---order by 2 desc
),

R as (
Select 
[Q1 - Which Title Best Fits your Current Role?],
count([Q5 - Favorite Programming Language]) as R
from [DataProfessionalSurvey]
where ([Q5 - Favorite Programming Language])= 'R' 
group by [Q1 - Which Title Best Fits your Current Role?]
--order by 2 desc
),

[C/C++] as (
Select 
[Q1 - Which Title Best Fits your Current Role?],
count([Q5 - Favorite Programming Language]) as 'C/C++'
from [DataProfessionalSurvey]
where ([Q5 - Favorite Programming Language])= 'C/C++' 
group by [Q1 - Which Title Best Fits your Current Role?]
---order by 2 desc
),

JavaScript as (
Select 
[Q1 - Which Title Best Fits your Current Role?],
count([Q5 - Favorite Programming Language]) as 'JavaScript'
from [DataProfessionalSurvey]
where ([Q5 - Favorite Programming Language])= 'JavaScript' 
group by [Q1 - Which Title Best Fits your Current Role?]
--order by 2 desc
),

Java as (
Select 
[Q1 - Which Title Best Fits your Current Role?],
count([Q5 - Favorite Programming Language]) as 'Java'
from [DataProfessionalSurvey]
where ([Q5 - Favorite Programming Language])= 'Java' 
group by [Q1 - Which Title Best Fits your Current Role?]
---order by 2 desc
)

Select 
	Python.[Q1 - Which Title Best Fits your Current Role?],
	Python.Python,
	R.R,
	[C/C++].[C/C++],
	JavaScript.JavaScript,
	Java.Java
from Python left Join R 
on Python.[Q1 - Which Title Best Fits your Current Role?] = R.[Q1 - Which Title Best Fits your Current Role?]
left Join [C/C++] on [C/C++].[Q1 - Which Title Best Fits your Current Role?]=Python.[Q1 - Which Title Best Fits your Current Role?]
left Join JavaScript on JavaScript.[Q1 - Which Title Best Fits your Current Role?] = Python.[Q1 - Which Title Best Fits your Current Role?]
left Join Java on Java.[Q1 - Which Title Best Fits your Current Role?]=Python.[Q1 - Which Title Best Fits your Current Role?]


-----------------------------------------------------------------------------------------------------------------------

--Create new column which will calculate Average Salary from given range
--First we need to remove K then split the current column by - into two columns AverageSalary1 and AverageSalary2
--Then we can calculate Average Salary from above two columns

---
Select [Q3 - Current Yearly Salary (in USD)]
--,AverageSalary1, AverageSalary2
from [DataProfessionalSurvey]

--Clean up Current Salary column to Remove K from the table

Select 
[Q3 - Current Yearly Salary (in USD)],
SUBSTRING([Q3 - Current Yearly Salary (in USD)], 1, CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])-1) as AveSalary1,
SUBSTRING([Q3 - Current Yearly Salary (in USD)], CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])+2, 
CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])-1) AveSalary2
from [DataProfessionalSurvey]
where [Q3 - Current Yearly Salary (in USD)] like '0-%'

---add split colum and update data
Alter table [DataProfessionalSurvey]
Add AverageSalary1 nvarchar(5)

Update [DataProfessionalSurvey]
Set AverageSalary1=SUBSTRING([Q3 - Current Yearly Salary (in USD)], 1, CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])-1)

Alter table [DataProfessionalSurvey]
Add AverageSalary2 nvarchar(5)

Update [DataProfessionalSurvey]
Set AverageSalary2=SUBSTRING([Q3 - Current Yearly Salary (in USD)], CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])+2, 
CHARINDEX('k', [Q3 - Current Yearly Salary (in USD)])-1)

---in first column we have 0-40 range, we need to split the values into same above two columns

Select
[Q3 - Current Yearly Salary (in USD)]
,AverageSalary1
,AverageSalary2
,Parsename(replace(AverageSalary1, '-', '.'), 2) as AverageSalarysplit1
,SUBSTRING([AverageSalary1], CHARINDEX('-', [AverageSalary1])+1, CHARINDEX('-', [AverageSalary1])) as AverageSalarysplit2
from [DataProfessionalSurvey]


---Update first digit in first column

Update [DataProfessionalSurvey]
Set AverageSalary1=Parsename(replace(AverageSalary1, '-', '.'), 2)
where AverageSalary1 like '0-%'

---Update second digit in second column
Update [DataProfessionalSurvey]
Set AverageSalary2=40
where [Q3 - Current Yearly Salary (in USD)] like '0-%'

---Create New column for calculating average scores of column AverageSalary1 and AverageSalary2

Select 
[Q3 - Current Yearly Salary (in USD)]
,AverageSalary1
,AverageSalary2
,(Select avg(AverageSalary) from (Values(cast(AverageSalary1 as int)), (Cast(AverageSalary2 as int))) as tblAverage(AverageSalary)) as AverageSalary
from [DataProfessionalSurvey]

Alter table [DataProfessionalSurvey]
Add AverageSalary nvarchar(10)

Update [DataProfessionalSurvey]
Set AverageSalary = (Select avg(AvSalary) from (Values(cast(AverageSalary1 as int)), (Cast(AverageSalary2 as int))) as tblAverage(AvSalary))

Select 
[Q1 - Which Title Best Fits your Current Role?]
,[Q3 - Current Yearly Salary (in USD)]
--,AverageSalary1
--,AverageSalary2
,AverageSalary
from [DataProfessionalSurvey]


---
Select 
[Q1 - Which Title Best Fits your Current Role?],
Avg(Cast(AverageSalary as int))
from [DataProfessionalSurvey]
Group by [Q1 - Which Title Best Fits your Current Role?]
order by 2 desc


---Finally delete wanted columns from table
Alter table [DataProfessionalSurvey]
Drop column Browser, OS, City. Country, Referrer,AverageSalary1,AverageSalary2