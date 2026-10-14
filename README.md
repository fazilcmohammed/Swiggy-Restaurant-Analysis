# Swiggy-Restaurant-Analysis

Swiggy Restaurant Analysis: India's Food Delivery Landscape
📌 Project Overview
This project analyzes a massive real-world dataset of over 1.5 Lakh (148,541) restaurants listed on Swiggy across India. The goal of this analysis is to uncover deep business insights regarding consumer preferences, platform saturation, pricing strategies, and restaurant performance.

By executing a full ETL (Extract, Transform, Load) and data cleaning pipeline directly in PostgreSQL, this project demonstrates real-world data handling and advanced SQL querying techniques to solve business problems.

🛠️ Tech Stack & Skills Demonstrated
Database: PostgreSQL (pgAdmin 4)

Core SQL Skills: Complex Table Creation, ETL (Copy), Data Cleaning (Regular Expressions, Type Casting, NULL handling), Aggregations, Window Functions (DENSE_RANK()), Common Table Expressions (CTEs), Subqueries.

Business Intelligence: Data-driven decision making, identifying market trends, and evaluating Value for Money (VFM) metrics.

📁 Dataset Details
Source: Kaggle: Swiggy Restaurants Dataset

Total Records: 148,541

Key Features Analysed: restaurant_name, city, rating, rating_count, cost, cuisine

🧹 Phase 1: Data Cleaning & Transformation
Real-world data is inherently messy. The raw dataset contained text values inside numeric columns (e.g., ratings showing as --, and costs showing as ₹200). To process this, the data was loaded into a TEXT staging table, and then cleaned using a CREATE TABLE AS script utilizing robust Postgres string functions.

Key Transformations:

Converted invalid text (--, NA) in the rating column to SQL NULL values.

Standardized the rating_count column by replacing the "K" suffix with "000".

Stripped currency symbols (₹) and non-numeric characters from the cost and rating_count columns using REGEXP_REPLACE().

Cast the cleaned text into their correct analytical data types (INT and NUMERIC(3,1)).

(View the complete data cleaning script in sql_queries/01_data_cleaning.sql)

📊 Phase 2: Key Business Insights & Findings
1. Market Saturation & Scale
Query Focus: Finding the absolute footprint of Swiggy.

Insight: Swiggy covers an expansive network of hundreds of unique cities. The platform's highest density is concentrated in major tech and commerce hubs, indicating where their primary revenue generation originates.

2. The Dessert Dominance (Cuisine Preference)
Query Focus: GROUP BY cuisine, HAVING COUNT(id) >= 50

Insight: Sweet treats completely dominate consumer satisfaction. Four out of the top five highest-rated cuisine categories on the platform are dedicated to Ice Cream and Desserts (averaging 4.3 to 4.4 stars across over 1,000+ restaurants). If an entrepreneur wants to launch a highly-rated business on Swiggy, a dessert shop is statistically the safest bet.

3. Value for Money (VFM) Index
Query Focus: Comparing average cost against average rating by city.

Insight: Tier-2 and Tier-3 cities consistently outperform major Tier-1 metropolitan areas in terms of "Value for Money." Smaller cities frequently provide higher overall customer satisfaction at a significantly lower average cost per meal.

4. Competitive Landscape (Top Performers)
Query Focus: Using CTEs and Window Functions (DENSE_RANK() OVER(PARTITION BY...)) to find the top 3 highest-rated restaurants inside the platform's top 5 largest cities.

Insight: By partitioning the data, we successfully isolated the absolute best-performing restaurants in Swiggy's most competitive markets, proving that high volume (1,000+ ratings) can coexist with near-perfect customer satisfaction (4.5+ ratings).

🚀 How to Run This Project
Download the raw CSV from Kaggle.

Open PostgreSQL and run the table creation query located in 01_data_cleaning.sql.

Use the COPY command to import the raw CSV data into your swiggy_restaurants staging table.

Execute the secondary cleaning query to build the swiggy_cleaned table.

Run the queries in 02_business_questions.sql to generate the insights.
