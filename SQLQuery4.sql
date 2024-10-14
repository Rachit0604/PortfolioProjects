
-- looking at Tatal Cases vs Total Death
-- Showing liklyhood of dying if you contract covid in your country
SELECT location,date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercantage
FROM PortfolioProject. .CovidDeaths
where continent is not null
ORDER BY 1,2


-- looking at Total Cases Vs Population
-- Shows what Percantage of Population got covid

SELECT location,date, total_cases,population, (total_cases/population)*100 AS CovidPercantage
FROM PortfolioProject. .CovidDeaths
where continent is not null
--where location like '%states%'
ORDER BY 1,2

-- Looking at the Country with HighestInfectionCount compare to Country
SELECT location,MAX(total_cases) as HighestPopulationInfected,population,MAX((total_cases/population))*100 AS PercantagePopulationInfected
FROM PortfolioProject. .CovidDeaths
where continent is not null
GROUP BY location, Population
--where location like '%states%' 
ORDER BY HighestPopulationInfected desc

-- Showing Country with Highest Death Count Per Population


SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
where continent is not null
GROUP BY location, Population
--where location like '%states%' 
ORDER BY TotalDeathCount desc

-- Let's Break thing Down by Continent

SELECT location,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
where continent is null
GROUP BY location
--where location like '%states%' 
ORDER BY TotalDeathCount desc

-- Showing Continent with Highest Death Count Per Population

SELECT continent,MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject. .CovidDeaths
where continent is not null
GROUP BY continent
--where location like '%states%' 
ORDER BY TotalDeathCount desc

-- Global Numbers
SELECT SUM(new_cases) AS TOTALCASES, SUM(CAST(new_deaths AS INT)) AS TOTALDEATH,SUM(CAST(new_deaths AS INT))/SUM(new_cases) as DeathPercantage
FROM PortfolioProject. .CovidDeaths
where continent is not null
--GROUP BY date
--where location like '%states%' 
ORDER BY 1,2

-- LOOKING AT TOTAL POPULATION VS VACCINATION

select Dea.continent,Dea.location,dea.date,Dea.population,Vac.new_vaccinations,
sum(convert(int,Vac.new_vaccinations)) OVER(PARTITION BY Dea.location order by Dea.location,Dea.date) as RollingPeopleVaccinated
from PortfolioProject. .CovidDeaths as Dea
join PortfolioProject. .CovidVaccination as Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
order by 2,3


-- USING CTE

WITH PopvsVac (continent, location, date, population, new_vaccinations,RollingPeopleVaccinated)
AS
(
select Dea.continent,Dea.location,dea.date,Dea.population,Vac.new_vaccinations,
sum(convert(int,Vac.new_vaccinations)) OVER(PARTITION BY Dea.location order by Dea.location,Dea.date) as RollingPeopleVaccinated
from PortfolioProject. .CovidDeaths as Dea
join PortfolioProject. .CovidVaccination as Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
--order by 2,3
)
SELECT *, (RollingPeopleVaccinated/population)*100 
FROM PopvsVac

--USING TEMP TABLE 
CREATE TABLE #PercentagePopulationVaccinated
(continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #PercentagePopulationVaccinated
select Dea.continent,Dea.location,dea.date,Dea.population,Vac.new_vaccinations,
sum(convert(int,Vac.new_vaccinations)) OVER(PARTITION BY Dea.location order by Dea.location,Dea.date) as RollingPeopleVaccinated
from PortfolioProject. .CovidDeaths as Dea
join PortfolioProject. .CovidVaccination as Vac
on Dea.lotion = Vac.location
and Dea.datcae = Vac.date
where Dea.continent is not null
--order by 2,3

SELECT *, (RollingPeopleVaccinated/population)*100 
FROM #PercentagePopulationVaccinated

-- Creating view to store data for later visualization 

CREATE VIEW PercentagePopulationVaccinated AS
select Dea.continent,Dea.location,dea.date,Dea.population,Vac.new_vaccinations,
sum(convert(int,Vac.new_vaccinations)) OVER(PARTITION BY Dea.location order by Dea.location,Dea.date) as RollingPeopleVaccinated
from PortfolioProject. .CovidDeaths as Dea
join PortfolioProject. .CovidVaccination as Vac
on Dea.location = Vac.location
and Dea.date = Vac.date
where Dea.continent is not null
--order by 2,3


SELECT *
 FROM PercentagePopulationVaccinated