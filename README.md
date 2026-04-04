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

This dataset contains information about Netflix content including title, type, cast, country, release year, rating, duration, and description.
### Columns include:
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
SELECT type,COUNT(*) AS total_content 
FROM netflix 
GROUP BY type;
** Objective :** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
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

