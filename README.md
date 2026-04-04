# Netflix Movies and TV Shows Data Analysis using SQL
![Netflix_Logo](https://github.com/roshinirekha/netflix_sql_project/blob/main/logo.png)
## 📌 Overview
This project analyzes Netflix movies and TV shows data using SQL to extract meaningful insights.
The analysis focuses on understanding content distribution, ratings, trends, and patterns across different countries and years.
## 🎯Objectives
- Analyze distribution of Movies vs TV Shows
- Identify the most common ratings
- Find top countries producing content
- Analyze content trends over the years
- Identify longest movies and TV shows
- Categorize content based on keywords

## 📂 Dataset
The dataset used in this project is sourced from Kaggle.

- **Dataset Name:** Netflix Movies and TV Shows  
- **Source:** Kaggle  
- **Link:** https://www.kaggle.com/datasets/shivamb/netflix-shows  
- **Records:** ~8800+ entries  

This dataset provides structured information about Netflix content, including various attributes related to movies and TV shows.

### Columns Included:
- Title  
- Type (Movie / TV Show)  
- Director  
- Cast  
- Country  
- Release Year  
- Rating  
- Duration  
- Genre (listed_in)  
- Description  

## 🗂️ Schema
```sql
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
```
 ## 💼 Business Problems & SQL Queries
 ### 1. Count the Number of Movies vs TV Shows
 ```sql
SELECT type,COUNT(*) AS total_content 
FROM netflix 
GROUP BY type;
```
**Objective :** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
 ```sql
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
```
**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * FROM netflix 
WHERE type='Movie' 
AND release_year=2020;
```
**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
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
```
**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie
```sql
SELECT title, duration
FROM netflix
WHERE type = 'Movie'
AND duration IS NOT NULL
ORDER BY CAST(SPLIT_PART(duration, ' ', 1) AS INT) DESC
LIMIT 1;
```
**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
```sql
SELECT *
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT *
FROM netflix
WHERE director ILIKE '%Rajiv Chilaka%';
```
**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT *
FROM netflix
WHERE type = 'TV Show'
AND CAST(SPLIT_PART(duration, ' ', 1) AS INT) > 5;
```
**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre
```sql
SELECT 
    TRIM(genre) AS genre,
    COUNT(*) AS content_count
FROM netflix,
UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre
GROUP BY genre
ORDER BY content_count DESC;
```
**Objective:** Count the number of content items in each genre.

### 10.Find each year and the average numbers of content release in India on netflix.
#### return top 5 year with highest avg content release!
```sql
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
```
**Objective:** Calculate and rank years by the average number of content releases by India.

### 11. List All Movies that are Documentaries
```sql
SELECT * FROM netflix
WHERE  listed_in ILIKE '%Documentaries';
```
**Objective:** Retrieve all movies classified as documentaries.

### 12. Find All Content Without a Director
```sql
SELECT * FROM netflix
WHERE  director IS NULL;
```
**Objective:** List content that does not have a director.

### 13. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years
```sql
SELECT * FROM netflix
WHERE type = 'Movie'
AND casts ILIKE '%Salman Khan%'
AND release_year >= EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```
**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years

### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India
```sql
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
```
**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
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
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## 📈 Key Insights
- Movies are more common than TV Shows on Netflix
- USA and India produce the highest number of titles
- TV-MA is the most frequent rating
- Content production increased significantly after 2015
- Certain genres dominate Netflix’s catalog

 ## ✅ Conclusion
- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.
This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.

## 🛠️ Technical Overview
### 🔧 Tools Used

- **SQL (PostgreSQL)** – for data querying and analysis  
- **Kaggle Dataset** – data source  
- **GitHub** – version control and project documentation  

### 🧠 SQL Concepts Used

- Aggregations (COUNT, GROUP BY)  
- Window Functions (RANK)  
- Common Table Expressions (CTEs)  
- String Functions (STRING_TO_ARRAY, UNNEST)  
- Conditional Logic (CASE WHEN)  

## 👩‍💻 Author
### Roshini R
This project is part of my portfolio, demonstrating practical SQL skills used in real-world data analysis.
