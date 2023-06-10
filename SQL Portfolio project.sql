
	
	select  location, date, total_Cases,total_deaths
	FROM [SQL Tutorial].[dbo].[CovidDeaths] where location like '%states%' order by location, date

   Select top 10 * FROM [SQL Tutorial].[dbo].[CovidVaccinations]

   Select location,date, total_cases,new_cases, total_deaths, population 
   FROM [SQL Tutorial].[dbo].[CovidDeaths]
   order by 1,2


	-- Looking at Total case VS Total deaths

   select Location, sum(cast(total_cases as bigint) ) as TotalCases, sum(cast(total_deaths as bigint) ) as TotalDeaths
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	  group by Location
	  order by 1

	--  Percentage of total deaths in  a day in country

	   select Location, date, total_cases,total_deaths, cast(((total_deaths / total_cases) * 100)  as Decimal(10,2)) as DeathPercentage 
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	  where location like '%state%'
	  order by 1,2

	 -- percentage of population got covid


	  select Location, date, total_cases,population, cast(((total_cases / population) * 100)  as Decimal(10,2)) as Percentageinfected 
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	 --  where location like '%state%'
	  order by 1,2

	  -- Countries with highest infect rate compared to population

	  select Location, max(cast(((total_cases / population) * 100)  as Decimal(10,2))) as Percentageinfected 
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	 --  where location like '%state%'
	 group by Location order  by 2 desc


	 -- Countries with highest death rate compared to population

	  select Location, max(cast(total_deaths as Bigint)) as TotalDeaths
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	 --  where location like '%state%'
	 where continent is not null
	 group by Location order  by 2 desc


	 -- Continet with highest death rate compared to population

	  select Location, max(cast(total_deaths as Bigint)) as TotalDeaths
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	 --  where location like '%state%'
	 where continent is  null
	 group by Location order  by 2 desc




	  -- Continet with highest death rate compared to population

	  select continent, max(cast(total_deaths as Bigint)) as TotalDeaths
      FROM [SQL Tutorial].[dbo].[CovidDeaths]
	 --  where location like '%state%'
	 where continent is not  null
	 group by continent order  by 2 desc


	 -- Calculate Global numbers


	   select date, 
	   -- cast(( (sum(cast(total_deaths as int)) / sum(cast(total_cases as int)) * 100))  as Decimal(10,2)) as DeathPercentage 
	    sum(cast(total_deaths as int)) as totaldeaths, sum(cast(total_cases as int))  as total_cases
		FROM [SQL Tutorial].[dbo].[CovidDeaths]
	  where continent is not null
	  group by date
	  order by 1,2;




	  -- Covid Vaccinations

	  select * from [SQL Tutorial].[dbo].covidvaccinations


	  -- Looking at total population vs vaccinations


	  DROP Table if exists  #popvsvac;

	  select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations 
	  , sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date)  AS RollingDeaths 
	  into #popvsvac from dbo.CovidDeaths cd
	  join dbo.CovidVaccinations cv
	  on cv.location = cd.location
	  and cv.date = cd.date
	  where cd.continent is not null
	  order by 2,3

	  ;with cte_popvac AS (
	  select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations 
	  , sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) AS RollingDeaths 
	  from dbo.CovidDeaths cd
	  join dbo.CovidVaccinations cv
	  on cv.location = cd.location
	  and cv.date = cd.date
	  where cd.continent is not null)
	  select  from cte_popvac


	  -- Create View

	  Drop view if exists  dbo.covidvaccinationsperpopulation_vw

	  Create view dbo.covidvaccinationsperpopulation_vw as
	   select cd.continent, cd.location, cd.date, cd.population, cv.new_vaccinations 
	  , sum(cast(cv.new_vaccinations as int)) over (partition by cd.location order by cd.location, cd.date) AS RollingDeaths 
	  from dbo.CovidDeaths cd
	  join dbo.CovidVaccinations cv
	  on cv.location = cd.location
	  and cv.date = cd.date
	  where cd.continent is not null


	  select * from dbo.covidvaccinationsperpopulation_vw