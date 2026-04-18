
-- salary table
select*
from salaries; 

-- top 20% of teams in terms of average annual spending
with ts  as (select yearID, teamID, sum(salary) as total_salary
from salaries
group by yearID, teamID) ,

sp as (select  teamID, avg(total_salary) as avg_salary,
ntile(5) OVER(order by avg(total_salary) desc) as top_20
from ts
group by  teamID)

select teamID, round(avg_salary /1000000,1) as avg_spend_mill
from sp
where top_20 = 1;

--  cumulative sum of spending over the years for each team 
with ts as (select yearID, teamID, sum(salary) as total_spend
from salaries
group by yearID, teamID)

select*,
round(sum(total_spend) over(partition by teamID order by yearID )/1000000,1) as cumu_sum
from ts
order by teamID, yearID;

-- the first year that each team's cumulative spending surpassed 1 billion
with ts as (select yearID, teamID, sum(salary) as total_spend
from salaries
group by yearID, teamID),

cumu_sum as(select*,
sum(total_spend) over(partition by teamID order by yearID ) as cumu_sum
from ts
order by teamID, yearID),

ob as (select*
from cumu_sum
where cumu_sum >  1000000000) ,

first_bil as (select*,
row_number() over(partition by teamID order by cumu_sum asc)  as first_year
from ob)

select yearID, teamID,
round(cumu_sum/ 1000000000,2) as first_bil
from first_bil
where first_year=1;
