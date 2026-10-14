-- ============================================================================
-- SWIGGY DATA ANALYSIS: BUSINESS QUESTIONS
-- ============================================================================

-- Q1. How many total cities are covered by Swiggy?
SELECT COUNT(DISTINCT city) AS total_cities 
FROM swiggy_cleaned;


-- Q2. What are the top 10 cities by number of restaurants listed?
SELECT 
    city,
    COUNT(id) AS total_restaurants
FROM swiggy_cleaned
GROUP BY city
ORDER BY total_restaurants DESC
LIMIT 10;


-- Q3. Which restaurant chains have the maximum number of branches?
SELECT 
    name, 
    COUNT(id) AS number_of_branches 
FROM swiggy_cleaned 
GROUP BY name 
ORDER BY number_of_branches DESC 
LIMIT 10;


-- Q4. What are the top 5 most popular restaurant chains by average rating?
SELECT 
    name,
    ROUND(AVG(rating), 1) AS average_rating
FROM swiggy_cleaned
WHERE rating_count >= 100
GROUP BY name
ORDER BY average_rating DESC
LIMIT 5;


-- Q5. Which city has the least expensive average cost for a meal?
SELECT 
    city, 
    ROUND(AVG(cost), 0) AS average_cost 
FROM swiggy_cleaned 
WHERE cost IS NOT NULL
GROUP BY city 
ORDER BY average_cost ASC 
LIMIT 5;


-- Q6. What are the most popular cuisines served?
SELECT 
    cuisine, 
    COUNT(id) AS total_restaurants
FROM swiggy_cleaned
GROUP BY cuisine
ORDER BY total_restaurants DESC
LIMIT 10;


-- Q7. Which restaurants have a rating above 4.5 and more than 1000 ratings?
SELECT 
    name,
    city,
    rating,
    rating_count,
    cost
FROM swiggy_cleaned
WHERE rating >= 4.5 
  AND rating_count >= 1000;


-- Q8. Which cuisines have the highest average rating?
SELECT 
    cuisine,
    ROUND(AVG(rating), 1) AS avg_rating,
    COUNT(id) AS total_restaurants
FROM swiggy_cleaned
WHERE rating IS NOT NULL
GROUP BY cuisine
HAVING COUNT(id) >= 50
ORDER BY avg_rating DESC
LIMIT 10;


-- Q9. Business Insight: Which city has the best value for money? (High rating, low cost)
SELECT 
    city,
    ROUND(AVG(rating), 1) AS avg_rating,
    ROUND(AVG(cost), 0) AS avg_cost,
    COUNT(id) AS total_restaurants
FROM swiggy_cleaned
WHERE rating IS NOT NULL 
  AND cost IS NOT NULL
GROUP BY city
HAVING COUNT(id) >= 50 -- Ensures the city has enough restaurants to be statistically valid
ORDER BY 
    avg_rating DESC,   -- Prioritizes high ratings first
    avg_cost ASC       -- Then prioritizes the cheapest cost
LIMIT 10;


-- Q10. What are the top 3 highest-rated restaurants in each of the Top 5 cities?
WITH TopCities AS (
    -- Step 1: Find the top 5 cities with the most restaurants
    SELECT city
    FROM swiggy_cleaned
    GROUP BY city
    ORDER BY COUNT(id) DESC
    LIMIT 5
),
RankedRestaurants AS (
    -- Step 2: Rank restaurants within those specific cities
    SELECT 
        s.city,
        s.name,
        s.rating,
        s.rating_count,
        -- DENSE_RANK assigns a ranking (1, 2, 3) starting over for each new city
        DENSE_RANK() OVER(PARTITION BY s.city ORDER BY s.rating DESC, s.rating_count DESC) AS rank
    FROM swiggy_cleaned s
    JOIN TopCities t ON s.city = t.city
    WHERE s.rating IS NOT NULL
)
-- Step 3: Filter the final results to only show the top 3 restaurants per city
SELECT 
    city, 
    name, 
    rating, 
    rating_count,
    rank
FROM RankedRestaurants
WHERE rank <= 3;
