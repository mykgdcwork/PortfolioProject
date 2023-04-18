Select * from CovidDeaths

Select * from CovidDeaths
where continent is not Null
order by 3,4

--select data that we are going to be using
Select Location, date, total_cases, new_cases, total_deaths, population
from CovidDeaths
order by 1,2


--Total cases vs Total deaths

Select Location, date, total_cases, total_deaths,
(cast(total_deaths as bigint)/Cast(total_cases as bigint)) as 'DeathPercantage'
from dbo.CovidDeaths
order by 1,2

--Average Death Percentage by Location

Select location, AVG(CONVERT(decimal(15,3), total_deaths/CONVERT(decimal(15,3), total_cases))*100) from CovidDeaths
group by location
order by 2 desc

---Total cases vs Populcation

Select Location, date, Population, total_cases,
CONVERT(decimal(15,3), total_cases/CONVERT(decimal(15,3), population))*100 as 'Percentage Population Infected'
from dbo.CovidDeaths
where continent is not Null
--where location='India'
order by 1,2

---Countries with Highest Infection Rate to Population
Select Location, Population, Max(total_cases) as HighestInfectionCount,
Max(CONVERT(decimal(15,3), total_cases/CONVERT(decimal(15,3), population)))*100 as PercentagePopulationInfected
from dbo.CovidDeaths
where continent is not Null
Group by Location, Population
order by 4 desc

---Countries with Highest Death Rate to Population
Select Location, Max(total_deaths) as HighestDeathCount,
Max(cast(total_deaths as bigint)/Cast(population as bigint))*100 as PercentagePopulationDeath
from dbo.CovidDeaths
where continent is not Null
Group by Location, Population
order by 2 desc


---continent with Highest Death Rate to Population
Select 
	continent, 
	Max(cast(population as bigint)) as TotalPopulation, 
	Max(cast(total_deaths as bigint)) as TotalDeaths,
	Max(cast(total_deaths as bigint))/Max(cast(population as bigint)) as DeathPercentage
from dbo.CovidDeaths
where continent is not Null
Group by continent
order by 3 desc



--Vaccination

Select * from CovidVaccination
order by 3,4

---Joining two tables - CovidDeath and CovidVaccination

Select * from 
CovidDeaths join CovidVaccination on 
CovidDeaths.location = CovidVaccination.location 
and
CovidDeaths.date = CovidVaccination.date


---total population vs vaccinated 

Select 
	dbo.CovidDeaths.continent,
	dbo.CovidDeaths.location, 
	Max(cast(dbo.CovidDeaths.population as bigint)) as TotalPopulation, 
	Max(cast(dbo.CovidVaccination.total_tests as bigint))as TotalTest, 
	Max(cast(dbo.CovidDeaths.total_cases as bigint)) as HighestInfectionCount,
	Max(cast(dbo.CovidDeaths.total_deaths as bigint))as TotalDeaths, 
	Max(cast(dbo.CovidVaccination.people_vaccinated as bigint)) as Totalvaccinated
from 
CovidDeaths join CovidVaccination on 
CovidDeaths.location = CovidVaccination.location 
and
CovidDeaths.date = CovidVaccination.date
where dbo.CovidDeaths.continent is not null
group by dbo.CovidDeaths.continent, dbo.CovidDeaths.location
order by 1,2

---Each day / rolling vaccincation count by location
Select 
	CovidDeaths.location, 
	CovidDeaths.date, 
	CovidDeaths.population, 
	CovidVaccination.new_vaccinations,
	Sum(convert(bigint, new_vaccinations)) 
	over (partition by CovidDeaths.location 
	order by CovidDeaths.location, CovidDeaths.date)
from CovidDeaths join CovidVaccination
on CovidDeaths.location = CovidVaccination.location 
and CovidDeaths.date = CovidVaccination.date
where CovidDeaths.continent is not null and new_vaccinations is not null
order by 2

---Vaccination % using CTE

with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select 
	dbo.CovidDeaths.continent,
	dbo.CovidDeaths.location, 
	dbo.CovidDeaths.date,
	dbo.CovidDeaths.population, 
	dbo.CovidVaccination.new_vaccinations,
	SUM(convert(bigint, new_vaccinations)) 
	over (partition by dbo.CovidDeaths.location 
	order by dbo.CovidDeaths.location, dbo.CovidDeaths.date)
	as RollingPeopleVaccinated 
from 
CovidDeaths join CovidVaccination on 
CovidDeaths.location = CovidVaccination.location 
and
CovidDeaths.date = CovidVaccination.date
where dbo.CovidDeaths.continent is not null and new_vaccinations is not null
--order by 2
)
Select *, (RollingPeopleVaccinated/Population)*100
from PopvsVac


---Temp Table

DROP TABLE IF EXISTS #PERCENTAGEPOPULATIONVACCINCATED
CREATE TABLE #PERCENTAGEPOPULATIONVACCINCATED
(
CONTINENT NVARCHAR(255),
LOCATION NVARCHAR(255),
DATE DATETIME,
POPULATION NUMERIC,
NEW_VACCINCATION NUMERIC,
ROLLINGPEOPLEVACCINATED NUMERIC
)

INSERT INTO #PERCENTAGEPOPULATIONVACCINCATED

Select 
	dbo.CovidDeaths.continent,
	dbo.CovidDeaths.location, 
	dbo.CovidDeaths.date,
	dbo.CovidDeaths.population, 
	dbo.CovidVaccination.new_vaccinations,
	SUM(convert(bigint, new_vaccinations)) 
	over (partition by dbo.CovidDeaths.location 
	order by dbo.CovidDeaths.location, dbo.CovidDeaths.date)
	as RollingPeopleVaccinated 
from 
CovidDeaths join CovidVaccination on 
CovidDeaths.location = CovidVaccination.location 
and
CovidDeaths.date = CovidVaccination.date
where dbo.CovidDeaths.continent is not null 

SELECT *, (ROLLINGPEOPLEVACCINATED/POPULATION)*100
FROM #PERCENTAGEPOPULATIONVACCINCATED


--CREATING VIEW TO STORE DATA FOR LATER VISULIZATIONS

CREATE VIEW PERCENTPOPULATIONVACCINATED AS
Select 
	dbo.CovidDeaths.continent,
	dbo.CovidDeaths.location, 
	dbo.CovidDeaths.date,
	dbo.CovidDeaths.population, 
	dbo.CovidVaccination.new_vaccinations,
	SUM(convert(bigint, new_vaccinations)) 
	over (partition by dbo.CovidDeaths.location 
	order by dbo.CovidDeaths.location, dbo.CovidDeaths.date)
	as RollingPeopleVaccinated 
from 
CovidDeaths join CovidVaccination on 
CovidDeaths.location = CovidVaccination.location 
and
CovidDeaths.date = CovidVaccination.date
where dbo.CovidDeaths.continent is not null 

SELECT * FROM PERCENTPOPULATIONVACCINATED