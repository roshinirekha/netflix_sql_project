-- NETFLIX PROJECT--

CREATE TABLE netflix(
show_id VARCHAR(6),
type VARCHAR(10),
title VARCHAR(150),
director VARCHAR(208),
casts VARCHAR(1000),
country VARCHAR(150),
date_added VARCHAR(50),
release_year INT,
rating VARCHAR(10),
duration VARCHAR(15),
listed_in VARCHAR(100),
description VARCHAR(250)
 );

 SELECT * FROM netflix;

SELECT COUNT(*) FROM netflix;

SELECT DISTINCT type FROM netflix;

-- 15 Business Problems & Solutions--

--1. Count the number of Movies vs TV Shows--
SELECT type,COUNT(*) AS total_content 
FROM netflix 
GROUP BY type;

--2. Find the most common rating for movies and TV shows--
SELECT 
    type,
    rating 
FROM (
    SELECT 
        type,
        rating,
        COUNT(*) AS count,
        RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS ranking
    FROM netflix
    GROUP BY type, rating
) t
WHERE ranking = 1;

--3. List all movies released in a specific year (e.g., 2020)--
SELECT * FROM netflix 
WHERE type='Movie' 
AND release_year=2020;

--4. Find the top 5 countries with the most content on Netflix--
SELECT 
    TRIM(country) AS country,
    COUNT(*) AS total_content
FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country
    FROM netflix
    WHERE country IS NOT NULL
) t
GROUP BY country
ORDER BY total_content DESC
LIMIT 5;

--5. Identify the longest movie--
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
  AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;

--6. Find content added in the last 5 years--
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';

--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!--
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';

--8. List all TV shows with more than 5 seasons--
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;

--9. Count the number of content items in each genre--
SELECT 
    TRIM(genre) AS genre,
    COUNT(*) AS content_count
FROM netflix,
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY genre
ORDER BY content_count DESC;

--10.Find each year and the average numbers of content release in India on netflix.--
SELECT 
    year,
    COUNT(*) AS yearly_content,
    ROUND(COUNT(*) * 100.0 / total.total_count, 2) AS avg_content_per_year
FROM (
    SELECT 
        EXTRACT(YEAR FROM TO_DATE(date_added, 'Month DD, YYYY')) AS year
    FROM netflix
    WHERE country ILIKE '%India%'
) t,
(
    SELECT COUNT(*) AS total_count
    FROM netflix
    WHERE country ILIKE '%India%'
) total
GROUP BY year, total.total_count
ORDER BY avg_content_per_year DESC
LIMIT 5;

--11. List all movies that are documentaries--
SELECT * FROM netflix
WHERE  listed_in ILIKE '%Documentaries';

--12. Find all content without a director--
SELECT * FROM netflix
WHERE  director IS NULL;

--13. Find how many movies actor 'Salman Khan' appeared in last 10 years!--
SELECT * FROM netflix
WHERE type = 'Movie'
AND casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;

--14.Find the top 10 actors who have appeared in the highest number of movies produced in India.--
   SELECT 
    TRIM(actor) AS actor,
    COUNT(*) AS movie_count
FROM (
    SELECT 
        UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor
    FROM netflix
    WHERE country ILIKE '%India%'
      AND type = 'Movie'
) t
GROUP BY actor
ORDER BY movie_count DESC
LIMIT 10;

--15.Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.
WITH new_table AS (
    SELECT *,
        CASE 
            WHEN description ILIKE '%kill%' 
              OR description ILIKE '%violence%' 
            THEN 'Bad_Content'
            ELSE 'Good_Content'
        END AS category
    FROM netflix
)

SELECT 
    category,
    COUNT(*) AS total_content
FROM new_table
GROUP BY category;