select *
from dbo.['Covid Deaths$']
order by 3,4 

select location, date, total_cases, new_cases, total_deaths, population, (total_deaths/total_cases)*100 AS DeathPercentage
from dbo.['Covid Deaths$']
order by 1,2

-- Looking at Death Percentage of Africa by month

select location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
from dbo.['Covid Deaths$']
where location like 'Africa%'
order by 1,2 

-- Looking at Countries with Highest Infection Rate compared to Population

select location, population, MAX(total_cases) AS HighestInfectionCount, MAX((total_cases/population))*100 AS PercentPopulationInfected
from dbo.['Covid Deaths$']
Group by location, population
order by PercentPopulationInfected desc

-- Showing Countries with Highest Death Count per Population

select location, Max(cast(total_deaths as int)) AS TotalDeathCount
from dbo.['Covid Deaths$']
group by location
order by TotalDeathCount desc

-- Global numbers

Select Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
From dbo.['Covid Deaths$']
where continent is not null
order by 1,2

-- Looking at total population vs vaccinations

Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, SUM(cast(vac.new_vaccinations as int)) OVER (partition by dea.location) AS RollingPeopleVaccinated
from dbo.['Covid Deaths$'] dea
join dbo.['Covid Vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
order by 2,3