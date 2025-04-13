USE project;

-- Display All recodes in Data set

SELECT TOP(5) * FROM Sales_Analysis 
ORDER BY sale_date ASC;

-- Data Cleaning


ALTER TABLE Sales_Analysis
ALTER COLUMN cogs DECIMAL(10, 2);


ALTER TABLE Sales_Analysis
ALTER COLUMN price_per_unit DECIMAL(10, 2);


ALTER TABLE Sales_Analysis
ALTER COLUMN total_sale DECIMAL(10, 2);


ALTER TABLE Sales_Analysis
ALTER COLUMN sale_time TIME(0);


SELECT * FROM Sales_Analysis
WHERE transactions_id IS NULL
      OR sale_date IS NULL
      OR sale_time IS NULL
	  OR customer_id IS NULL
	  OR gender IS NULL
	  OR age IS NULL
	  OR category IS NULL
	  OR quantity IS NULL
	  OR price_per_unit IS NULL
	  OR cogs IS NULL
	  OR total_sale IS NULL;
	  


EXEC sp_rename 'Sales_Analysis.quantiy',  'quantity', 'COLUMN';


-- Data Analysis

SELECT COUNT(*) AS 'Total Transactions' FROM Sales_Analysis;


SELECT DISTINCT category AS 'Category' FROM Sales_Analysis;


SELECT category AS 'Category', gender AS 'Gender', COUNT(transactions_id) AS 'Transactions' FROM Sales_Analysis
GROUP BY category, gender
ORDER BY COUNT(transactions_id) DESC;


SELECT category AS 'Category' ,COUNT(quantity) AS 'Quantity', SUM(total_sale) AS 'Totale Sale' FROM Sales_Analysis
GROUP BY category
ORDER BY COUNT(quantity);


SELECT YEAR(sale_date) AS 'Year', COUNT(transactions_id) AS 'Transactions' FROM Sales_Analysis
GROUP BY YEAR(sale_date)
ORDER BY YEAR(sale_date);


SELECT COUNT(quantity) AS 'Total Quantity', SUM(total_sale) AS 'Total Sale' FROM Sales_Analysis;


SELECT COUNT(DISTINCT customer_id) AS 'Total Customers' FROM Sales_Analysis;


SELECT YEAR(sale_date) AS 'Year', SUM(total_sale) AS 'Total Sales' FROM Sales_Analysis
GROUP BY YEAR(sale_date)
ORDER BY YEAR(sale_date) ASC;


SELECT MONTH(sale_date) AS 'Month',
COALESCE(SUM(CASE WHEN YEAR(sale_date) = 2022 THEN total_sale END), 0) AS 'Total Sales 2022',
COALESCE(SUM(CASE WHEN YEAR(sale_date) = 2023 THEN total_sale END), 0) AS 'Total Sales 2023'
FROM Sales_Analysis
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY MONTH(sale_date)
ORDER BY MONTH(sale_date);


SELECT 
MONTH(sale_date) AS 'Month',
COALESCE(CAST(AVG(CASE WHEN YEAR(sale_date) = 2022 THEN total_sale END) AS DECIMAL(10, 2)), 0.00) AS 'Avg Sales 2022',
COALESCE(CAST(AVG(CASE WHEN YEAR(sale_date) = 2023 THEN total_sale END) AS DECIMAL(10, 2)), 0.00) AS 'Avg Sales 2023'
FROM Sales_Analysis
WHERE YEAR(sale_date) IN (2022, 2023)
GROUP BY MONTH(sale_date)
ORDER BY MONTH(sale_date);


SELECT  
CASE 
	WHEN Age BETWEEN 18 AND 23 THEN '18-23' 
	WHEN Age BETWEEN 24 AND 29 THEN '24-29' 
	WHEN Age BETWEEN 30 AND 35 THEN '30-35' 
	WHEN Age BETWEEN 36 AND 41 THEN '36-41' 
	WHEN Age BETWEEN 42 AND 47 THEN '42-47' 
	WHEN Age BETWEEN 48 AND 60 THEN '48-60' 
ELSE '60+' 
END AS 'Age group', SUM(quantity) AS 'Quantity', SUM(total_sale) AS 'Total Sales' 
FROM Sales_Analysis 
GROUP BY 
CASE 
	WHEN Age BETWEEN 18 AND 23 THEN '18-23' 
	WHEN Age BETWEEN 24 AND 29 THEN '24-29' 
	WHEN Age BETWEEN 30 AND 35 THEN '30-35' 
	WHEN Age BETWEEN 36 AND 41 THEN '36-41' 
	WHEN Age BETWEEN 42 AND 47 THEN '42-47' 
	WHEN Age BETWEEN 48 AND 60 THEN '48-60' 
ELSE '60+' 
END 
ORDER BY 'Age group';


SELECT 
  CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 18 AND 21 THEN 'Evening'
    ELSE 'Night'
  END AS 'Time Period', COUNT(transactions_id) AS 'Transactions'
FROM Sales_Analysis
GROUP BY
CASE 
    WHEN DATEPART(HOUR, sale_time) < 12 THEN 'Morning'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    WHEN DATEPART(HOUR, sale_time) BETWEEN 18 AND 21 THEN 'Evening'
    ELSE 'Night'
  END
ORDER BY 'Transactions' DESC;