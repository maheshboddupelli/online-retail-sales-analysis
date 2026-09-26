USE online_retail;

LOAD DATA INFILE
'C:/ProgramData/MySQL/MySQL Server 26.7/Uploads/Online_Retail_sql_data.csv'
INTO TABLE online_retail_data
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\r\n'
IGNORE 1 ROWS
(
    @InvoiceNo,
    @StockCode,
    @Description,
    @Quantity,
    @InvoiceDate,
    @UnitPrice,
    @CustomerID,
    @Country,
    @Revenu,
    @year,
    @month,
    @month_year,
    @ORDER_ID,
    @Order_status
)
SET
    InvoiceNo = @InvoiceNo,
    StockCode = @StockCode,
    Description = @Description,
    Quantity = @Quantity,
    InvoiceDate = STR_TO_DATE(@InvoiceDate, '%d-%m-%Y %H:%i'),
    UnitPrice = @UnitPrice,
    CustomerID = @CustomerID,
    Country = @Country;

SELECT COUNT(*) AS total_rows
FROM online_retail_data;
SELECT 
    MIN(InvoiceNo) AS first_invoice,
    MAX(InvoiceNo) AS last_invoice,
    COUNT(DISTINCT InvoiceNo) AS unique_invoices,
    COUNT(DISTINCT CustomerID) AS unique_customers
FROM online_retail_data;

SELECT 
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue
FROM online_retail_data;

SELECT 
    SUM(Quantity) AS total_quantity
FROM online_retail_data;

SELECT 
    ROUND(SUM(Quantity * UnitPrice) / COUNT(DISTINCT InvoiceNo), 2) AS avg_order_value
FROM online_retail_data;

SELECT 
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 10;

SELECT 
    Description,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE Description IS NOT NULL
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;

SELECT 
    DATE_FORMAT(STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'), '%Y-%m') AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
GROUP BY month
ORDER BY month;

SELECT 
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;

SELECT 
    COUNT(*) AS cancelled_orders
FROM online_retail_data
WHERE InvoiceNo LIKE 'C%';

SELECT 
    Country,
    COUNT(DISTINCT CustomerID) AS customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE CustomerID IS NOT NULL
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT InvoiceNo) AS total_orders,
    COUNT(DISTINCT CustomerID) AS total_customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity,
    ROUND(AVG(UnitPrice), 2) AS avg_unit_price
FROM online_retail_data;


-- ============================================
-- ONLINE RETAIL SQL PROJECT - FINAL ANALYSIS
-- ============================================

-- 1. Overall KPIs
SELECT
    COUNT(*) AS total_records,
    COUNT(DISTINCT InvoiceNo) AS total_invoices,
    COUNT(DISTINCT CustomerID) AS total_customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS total_revenue,
    SUM(Quantity) AS total_quantity,
    ROUND(AVG(UnitPrice), 2) AS average_unit_price
FROM online_retail_data;


-- 2. Top 10 Customers
SELECT
    CustomerID,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE CustomerID IS NOT NULL
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 10;


-- 3. Top 10 Products
SELECT
    Description,
    SUM(Quantity) AS quantity_sold,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE Description IS NOT NULL
GROUP BY Description
ORDER BY revenue DESC
LIMIT 10;


-- 4. Top 10 Countries
SELECT
    Country,
    COUNT(DISTINCT InvoiceNo) AS orders,
    COUNT(DISTINCT CustomerID) AS customers,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
GROUP BY Country
ORDER BY revenue DESC
LIMIT 10;


-- 5. Cancelled Invoices
SELECT
    COUNT(DISTINCT InvoiceNo) AS cancelled_invoices
FROM online_retail_data
WHERE InvoiceNo LIKE 'C%';


-- 6. Monthly Sales
SELECT
    DATE_FORMAT(
        STR_TO_DATE(InvoiceDate, '%m/%d/%Y %H:%i'),
        '%Y-%m'
    ) AS month,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
GROUP BY month
ORDER BY month;


-- 7. Average Order Value
SELECT
    ROUND(
        SUM(Quantity * UnitPrice) /
        COUNT(DISTINCT InvoiceNo),
        2
    ) AS average_order_value
FROM online_retail_data
WHERE InvoiceNo NOT LIKE 'C%';


-- 8. Revenue by Country
SELECT
    Country,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
GROUP BY Country
ORDER BY revenue DESC;


-- 9. Products by Quantity
SELECT
    Description,
    SUM(Quantity) AS total_quantity
FROM online_retail_data
WHERE Description IS NOT NULL
GROUP BY Description
ORDER BY total_quantity DESC
LIMIT 10;


-- 10. Customer Revenue Segmentation
SELECT
    CustomerID,
    COUNT(DISTINCT InvoiceNo) AS orders,
    ROUND(SUM(Quantity * UnitPrice), 2) AS revenue
FROM online_retail_data
WHERE CustomerID IS NOT NULL
  AND InvoiceNo NOT LIKE 'C%'
GROUP BY CustomerID
ORDER BY revenue DESC
LIMIT 20;