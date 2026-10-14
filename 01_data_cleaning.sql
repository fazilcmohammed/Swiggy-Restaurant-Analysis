-- 1. Create the initial staging table to hold raw CSV data
CREATE TABLE swiggy_restaurants (
    id TEXT,
    name TEXT,
    city TEXT,
    rating TEXT,
    rating_count TEXT,
    cost TEXT,
    cuisine TEXT,
    lic_no TEXT,
    link TEXT,
    address TEXT,
    menu TEXT
);

-- Note: Use pgAdmin's Import/Export tool or the COPY command here to load your raw CSV data into swiggy_restaurants.

-- 2. Create the final cleaned table with the corrected 'K' multiplier logic
CREATE TABLE swiggy_cleaned AS
SELECT 
    CAST(id AS INT) AS id,
    name,
    city,
    
    -- Handle missing/invalid ratings
    CAST(
        CASE 
            WHEN rating IN ('--', 'NA', '') THEN NULL 
            ELSE rating 
        END AS NUMERIC(3,1)
    ) AS rating,
    
    -- Replace 'K' with '000' before stripping other text
    CAST(NULLIF(REGEXP_REPLACE(REPLACE(rating_count, 'K', '000'), '[^0-9]', '', 'g'), '') AS INT) AS rating_count,
    
    -- Strip non-numeric characters (like ₹)
    CAST(NULLIF(REGEXP_REPLACE(cost, '[^0-9]', '', 'g'), '') AS INT) AS cost,
    
    cuisine,
    lic_no,
    link,
    address,
    menu
FROM swiggy_restaurants;
