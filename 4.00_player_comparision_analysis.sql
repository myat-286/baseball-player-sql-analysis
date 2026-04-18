-- number of players
select *
from players;

-- players who have the same birthday 
with bd as (select nameGiven,cast(concat(birthYear,"-",birthMonth,"-", birthDay) as date) as BOD
from players)

select BOD,group_concat(nameGiven) as name, count(nameGiven)
from bd
where BOD is not  null 
group by BOD 
having count(nameGiven) >= 2
order by BOD;

-- percent of players bat right, left and both by team 
with pb as(select p.playerID,s.teamID,  p.bats
from players as p 
left join salaries as s
on p.playerID=s.playerID
group by p.playerID,s.teamID, p.bats) 

select teamID,
round(sum(case when bats = "R" then 1 else 0 end)/count(playerID) * 100,1) as right_side ,
round(sum(case when bats = "L" then 1 else 0 end)/count(playerID) * 100,1) as left_side ,
round(sum(case when bats = "B" then 1 else 0 end) /count(playerID) * 100,1) as both_side 
from pb
group by teamID;

-- -- average height and weight after debut game changed over the years and difference from one decade to another
with dv as (select round(year(debut),-1) as decade, avg(weight) as avg_weight, avg(height) as avg_height
from players
group by round(year(debut),-1)),

pr as (select decade, avg_weight, avg_height,
Lag(avg_weight) over(order by decade) as pre_weight,
Lag(avg_height) over(order by decade) as pre_height
from dv)

select decade, avg_weight, pre_weight, avg_weight-pre_weight as weight_diff,
avg_height, pre_height, avg_height-pre_height as height_diff
from pr
where decade is not null;
