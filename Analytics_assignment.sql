-- 1. What % of sales result in a return?

SELECT 
    COUNT(CASE
        WHEN r.OrderID IS NOT NULL THEN 1
        ELSE NULL
    END) AS ReturnCount,
    COUNT(DISTINCT s.OrderID) AS SalesCount,
    ROUND(COUNT(CASE
                WHEN r.OrderID IS NOT NULL THEN 1
                ELSE NULL
            END) * 100 / COUNT(DISTINCT s.OrderID),
            2) AS ReturnPercent
FROM
    sales s
        LEFT JOIN
    returns r ON r.OrderID = s.OrderID;



-- 2. What % of returns are full returns?

-- Assuming "full returns" means where ReturnSales equals the original Sales amount:

SELECT 
    COUNT(CASE
        WHEN r.ReturnSales = s.Sales THEN 1
        ELSE NULL
    END) AS FullReturn,
    COUNT(*) AS TotalReturn,
    ROUND(COUNT(CASE
                WHEN r.ReturnSales = s.Sales THEN 1
                ELSE NULL
            END) * 100 / COUNT(*),
            2) AS FullReturnPercent
FROM
    returns r
        JOIN
    sales s ON r.orderID = s.OrderID;



-- 3. What is the average return % amount (return % of original sale)?

SELECT 
    ROUND(AVG(r.ReturnSales * 100 / s.Sales), 2) AS AverageReturnPercentage
FROM
    returns r
        JOIN
    sales s ON s.OrderID = r.OrderID;
    
    

    -- 4. What % of returns occur within 7 days of the original sale?
    
    -- Assuming TransactionDate and ReturnDate are date or datetime fields:
  
SELECT 
    ROUND(COUNT(CASE
                WHEN DATEDIFF(r.ReturnDate, s.TransactionDate) <= 7 THEN 1
            END) * 100.0 / COUNT(*),
            2) AS ReturnsWithin7DaysPercentage
FROM
    Returns r
        JOIN
    Sales s ON s.OrderID = r.OrderID;

    
    
-- 5. What is the average number of days for a return to occur?
SELECT 
    ROUND(AVG(DATEDIFF(r.ReturnDate, s.TransactionDate)),
            2) AS AvgReturnDays
FROM
    returns r
        JOIN
    sales s ON s.OrderId = r.OrderID;



-- 6. Using this data set, how would you approach and answer the question, who is our most valuable customer?

/*
This question is more complex and would typically involve aggregating sales data and possibly returns data by CustomerID, 
considering factors like total sales amount, frequency of purchases, and possibly net sales after returns.
*/

SELECT 
    s.CustomerID,
    ROUND(SUM(s.sales), 2) AS TotalSalesAmount,
    COUNT(DISTINCT s.OrderID) AS TotalOrders,
    COUNT(CASE
        WHEN r.OrderID IS NOT NULL THEN 1
        ELSE NULL
    END) AS TotalReturns,
    ROUND(SUM(s.sales - IFNULL(r.ReturnSales, 0)),
            2) AS NetSales
FROM
    sales s
        LEFT JOIN
    returns r ON r.CustomerID = s.CustomerID
GROUP BY s.CustomerID
ORDER BY NetSales DESC
LIMIT 1;