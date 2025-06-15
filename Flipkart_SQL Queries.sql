--Create a new table
CREATE TABLE flipkart_mobile_brands_scraped(
brand TEXT,
    model TEXT,
    color TEXT,
    memory TEXT,
    storage TEXT,
    rating FLOAT,
    selling_price FLOAT,
    original_price FLOAT); 

SELECT * FROM flipkart_mobile_brands_scraped

--Identify rows with missing critical data
SELECT * FROM flipkart_mobile_brands_scraped
WHERE model IS NULL
   OR color IS NULL
   OR memory IS NULL
   OR storage IS NULL
   OR selling_price IS NULL;

--Replace nulls in original_price with selling_price
UPDATE flipkart_mobile_brands_scraped
SET original_price = selling_price
WHERE original_price IS NULL;

--Price Range Segments for Mobiles in India
SELECT 
  CASE 
    WHEN selling_price < 10000 THEN 'Low Range (< ₹10K)'
    WHEN selling_price BETWEEN 10000 AND 20000 THEN 'Mid Range (₹10K - ₹20K)'
    ELSE 'Premium (> ₹20K)'
  END AS price_segment,
  COUNT(*) AS mobile_count
FROM flipkart_mobile_brands_scraped
GROUP BY price_segment
ORDER BY mobile_count DESC;

--Which Brand Has the Most Product Offerings?
SELECT brand, COUNT(*) AS product_count
FROM flipkart_mobile_brands_scraped
GROUP BY brand
ORDER BY product_count DESC;

--Which Brand Covers All Segments (Low, Mid, Premium)?
SELECT brand
FROM (
  SELECT brand,
    COUNT(DISTINCT CASE WHEN selling_price < 10000 THEN 'Low' END) AS low,
    COUNT(DISTINCT CASE WHEN selling_price BETWEEN 10000 AND 20000 THEN 'Mid' END) AS mid,
    COUNT(DISTINCT CASE WHEN selling_price > 20000 THEN 'Premium' END) AS premium
  FROM flipkart_mobile_brands_scraped
  GROUP BY brand
) AS price_range_counts
WHERE low > 0 AND mid > 0 AND premium > 0;

--Most Common Specifications Offered
--Most Common Memory Configurations
SELECT memory, COUNT(*) AS count
FROM flipkart_mobile_brands_scraped
GROUP BY memory
ORDER BY count DESC;

--Most Common Storage Configurations
SELECT storage, COUNT(*) AS count
FROM flipkart_mobile_brands_scraped
GROUP BY storage
ORDER BY count DESC;

--Most Common Color Options
SELECT color, COUNT(*) AS count
FROM flipkart_mobile_brands_scraped
GROUP BY color
ORDER BY count DESC
LIMIT 10;

--Average Rating & Price per Brand
SELECT 
  brand,
  COUNT(*) AS total_models,
  ROUND(AVG(rating)::numeric, 2) AS avg_rating,
  ROUND(AVG(selling_price)::numeric, 2) AS avg_price
FROM flipkart_mobile_brands_scraped
GROUP BY brand
ORDER BY total_models DESC;

--count duplicate rows
SELECT SUM(duplicate_count - 1) AS total_duplicates
FROM (
  SELECT COUNT(*) AS duplicate_count
  FROM flipkart_mobile_brands_scraped
  GROUP BY brand, model, color, memory, storage, rating, selling_price, original_price
  HAVING COUNT(*) > 1
) AS sub;

--remove duplicate rows
WITH ranked_rows AS (
  SELECT ctid,
         ROW_NUMBER() OVER (
           PARTITION BY brand, model, color, memory, storage, rating, selling_price, original_price
           ORDER BY ctid
         ) AS rn
  FROM flipkart_mobile_brands_scraped
)
DELETE FROM flipkart_mobile_brands_scraped
WHERE ctid IN (
  SELECT ctid FROM ranked_rows WHERE rn > 1
);

-- Set color as 'Unknown' if null
UPDATE flipkart_mobile_brands_scraped
SET color = 'Unknown'
WHERE color IS NULL;

-- Remove rows with NULL model or brand (critical info missing)
DELETE FROM flipkart_mobile_brands_scraped
WHERE brand IS NULL OR model IS NULL;

-- Remove rows with no price info
DELETE FROM flipkart_mobile_brands_scraped
WHERE selling_price IS NULL;

-- Add new integer columns
ALTER TABLE flipkart_mobile_brands_scraped 
ADD COLUMN memory_gb INT,
ADD COLUMN storage_gb INT;

-- Fill new column
UPDATE flipkart_mobile_brands_scraped
SET memory_gb = CASE 
    WHEN memory ILIKE '%GB%' THEN CAST(REGEXP_REPLACE(memory, '[^0-9]', '', 'g') AS INTEGER)
    WHEN memory ILIKE '%MB%' THEN CAST(REGEXP_REPLACE(memory, '[^0-9]', '', 'g') AS INTEGER)
    ELSE NULL
END,
storage_gb = CASE 
    WHEN storage ILIKE '%GB%' THEN CAST(REGEXP_REPLACE(storage, '[^0-9]', '', 'g') AS INTEGER)
    WHEN storage ILIKE '%MB%' THEN CAST(REGEXP_REPLACE(storage, '[^0-9]', '', 'g') AS INTEGER)
    ELSE NULL
END
WHERE memory IS NOT NULL OR storage IS NOT NULL;


SELECT * FROM flipkart_mobile_brands_scraped

-- Discount Amount
ALTER TABLE flipkart_mobile_brands_scraped ADD COLUMN discount_amount INTEGER;
UPDATE flipkart_mobile_brands_scraped
SET discount_amount = original_price - selling_price;

-- Discount %
ALTER TABLE flipkart_mobile_brands_scraped ADD COLUMN discount_percent NUMERIC(5,2);
UPDATE flipkart_mobile_brands_scraped
SET discount_percent = ROUND(
    ((original_price - selling_price) * 100.0 / NULLIF(original_price, 0))::NUMERIC, 2
)
WHERE original_price IS NOT NULL AND selling_price IS NOT NULL;

