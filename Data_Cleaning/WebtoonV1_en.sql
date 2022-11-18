
/*
Cleaning Data in SQL Queries
*/



--------------------------------------------------------------------------------------------------------------------------

-- Create a Copy Table that holds all the filtered and cleaned data from the raw data

SELECT
	*
FROM Webtoon.dbo.webtoon_originals_en_V1$;


DROP TABLE IF EXISTS Webtoon.dbo.old_version;
CREATE TABLE Webtoon.dbo.old_version (
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


INSERT INTO Webtoon.dbo.old_version
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
	FROM Webtoon.dbo.webtoon_originals_en_V1$;


SELECT
	*
FROM Webtoon.dbo.old_version
ORDER BY title_id;




--------------------------------------------------------------------------------------------------------------------------

-- Check each Column for any NULL entries. (No NULL entries in this dataset)

SELECT
	*
FROM Webtoon.dbo.old_version
WHERE weekdays IS NULL;




--------------------------------------------------------------------------------------------------------------------------

-- Check each Column if data fields match set parameters (misspelling, extra blanks, etc.)

SELECT
    weekdays
   ,LEN(weekdays) AS text_len
FROM Webtoon.dbo.old_version
GROUP BY weekdays;




--------------------------------------------------------------------------------------------------------------------------

-- Alter Genre fields to make it more clear and representative to the viewer
-- Explore data source website(www.webtoons.com/en/genre#), to determine proper naming designations

SELECT DISTINCT
	genre
FROM Webtoon.dbo.old_version;


SELECT
    genre
   ,(CASE
	WHEN genre = 'SF' THEN 'SCI-FI'
    END) chg_name
FROM Webtoon.dbo.old_version
WHERE genre = 'SF';


UPDATE Webtoon.dbo.old_version
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
FROM Webtoon.dbo.old_version
WHERE genre = 'TIPTOON';


UPDATE Webtoon.dbo.old_version
SET genre = (CASE
	WHEN genre = 'TIPTOON' THEN 'INFORMATIVE'
END)
WHERE genre = 'TIPTOON';


SELECT DISTINCT
	genre
FROM Webtoon.dbo.old_version;


SELECT
	*
FROM Webtoon.dbo.old_version
ORDER BY genre;



--------------------------------------------------------------------------------------------------------------------------

-- Check if numeric data fields match set parametes (check if numbers under/over set range)


SELECT
    MIN(likes) AS min_value
   ,MAX(likes) AS max_value
FROM Webtoon.dbo.old_version;


-- Duplicate Checker and Remover

WITH cte
AS
(SELECT
		*
	   ,ROW_NUMBER() OVER (
		PARTITION BY title_id,
		title,
		authors
		ORDER BY title_id) row_cnt
	FROM Webtoon.dbo.old_version)

SELECT
	*
-- DELETE
FROM cte
WHERE row_cnt > 1;
