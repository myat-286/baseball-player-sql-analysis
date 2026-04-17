--  SCHOOL ANALYSIS

--  View the schools and school details tables
select* from schools;
select* from school_details;

 -- Numbers of schools that produced players in each decade 
 select  round(yearID,-1) as decade, count(distinct schoolID) as num_schools
 from schools
 group by round(yearID,-1) ;
 
 -- Top 5 schools name that produced the most players
 select sd.name_full, count(distinct s.playerID) as num_players
 from schools as s 
 left join school_details as sd
 on s.schoolID=sd.schoolID
 group by sd.name_full
 order by count(distinct s.playerID) desc
 limit 5;
 
 -- Names of the top 3 schools that produced the most players for each decade 
with p as (select round(s.yearID,-1) as decade ,
sd.name_full, count(distinct s.playerID) as num_players
from schools as s 
left join school_details as sd
on s.schoolID = sd.schoolID
group by round(s.yearID,-1),sd.name_full
order by count(distinct s.playerID) desc) ,

top3 as (select*,
row_number() over(partition by decade order by num_players desc) as top_3
from p)

select*
from top3
where top_3 <=3 ;
