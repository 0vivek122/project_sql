use olympics

--how many olympic games have been held?
select count(distinct(Games)) as total_olympics from athlete
order by 1

--list down all olympics games held so far
exec all_
select distinct(year),Season,city from athlete
order by 1

select distinct(Season),year,city from athlete
order by 2


select distinct(city),year,Season from athlete
order by 2


select year,Season,city from athlete
order by 1


--Mention the total no of nations who participated in each olympics games?

select games,count(distinct(noc)) as total_countries from athlete
group by Games
order by 1


--which year saw the highest and lowest no of cointries participating in olympics
with t1 as
(select games,count(distinct(region)) as total_countries from athlete as a join noc_regions as r on r.NOC = a.noc
group by Games),
t2 as 
(select * from t1
where total_countries = (select max(total_countries) from t1)),
t3 as 
(select * from t1
where total_countries = (select min(total_countries) from t1))
select * from t2
union
select * from t3


--which country is participated in all of the olympics
exec all_
select region,count(distinct(games))  as total from athlete as a join noc_regions as r on r.NOC= a.NOC
group by region
having count(distinct(games))= (select count(distinct(games)) from athlete )
order by region


--identitfy the sport which is played in all summer olympics
with t1 as
(
select distinct(sport) as sports ,games as t from athlete
where Season = 'summer'
),
t2 as
(select sports,count(t) as total_games from t1
group by sports)
select * from t2
where  total_games = (select count(distinct(games)) from athlete where Season='summer'  )

--which nation has participated in all of the olympics games
exec all_
with t1 as
(select distinct(region),Games from athlete as a join  noc_regions as r on a.noc= r.noc
),
t2 as
(select region,count(games) as total_games  from t1 
group by region)
select * from t2
where total_games= (select count(distinct(games)) from athlete)


--identity the sport which was played in all summer olympics
with t1 as
(select distinct(sport) ,games from athlete where Season = 'summer'),
t2 as
(select sport, count(games) as total_ from t1 group by Sport)
select * from t2 
where total_ = (select count(distinct(games)) from athlete where Season ='summer' )

--which sports were played only once in the olympics
with t1 as
(select distinct(sport),games from athlete
),
t2 as
(
select sport,games,count(games) over (partition by sport) as no_of_games from t1
)
select * from t2
where no_of_games = 1

--fetch the total no. of sports played in each olympics
with t1 as
(select distinct(games),Sport  from athlete
),
t2 as
(select games,count(sport) over (partition by games) as total_games_played from t1)
select distinct(games),total_games_played from t2
order by total_games_played desc


--oldest athlete to won the gold medalist
exec all_
select * from athlete
where medal = 'gold' and  age in (select max(age) from athlete where medal = 'gold' )

with t as
(select * from athlete
where medal = 'gold' ),
rnk as
(select *,rank() over (order by age desc) as age_ from t)
select * from rnk
where age_ = 1

-- Find the Ratio of male and female athletes participated in all olympic games.
with m as
(select count(sex) as total from athlete
where sex= 'M'
),
f as 
(select count(sex) as total from athlete
where sex= 'F'
)
select 

--Fetch the top 5 athletes who have won the most gold medals.
exec all_
with t as
(select name,team,count(medal) as total_gold from athlete
where medal = 'gold'
group by name,Team),
t1 as
(select *,DENSE_RANK() over (order by total_gold desc) as rank_ from t)
select * from t1 
where rank_ <= 5

--Fetch the top 5 athletes who have won the most medals (gold/silver/bronze)
with t as
(select name,team,count(medal) as total_medal from athlete
where medal != 'NA'
group by name,Team),
t1 as
(select *,DENSE_RANK() over (order by total_medal desc) as rank_ from t)
select * from t1 
where rank_ <= 5

--Fetch the top 5 most successful countries in olympics. Success is defined by no of medals won.(doubt in this question)
with t as
(
select distinct(region), event,Sport,games,medal  from athlete as a join noc_regions as r on r.noc=a.noc
where medal <> 'na' 
)
select region ,count(medal) as total from t
group by region
order by total desc



--In which Sport/event, India has won highest medals.
with t as(
select Sport,count(medal) total from athlete  as a join noc_regions as r on r.noc=a.noc
where region = 'india' and medal <> 'NA'
group by Sport 
)
select * from t 
where total = (select max(total) from t)

-- Break down all olympic games where India won medal for Hockey and how many medals in each olympic games
select region,Games,Sport,count(Medal) as medals_won from athlete  as a join noc_regions as r on r.noc=a.noc
where region = 'india' and medal <> 'NA'  and sport = 'Hockey'
group by region,games,Sport
order by medals_won desc
