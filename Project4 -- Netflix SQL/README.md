# Netflix Data Analysis Using SQL

## Project Overview

**Level:** Intermediate to Hard  
**Database:** `netflix_db`

This project performs an in-depth Netflix Data Analysis using SQL, focusing on database design, querying, and data analysis. The project aims to solve 15 business problems related to Netflix content, such as content distribution, director and actor analytics, genre categorization, and trends in content releases.

## Objectives

- **Database Setup:** Create and manage a structured database for Netflix content.
- **Data Querying:** Perform SQL operations to retrieve and analyze data.
- **Advanced SQL Queries:** Use CTEs, window functions, and string manipulations to solve complex problems.
- **Business Insights:** Generate insights into Netflix content distribution, ratings, and trends.

## 🏗 ER Diagram
![ER Diagram](https://github.com/Himanshu20752005/SQL-Data-Analyst-Journey-/blob/main/Project4%20--%20Netflix%20SQL/ER_Digram.png)
              
## Project Structure

### 1. Database Setup

#### Entity Relationship Diagram (ERD)

The database consists of the following table:

```sql
CREATE TABLE netflix (
    show_id SERIAL PRIMARY KEY,
    type TEXT,
    title TEXT,
    director TEXT,
    casts TEXT,
    country TEXT,
    date_added TEXT,
    release_year INT,
    rating TEXT,
    duration TEXT,
    listed_in TEXT,
    description TEXT
);
```

### 2. Business Problems and SQL Solutions

#### 1. Count the Number of Movies vs TV Shows
```sql
SELECT type, COUNT(*) FROM netflix GROUP BY 1;
```

#### 2. Find the Most Common Rating for Movies and TV Shows
```sql
WITH RatingCounts AS (
    SELECT type, rating, COUNT(*) AS rating_count
    FROM netflix
    GROUP BY type, rating
),
RankedRatings AS (
    SELECT type, rating, rating_count,
           RANK() OVER (PARTITION BY type ORDER BY rating_count DESC) AS rank
    FROM RatingCounts
)
SELECT type, rating AS most_frequent_rating FROM RankedRatings WHERE rank = 1;
```

#### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
SELECT * FROM netflix WHERE release_year = 2020;
```

#### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
SELECT * FROM (
    SELECT UNNEST(STRING_TO_ARRAY(country, ',')) AS country, COUNT(*) AS total_content
    FROM netflix GROUP BY 1
) AS t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5;
```

#### 5. Identify the Longest Movie
```sql
SELECT * FROM netflix WHERE type = 'Movie' ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC;
```

#### 6. Find Content Added in the Last 5 Years
```sql
SELECT * FROM netflix WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years';
```

#### 7. Find All the Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
SELECT * FROM (
    SELECT *, UNNEST(STRING_TO_ARRAY(director, ',')) AS director_name FROM netflix
) AS temp
WHERE director_name = 'Rajiv Chilaka';
```

#### 8. List All TV Shows with More Than 5 Seasons
```sql
SELECT * FROM netflix WHERE type = 'TV Show' AND SPLIT_PART(duration, ' ', 1)::INT > 5;
```

#### 9. Count the Number of Content Items in Each Genre
```sql
SELECT UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre, COUNT(*) AS total_content FROM netflix GROUP BY 1;
```

#### 10. Find the Top 5 Years with the Highest Average Content Release in India
```sql
SELECT country, release_year, COUNT(show_id) AS total_release,
       ROUND(
           COUNT(show_id)::numeric /
           (SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100, 2
       ) AS avg_release
FROM netflix
WHERE country = 'India'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;
```

#### 11. List All Movies That Are Documentaries
```sql
SELECT * FROM netflix WHERE listed_in LIKE '%Documentaries%';
```

#### 12. Find All Content Without a Director
```sql
SELECT * FROM netflix WHERE director IS NULL;
```

#### 13. Find How Many Movies Actor 'Salman Khan' Appeared in Last 10 Years
```sql
SELECT * FROM netflix WHERE casts LIKE '%Salman Khan%' AND release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10;
```

#### 14. Find the Top 10 Actors Who Have Appeared in the Most Movies Produced in India
```sql
SELECT UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor, COUNT(*) AS total_movies
FROM netflix
WHERE country = 'India'
GROUP BY 1
ORDER BY total_movies DESC
LIMIT 10;
```

#### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' in Descriptions
```sql
SELECT category, type, COUNT(*) AS content_count
FROM (
    SELECT *,
           CASE WHEN description ILIKE '%kill%' OR description ILIKE '%violence%' THEN 'Bad' ELSE 'Good' END AS category
    FROM netflix
) AS categorized_content
GROUP BY 1,2
ORDER BY 2;
```

## How to Use

```sh
# Clone the repository
git clone https://github.com/YourGitHub/Netflix-Data-Analysis.git

# Set up the database
# Execute the SQL scripts to create the tables and insert the data

# Run queries
# Use the SQL scripts to analyze data
```

## Conclusion

This project provides a structured approach to data analysis, SQL querying, and business intelligence for Netflix content. It helps in understanding real-world data analytics and SQL applications.

