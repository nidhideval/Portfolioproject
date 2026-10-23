SELECT * 
FROM Portfolioproject..CovidDeaths
order by 3,4

SELECT * 
FROM Portfolioproject..CovidVaccinations
order by 3,4

--Data using

SELECT location, date, total_cases, new_cases, total_deaths,population
FROM Portfolioproject..CovidDeaths
order by 1,2

--Total cases VS Total deaths

SELECT location, date, total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
FROM Portfolioproject..CovidDeaths
order by 1,2

--Total cases VS Population

SELECT location, date, total_cases,population,(total_cases/population)*100 as PercentPopulationInfected
FROM Portfolioproject..CovidDeaths
order by 1,2

--Looking at Countries with Highest Infection Rate compared population

SELECT location, population,max(total_cases) as HighestInfectionCount, max((total_cases/population))*100 as PercentPopulationInfected
FROM Portfolioproject..CovidDeaths
Group by location,	population
order by PercentPopulationInfected desc

--Showing Countries With highest Death Count per Population

SELECT location,max(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolioproject..CovidDeaths
Group by location
order by TotalDeathCount desc

-- continent by highest death count per population

SELECT continent,max(cast(total_deaths as int)) as TotalDeathCount
FROM Portfolioproject..CovidDeaths
where continent is not null
Group by continent
order by TotalDeathCount desc

--global numbers

SELECT sum(new_cases)as total_cases, sum(cast(new_deaths as int)) as total_death,sum(cast(new_deaths as int))/sum(new_cases)*100 as DeathPercentage
FROM Portfolioproject..CovidDeaths
where continent is not null
--group by date
order by 1,2

-- USE CTE
with popvsvac(continent,location,Date ,Population,New_vaccinations, rollingpeoplevaccinated )
as
(
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated 
FROM Portfolioproject..CovidDeaths dea 
join Portfolioproject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date= vac.date
where dea.continent is not null
--order by 2,3
)
select *,(rollingpeoplevaccinated/Population)*100
from popvsvac 

--Temp table 


Drop table if exists #Percentpopulationvaccinated
CREATE TABLE  #Percentpopulationvaccinated
(
Continent nvarchar(225),
Location nvarchar(225),		
date datetime, 
population numeric, 
New_vaccinations numeric,
RollingPeopleVaccinated numeric,
)

INSERT INTO #Percentpopulationvaccinated
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated 
FROM Portfolioproject..CovidDeaths dea 
join Portfolioproject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date= vac.date
--where dea.continent is not null
--order by 2,3
select *,(rollingpeoplevaccinated/Population)*100
from #Percentpopulationvaccinated

--Creating View to store data for later visualization

Create view Percentpopulationvaccinated as 
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated 
FROM Portfolioproject..CovidDeaths dea 
join Portfolioproject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date= vac.date
where dea.continent is not null
--order by 2,3

SELECT
    name,
    type_desc
FROM sys.objects
WHERE name = 'Percentpopulationvaccinated';

SELECT
    DB_NAME() AS CurrentDatabase,
    SCHEMA_NAME(schema_id) AS SchemaName,
    name,
    type_desc
FROM sys.objects
WHERE name = 'Percentpopulationvaccinated';

USE Portfolioproject;
GO

 Create view Percentpopulationvaccinated as 
SELECT dea.continent, dea.location , dea.date, dea.population, vac.new_vaccinations,
sum(convert(int, vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as rollingpeoplevaccinated 
FROM Portfolioproject..CovidDeaths dea 
join Portfolioproject..CovidVaccinations vac
  on dea.location=vac.location 
  and dea.date= vac.date
where dea.continent is not null
--order by 2,3
;
GO

Select *
from Percentpopulationvaccinated