use Covid
--death rate of countries
select location,population,total_cases,total_deaths,(total_deaths/total_cases)*100 as death_rate from covideath
order by 1,2

--highest death_rate of countries
select location,max(total_deaths) as max_death, max((total_deaths/total_cases)*100) as max_death_rate from covideath
where continent is not null
group by location
order by 1

--covid_rate of countries
select location,population,total_cases, (total_cases/population)*100 as covid_rate from covideath
order by 1,2

--covid_rate of our country
select location,date,population,total_cases, (total_cases/population)*100 as covid_rate from covideath
where location= 'india'
order by total_cases 

--total deaths on the basis on contient
select continent,max(cast(total_deaths as int)) as total_death from covideath
where continent is not null and location='india'
group by continent
order by total_death desc


--sum of new cases , new deaths, death_rate  daily of whole world
select date,sum(new_cases) as new_case , sum(cast(new_deaths as int)) as new_death,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_rate from covideath
where continent is not null
group by date
order by date

--death_rate of whole world
select sum(new_cases) as new_case , sum(cast(new_deaths as int)) as new_death,(sum(cast(new_deaths as int))/sum(new_cases))*100 as death_rate from covideath
where continent is not null


--joining two table 
select v.date,v.total_vaccinations ,d.total_deaths,v.location from covideath as d join covidvaccination as v 
on d.date= v.date and  d.location = v.location
where v.location = 'india'
order by d.location



-- the vaccination  of our country
select location , date ,cast(total_vaccinations as int) as vaccination ,population  from covidvaccination
where location ='India' and total_vaccinations is not null and continent is not  null
order by vaccination desc


-- vacination rate of countries 
select location,date,cast(total_vaccinations as bigint) as vaccination ,population ,(cast(total_vaccinations as bigint)/population)*100 as vaccination_rate from covidvaccination
where  total_vaccinations is not null  and location = 'India'
order by vaccination_rate desc



--new vaccinition
select d.location, d.date ,d.total_deaths,v.location,v.date,cast(v.new_vaccinations as bigint)as new_vaccinition,(cast(v.new_vaccinations as bigint)/cast(v.total_vaccinations as bigint))*100 as vaccinition_rate from covideath as d join covidvaccination as v 
on d.date= v.date and d.location = v.location
where new_vaccinations is not null  and (cast(v.total_vaccinations as bigint)!= 0 ) 
order by cast(v.total_vaccinations as bigint) desc




-- max vaccination  rate of country
select d.location,max(cast(total_vaccinations as bigint)) as max_vaccination,v.population,(max(cast(total_vaccinations as bigint)/v.population))*100 as max_vaccinationrate from covideath as d
inner join covidvaccination as v on v.location = d.location and v.date = d.date
where v.continent is not null
group by d.location,v.population
order by d.location 

-- create view
create view maxVaccinationRatenb as
select d.location,max(cast(total_vaccinations as bigint)) as max_vaccination,v.population,(max(cast(total_vaccinations as bigint)/v.population))*100 as max_vaccinationrate from covideath as d
inner join covidvaccination as v on v.location = d.location and v.date = d.date
where v.continent is not null
group by d.location,v.population 


select * from maxVaccinationRatenb




