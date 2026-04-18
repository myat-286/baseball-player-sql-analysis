-- number of players
select count(*)
from players;

--  age at the first game,  last game, and their career length 
select nameGiven, debut, finalGame, concat(birthYear,"-",birthMonth,"-", birthDay) as BOD,
timestampdiff(year,concat(birthYear,"-",birthMonth,"-", birthDay), debut) firstgame_age,
timestampdiff(year,concat(birthYear,"-",birthMonth,"-", birthDay), finalGame) lastgame_age,
timestampdiff(year,debut,finalGame) as carrer_length 
from players
order by timestampdiff(year,debut,finalGame) desc; 
