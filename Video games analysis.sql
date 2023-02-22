-- 1. Top 10 best selling video games
-- Select all information for the top ten best-selling games
-- Order the results from best-selling game down to tenth best-selling
USE sql_video_games;

Select *
From game_sales
ORDER BY games_sold DESC
LIMIT 10;

-- 2. Find missing review scores
-- Join games_sales and reviews
-- Select a count of the number of games where both critic_score and user_score are null
SELECT count(*)
From game_sales
LEFT JOIN game_reviews
ON game_sales.name = game_reviews.name
WHERE Critic_score IS NULL
AND User_score IS NULL;
-- ANS 222

-- 3. Years that video game critics loved
-- Select release year and average critic score for each year, rounded and aliased
-- Join the game_sales and reviews tables
-- Group by release year
-- Order the data from highest to lowest avg_critic_score and limit to 10 results
SELECT year, round(avg(critic_score), 2) as avg_critic_score
FROM game_sales as gs
INNER JOIN game_reviews as gr
ON gs.name = gr.name
GROUP BY year
ORDER BY avg_critic_score DESC
LIMIT 10;

-- 4. Was 1982 really that great?
-- Paste your query from the previous task; update it to add a count of games released in each year called num_games
-- Update the query so that it only returns years that have more than four reviewed games 
SELECT year, round(avg(critic_score), 2) as avg_critic_score, count(year) as num_games
FROM game_sales as gs
INNER JOIN game_reviews as gr
ON gs.name = gr.name
GROUP BY year
HAVING count(gs.name) > 4
ORDER BY avg_critic_score DESC
LIMIT 10;

-- 5. Years that dropped off the critics'favorites list
-- Select the year and avg_critic_score for those years that dropped off the list of critic favorites 
-- Order the results from highest to lowest avg_critic_score
SELECT year, avg_critic_score
FROM top_critic_scores
except
SELECT year, avg_critic_score
FROM top_critic_scores_more_than_four_games
ORDER BY avg_critic_score DESC;

-- 6. Years video game players loved
-- Select year, an average of user_score, and a count of games released in a given year, aliased and rounded
-- Include only years with more than four reviewed games; group data by year
-- Order data by avg_user_score, and limit to ten results
SELECT year, round(avg(user_score), 2) as avg_user_score, count(year) as num_games
FROM game_sales as gs
INNER JOIN game_reviews as gr
ON gs.name = gr.name
GROUP BY year
HAVING count(gs.name) > 4
ORDER BY avg_user_score DESC
LIMIT 10;

-- 7. Years that both players and critics loved
-- Select the year results that appear on both tables
Select year
FROM top_critic_scores_more_than_four_games
INTERSECT
Select year
FROM top_user_scores_more_than_four_games;

-- 8. Sales in the best video game years
-- Select year and sum of games_sold, aliased as total_games_sold; order results by total_games_sold descending
-- Filter game_sales based on whether each year is in the list returned in the previous task
Select gs.year, sum(gs.games_sold) as total_games_sold
From game_sales as gs
WHERE gs.year IN (Select year
FROM top_critic_scores_more_than_four_games
	INTERSECT
Select year
FROM top_user_scores_more_than_four_games)
GROUP BY gs.year
ORDER BY total_games_sold DESC;



