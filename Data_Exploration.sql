--------------------------------------------------------------------------------------------------------------------------

-- Overall growth rate from Ver1 to Ver22

SELECT
    SUM(ci.views) views
   ,SUM(ci.subscribers) subs
   ,SUM(ci.likes) likes
   ,SUM(ci.rating) rating
   ,((SUM(ci.likes) / SUM(oi.likes)) - 1) * 100 likes_growth
   ,((SUM(ci.subscribers) / SUM(oi.subscribers)) - 1) * 100 subs_growth
   ,((SUM(ci.likes) / SUM(oi.likes)) - 1) * 100 likes_growth
   ,((SUM(ci.rating) / SUM(oi.rating)) - 1) * 100 ratings_growth
FROM Webtoon.dbo.current_info ci
FULL OUTER JOIN Webtoon.dbo.old_info oi
	ON ci.title_id = oi.title_id;




--------------------------------------------------------------------------------------------------------------------------

-- KPIs of old info

DROP TABLE IF EXISTS Webtoon.dbo.old_kpi;
CREATE TABLE Webtoon.dbo.old_kpi (
    title_id FLOAT PRIMARY KEY
   ,likes_to_views FLOAT
   ,subs_to_views FLOAT
);


INSERT INTO Webtoon.dbo.old_kpi
	SELECT
	    title_id
	   ,SUM(likes) / SUM(views) * 100 likes_to_views
	   ,SUM(subscribers) / SUM(views) * 100 subs_to_views
	FROM Webtoon.dbo.old_info
	GROUP BY title_id
	ORDER BY title_id;


SELECT
	*
FROM Webtoon.dbo.old_kpi
ORDER BY title_id;


-- KPIs of current info

DROP TABLE IF EXISTS Webtoon.dbo.current_kpi;
CREATE TABLE Webtoon.dbo.current_kpi (
    title_id FLOAT PRIMARY KEY
   ,likes_to_views FLOAT
   ,subs_to_views FLOAT
);


INSERT INTO Webtoon.dbo.current_kpi
	SELECT
	    title_id
	   ,SUM(likes) / SUM(views) * 100 likes_to_views
	   ,SUM(subscribers) / SUM(views) * 100 subs_to_views
	FROM Webtoon.dbo.current_info
	GROUP BY title_id
	ORDER BY title_id;


SELECT
	*
FROM Webtoon.dbo.current_kpi
ORDER BY title_id;


SELECT
	*
FROM Webtoon.dbo.old_kpi
INNER JOIN Webtoon.dbo.old_info oi
	ON Webtoon.dbo.old_kpi.title_id = oi.title_id
ORDER BY oi.title_id;




--------------------------------------------------------------------------------------------------------------------------

-- Creating View for potential later usage. Store growth rate data for INDIVIDUAL titles

DROP VIEW IF EXISTS growth_rates;
CREATE VIEW growth_rates
AS

SELECT
	ci.title_id
   ,ci.views
   ,ci.subscribers
   ,ci.likes
   ,ci.rating
   ,((ci.views / oi.views) - 1) * 100 views_growth
   ,((ci.subscribers / oi.subscribers) - 1) * 100 subs_growth
   ,((ci.likes / oi.likes) - 1) * 100 likes_growth
   ,((ci.rating / oi.rating) - 1) * 100 ratings_growth
   ,((ck.likes_to_views / ok.likes_to_views) - 1) * 100 ltv_growth
   ,((ck.subs_to_views / ok.subs_to_views) - 1) * 100 stv_growth
FROM Webtoon.dbo.current_info ci
INNER JOIN Webtoon.dbo.current_kpi ck
	ON ci.title_id = ck.title_id
INNER JOIN Webtoon.dbo.old_info oi
	ON ci.title_id = oi.title_id
INNER JOIN Webtoon.dbo.old_kpi ok
	ON ok.title_id = ck.title_id;


SELECT
	*
FROM growth_rates gr;
-- Noticed a couple of titles are missing from the V1 compared to V22 tables
-- Both titles were from the same author Ann who's titles were removed per the author's wishes


SELECT
	*
FROM Webtoon.dbo.old_info oi
LEFT JOIN Webtoon.dbo.current_info ci
	ON oi.title_id = ci.title_id
WHERE ci.title_id IS NULL;




--------------------------------------------------------------------------------------------------------------------------

-- Genre Segmentation- view basic engagement metrics to determine which genre has the best perfromance
-- Romance seems to be highest overall across all categories

SELECT
    genre
   ,SUM(views) total_views
   ,SUM(subscribers) total_subs
   ,SUM(likes) total_likes
   ,AVG(rating) avg_rating
FROM Webtoon.dbo.current_info
GROUP BY genre
ORDER BY total_views DESC;


-- SUPERHERO was the only genre with an 8 score average rating
-- Calculated median to see if data was skewed. Result showed that the median has more consistent values

SELECT DISTINCT
    genre
   ,AVG(rating) OVER (PARTITION BY genre ORDER BY genre) avg_rating
   ,PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY rating) OVER (PARTITION BY genre) AS median
FROM Webtoon.dbo.current_info ci
ORDER BY median DESC;




-- Viewed the distribution of titles to see if they is a skew
-- Majority of titles are ROMANCE and the small sample size is skewing some of the average ratings

SELECT
    genre
   ,COUNT(title) title_cnt
   ,FORMAT((CAST(COUNT(title) AS FLOAT)) / SUM(COUNT(*)) OVER (), 'p') titles_dist
   ,MIN(rating) min_rating
   ,MAX(rating) max_rating
   ,AVG(rating) avg_rating
FROM Webtoon.dbo.current_info ci
GROUP BY genre
ORDER BY title_cnt DESC;



-- Views genres performing well relative to their title sample size 

SELECT
	genre
   ,(CAST(COUNT(title) * 100 AS FLOAT)) / SUM(COUNT(*)) OVER () titles_dist
   ,SUM(views) total_views
   ,SUM(subscribers) total_subs
   ,SUM(likes) total_likes
   ,AVG(rating) avg_rating
FROM Webtoon.dbo.current_info
GROUP BY genre
ORDER BY titles_dist DESC;
