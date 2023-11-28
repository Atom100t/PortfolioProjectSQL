select *
 from PortfolioProject..CovidDeaths
 order by 3,4


 --Checking Total Cases vs Total Deaths
 --Checking the percentage of dying from Covid in a Country 
 select location, date,total_cases, total_deaths, (total_deaths/total_cases)*100 as DealthPercentage 
 from PortfolioProject..CovidDeaths
 where location='Nigeria'
 order by 1,2 





 --Checking Total Cases vs Population 
 --Checking the percentage of a country that contacted Covid   
  select location, date,total_cases, population, (total_cases/population)*100 as CasePerPopulationPercentage 
 from PortfolioProject..CovidDeaths
 where location='Nigeria'
 order by 1,2
 


 --Checking Countries Highest Infection Rate compare to their Population 
   select location,max(total_cases) as MaxTotalCase, population, max(total_cases)/population*100 as PopulationInfectedPercentage 
 from PortfolioProject..CovidDeaths
 where location is not null and total_deaths is not null and continent is not null
 group by location, population
 order by  PopulationInfectedPercentage desc



 --Checking HighestDealth Count per Country 
   select location, max(cast(total_deaths as int)) as MaxTotalDealth
    from PortfolioProject..CovidDeaths
 where location is not null and total_deaths is not null and continent is not null
 group by location
 order by  MaxTotalDealth desc






 --Checking HighestDealth Count per Continent 
   select location, max(cast(total_deaths as int)) as MaxTotalDealth
    from PortfolioProject..CovidDeaths
 where  location <> 'world' and total_deaths is not null and continent is null
 group by location
 order by  MaxTotalDealth desc






 --Checking DealthPercentage Per Continent 
    select Location, max(cast(total_deaths as int)) as TotalDealth,Population, max(cast(total_deaths as int))/population*100 as DealthPercentage 
    from PortfolioProject..CovidDeaths
 where  location <> 'world'and location <> 'international' and total_deaths is not null and continent is null
 group by location, population
 order by  TotalDealth desc



 --Checking Global DealthPercentage Per Date
    select Date, sum(new_cases) as TotalCases ,sum(Cast(new_deaths as int)) as TotalDealth, sum(Cast(new_deaths as int))/sum(new_cases)*100 as DealthPercentage 
    from PortfolioProject..CovidDeaths
 where continent is not null
 group by date 
 order by 1,2 

 
 --Checking Global DealthPercentage 
    select  sum(new_cases) as TotalCases ,sum(Cast(new_deaths as int)) as TotalDealth, sum(Cast(new_deaths as int))/sum(new_cases)*100 as DealthPercentage 
    from PortfolioProject..CovidDeaths
 where continent is not null
 order by 1,2


--Total Population vs Vacinaction  
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date  
where dea.continent is not null 
order by 2,3 

--view for TotalPopulation vs Vacinaction
create view TotalPopulationvsVacinaction as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date  
where dea.continent is not null 



---PopulationVaccinatedPercentage 


drop Table if exists #PopulationVaccinatedPercentage 

Create table #PopulationvaccinatedPercentage 
(
continent nvarchar(255),
location nvarchar(255),
date datetime ,
population numeric,
New_vaccinations numeric,
peoplevaccinated numeric
)

insert into #PopulationvaccinatedPercentage
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date  
where dea.continent is not null 
 

 select *, (peoplevaccinated/population)*100 
 from  #PopulationvaccinatedPercentage






 ---VIEWS

 --view for PopulationVaccinatedPercentage 
create view PopulationVaccinatedPercentage  as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations, sum(cast(vac.new_vaccinations as int))
over (partition by dea.location order by dea.location, dea.date) as peoplevaccinated
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date  
where dea.continent is not null 

--view for TotalPopulation vs Vacinaction
create view TotalPopulationvsVacinaction as 
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
from PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations vac
on dea.location= vac.location 
and dea.date=vac.date  
where dea.continent is not null 
order by 2,3 

--view Gobal DealthPercentage 
create view GlobalDealthPercentage as 
select  sum(new_cases) as TotalCases ,sum(Cast(new_deaths as int)) as TotalDealth, sum(Cast(new_deaths as int))/sum(new_cases)*100 as DealthPercentage 
    from PortfolioProject..CovidDeaths
 where continent is not null
