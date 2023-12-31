/*
Instructions for ChatGPT:

Be sure to analyze the formulas deeply, looking at the elements in the WHERE clauses, subqueries, nested queries, calculations, variables, parameters referenced.

For example:

SELECT 
    CAST((SELECT COUNT(DISTINCT ProductKey) FROM dbo.FactSupportTickets) AS FLOAT) / 
    CAST((SELECT COUNT(DISTINCT ProductKey) FROM dbo.FactProductInventory WHERE MovementDate = @SnapshotDate) AS FLOAT) AS SupportTicketKPI

The formula above has elements: FactSupportTickets.ProductKey, FactProductInventory.ProductKey, MovementDate, @SnapshotDate
Be sure you can reconstruct the formula if needed.

Remeber too how each element affects the formula: if the element has a "directly proportional" or "inverse reciprocal" relationship in the formula if possible.
If an element looks like an ID field (contains Key or ID), the relationship of the KPI status to the element is "references".

Note that the data source is AdventureWorksDW unless otherwise stated.
*/

-- Support Manager KPI Status
DECLARE @SnapshotDate DATETIME = '20191201';  -- set this to the date for which you want to check the inventory

SELECT 
    CAST((SELECT COUNT(DISTINCT ProductKey) FROM dbo.FactSupportTickets) AS FLOAT) / 
    CAST((SELECT COUNT(DISTINCT ProductKey) FROM dbo.FactProductInventory WHERE MovementDate = @SnapshotDate) AS FLOAT) AS SupportTicketKPI


-- CFO KPI Status
SELECT 
    SUM(SalesAmount - TotalCost) / SUM(SalesAmount) AS ProfitMarginKPI
FROM 
    dbo.FactInternetSales
WHERE 
    YEAR(OrderDate) = 2019;


-- Sales Manager KPI Status
DECLARE @SalesGoal MONEY = 1000000;  -- set according to your company's goals

SELECT 
    SUM(SalesAmount) / @SalesGoal AS SalesKPIStatus
FROM 
    dbo.FactInternetSales
WHERE 
    YEAR(OrderDate) = 2019;


--Inventory Manager KPI Status.
DECLARE @SnapshotDate DATETIME = '20191201';  -- set this to the date for which you want to check the inventory

SELECT 
    CAST(SUM(CASE WHEN UnitsBalance > ReorderPoint THEN 1 ELSE 0 END) AS FLOAT) / COUNT(*) AS InventoryKPIStatus
FROM 
    dbo.FactProductInventory
WHERE 
    MovementDate = @SnapshotDate;


-- Marketing Manager KPI Status
DECLARE @CustomerTarget INT = 1000;  -- set according to your company's goals

SELECT 
    CAST(COUNT(*) AS FLOAT) / @CustomerTarget AS NewCustomerKPIStatus
FROM 
    (SELECT CustomerKey, MIN(OrderDate) as FirstPurchaseDate
     FROM dbo.FactInternetSales
     GROUP BY CustomerKey) as CustomerPurchases
WHERE 
    YEAR(FirstPurchaseDate) = 2019;


-- Warranty Manager KPI Status
--This KPI status is sourced from a custom system for the Warranty service department.
SELECT 
    SUM(ItemSalesAmount - WarrantyCharges) / SUM(ItemSalesAmount) AS ProfitMarginKPI
FROM 
    dbo.WarrantyFacts

--HR Retention KPI Status
--This KPI is used by the HR COTS system.

def hr_retention_kpi(department:str, month_count:float, last_month_count:float)->float
	"""KPI for HR manager.

	USAGE:
	------
	"""
	return None if not month_count else (month_count-last_month_count)/last_month_count 