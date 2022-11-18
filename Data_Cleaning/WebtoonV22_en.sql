/*
Cleaning Data in SQL Queries
*/




--------------------------------------------------------------------------------------------------------------------------

-- Create a Copy Table that holds all the filtered and cleaned data from the raw data
-- Filtered out length, daily_pass and synopsis. If a series is locked behind a paywall, 
-- the length will only display chapters free for viewing instead of the actual count of chapters.
-- So I cleared it. Also, got rid of synopsis as it was not relevant to analysis along with daily pass

SELECT
	*
FROM Webtoon.dbo.webtoon_originals_en_V22$
ORDER BY title_id;


DROP TABLE IF EXISTS Webtoon.dbo.current_info;
CREATE TABLE Webtoon.dbo.current_info (
    title_id FLOAT PRIMARY KEY
   ,title NVARCHAR(255)
   ,genre NVARCHAR(255)
   ,authors NVARCHAR(255)
   ,weekdays NVARCHAR(255)
   ,subscribers FLOAT
   ,rating FLOAT
   ,views FLOAT
   ,likes FLOAT
   ,status NVARCHAR(255)
);


INSERT INTO Webtoon.dbo.current_info
	SELECT
		title_id
	   ,title
	   ,genre
	   ,authors
	   ,weekdays
	   ,subscribers
	   ,rating
	   ,views
	   ,likes
	   ,status
	FROM Webtoon.dbo.webtoon_originals_en_V22$;



SELECT
	*
FROM Webtoon.dbo.current_info
ORDER BY title_id;



--------------------------------------------------------------------------------------------------------------------------

-- Check each Column for any NULL entries. (No NULL entries in this dataset)

SELECT
	*
FROM Webtoon.dbo.current_info
WHERE status IS NULL;



SELECT
	*
FROM Webtoon.dbo.current_info
ORDER BY likes;

--------------------------------------------------------------------------------------------------------------------------

-- Check each Column if data fields match set parameters (misspelling, extra blanks, etc.)

SELECT
	weekdays
   ,LEN(weekdays) AS text_len
FROM Webtoon.dbo.current_info
GROUP BY weekdays;




--------------------------------------------------------------------------------------------------------------------------

-- Alter Genre fields to make it more clear and representative to the viewer
-- Explored source website(www.webtoons.com/en/genre#), to determine proper naming designations

SELECT DISTINCT
	genre
FROM Webtoon.dbo.current_info;


SELECT
   genre
   ,(CASE
	WHEN genre = 'SF' THEN 'SCI-FI'
   END) chg_name
FROM Webtoon.dbo.current_info
WHERE genre = 'SF';


UPDATE Webtoon.dbo.current_info
SET genre =
CASE
     WHEN genre = 'SF' THEN 'SCI-FI'
END
WHERE genre = 'SF';


SELECT
    genre
   ,(CASE
      	WHEN genre = 'TIPTOON' THEN 'INFORMATIVE'
    END) chg_name
FROM Webtoon.dbo.current_info
WHERE genre = 'TIPTOON';


UPDATE Webtoon.dbo.current_info
SET genre = (CASE
	WHEN genre = 'TIPTOON' THEN 'INFORMATIVE'
END)
WHERE genre = 'TIPTOON';


SELECT DISTINCT
	genre
FROM Webtoon.dbo.current_info;




--------------------------------------------------------------------------------------------------------------------------

-- Check if numeric data fields match set parametes (check if numbers under/over set range)

SELECT
	MIN(likes) AS min_value
   ,MAX(likes) AS max_value
FROM Webtoon.dbo.current_info;





--------------------------------------------------------------------------------------------------------------------------

-- Duplicate Checker and Remover

WITH cte_dupl
AS
(SELECT
		*
	   ,ROW_NUMBER() OVER (
		PARTITION BY title_id,
		title,
		authors
		ORDER BY title_id) row_cnt
	FROM Webtoon.dbo.current_info)

SELECT
	*
-- DELETE
FROM cte_dupl
WHERE row_cnt > 1;



-
