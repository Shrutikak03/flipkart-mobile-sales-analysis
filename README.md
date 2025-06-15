# flipkart-mobile-sales-analysis  ( Interactive Dashboard creation using SQL )
Use the provided mobile sales data to create an interactive Power BI dashboard. The goal is to visualize brand performance, segment coverage, and customer preferences in the Indian market.
## Project Objective
The main objective of this project is to analyze Flipkart’s mobile sales data to:

- Understand brand-wise and model-wise performance.
- Evaluate the impact of price segments on sales.
- Determine customer preferences based on memory, storage, and color variants.
- Analyze discount strategies and their influence on total sales.
- Present data-driven insights to help improve product positioning and marketing strategies on the platform.
  
## Dataset Used
- <a href="https://github.com/Shrutikak03/flipkart-mobile-sales-analysis/blob/main/Flipkart_mobile_brands_scraped_data.csv">Dataset</a>

## Analytical Questions
Here are some key business questions answered in the project:

1. Which brands dominate Flipkart’s mobile phone market?
2. What are the sales trends across different price ranges (Low, Mid, Premium)?
3. What is the average discount percentage offered by each brand?
4. Which color and memory variants are most popular among buyers?
5. Which brand has the highest average rating?
6. How does product specification (storage/memory) vary across price segments?
7. Which brands offer products across all three price segments?
8. What are the top-selling models based on total sales?
9. What are the different price range segments for mobiles in India?
10. Which brand provides the most product offerings for the Indian Market?
11. What specifications are the most common that are offered by various brands?

## Data Cleaning Process for Flipkart Mobile Dataset
Initial Data Check (in SQL):

Imported the raw dataset into SQL.
- Identified missing values (NULLs) in important fields like brand, model, price, memory, storage, rating.
- Handling Missing Values:
- Removed rows with completely empty model or brand as they are critical identifiers.
- Replaced missing numeric fields (e.g., price, discount) with 0 or the average value using SQL COALESCE or AVG() as appropriate.
- Used SQL CASE or ISNULL for conditional replacements when necessary.

Standardizing Text Fields:
- Converted inconsistent text formatting (e.g., lowercase/uppercase brand names) using UPPER() or LOWER() functions.
- Trimmed unnecessary spaces using TRIM().

Creating Cleaned Table:
- Created a new clean table or temporary view with all cleaned and transformed values to ensure original data remained intact.

Verified Data Types:
- Ensured numeric fields like price, discount, storage were stored in proper formats (INT or FLOAT).
- Converted date or categorical fields to proper types for Power BI compatibility.

Export to Power BI:
- Once cleaned in SQL, data was imported into Power BI using Direct Query/Import.
- Further minor adjustments (like changing column data types) were handled in Power Query within Power BI.

## Project Insights
Based on the Power BI dashboard and analysis:

- Apple and Samsung are the top-performing brands in terms of total sales, especially in the premium price segment.
- Mid-range smartphones (₹10K–₹20K) hold the highest number of models and brands, showing strong competition in this price range.
- POCO and IQOO offer the highest average discounts (above 9%), likely to attract budget-conscious customers.
- The most common memory configurations are 4GB and 6GB, and most popular storage variants are 64GB and 128GB.
- Google Pixel and IQOO rank highest in average ratings (4.4+), indicating strong user satisfaction despite having fewer models.
- Samsung leads in model diversity and total memory offerings, reflecting a wide product range across segments.

## Dashboard View
![Flipkart Project_page-0001](https://github.com/user-attachments/assets/e06af9e1-09c2-41a2-ae53-6c18cd369e78)
![Flipkart Project_page-0002](https://github.com/user-attachments/assets/729bdf09-6009-4df6-93cd-d49bbb93d1a2)
![Flipkart Project_page-0003](https://github.com/user-attachments/assets/841f8956-6299-4a52-a18a-aadde01717f2)
![Flipkart Project_page-0004](https://github.com/user-attachments/assets/caf2b2fb-c92e-4861-9d8f-6b55075fd0f4)



