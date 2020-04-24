-- 01. Use CHOOSE() and MONTH() to get the season in which each order was shipped from the Orders table. You should select the order ID, shipped date, and then the season aliased as ShippedSeason. You can copy and paste the below into your query.
-- 'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter'
-- Be careful to filter out any NULL shipped dates.

SELECT OrderID, ShippedDate, CHOOSE(MONTH(ShippedDate),'Winter', 'Winter', 'Spring', 'Spring', 'Spring', 'Summer', 'Summer', 'Summer', 'Autumn', 'Autumn', 'Autumn', 'Winter') AS ShippedSeason
FROM Orders
WHERE ShippedDate IS NOT NULL;


--02. Using the Suppliers table, select the company name and use a simple IIF expression to display 'outdated' if a company has a fax number, or 'modern' if it doesn't. Alias the result of the IIF expression to Status.

SELECT CompanyName,
IIF(Fax IS NOT NULL, 'outdated', 'modern' ) AS Status
FROM Suppliers;


--03. Select from the Customers, Orders, and Order Details tables. Note that you need to use [Order Details] since the table name contains whitespace.
-- Use GROUP BY and ROLLUP() to get the total quantity ordered by all countries, while maintaining the total per country in your result set.
-- Your first column should be the country, and the second column the total quantity ordered by that country, aliased as TotalQuantity.

SELECT o.ShipCountry AS Country, COUNT(od.Quantity) AS 'TotalQuantity'
FROM dbo.Orders as o
JOIN dbo.[Order Details] as od
ON o.OrderID = od.OrderID
GROUP BY ROLLUP(o.ShipCountry)
ORDER BY o.ShipCountry ASC;

-- 04. From the Customers table, use GROUP BY to select the country, contact title, and count of that contact title aliased as Count, grouped by country and contact title (in that order).
-- Then use CASE WHEN, GROUPING_ID(), and ROLLUP() to add a column called Legend, which shows one of two things:
-- When the GROUPING_ID is 0, show '' (i.e., nothing)
-- When the GROUPING_ID is 1, show Subtotal for << Country >>'
-- Do not use ORDER BY to order your results.

SELECT Country, ContactTitle, COUNT(ContactTitle) AS Count, CASE
    WHEN GROUPING_ID(Country, ContactTitle) = 0 THEN ''
    WHEN GROUPING_ID(Country, ContactTitle) = 1 THEN ('Subtotal for ' + Country)
    END AS 'Legend'
FROM dbo.Customers
GROUP BY ROLLUP(Country, ContactTitle);

-- 05. Convert the following query to be pivoted, using PIVOT().
-- SELECT CategoryID, AVG(UnitPrice)
-- FROM Products
-- GROUP BY CategoryID;
SELECT CategoryID, AVG(UnitPrice)
FROM Products
GROUP BY CategoryID;

SELECT 'Average Unit Price' AS 'Per Category', [1], [2], [3], [4], [5], [6], [7], [8]
FROM (SELECT CategoryID, UnitPrice FROM Products) AS SourceTable
PIVOT
(
AVG(UnitPrice) 
FOR CategoryID IN ([1], [2], [3], [4], [5], [6], [7], [8])
) AS PivotTable;

--06. Insert into the Region table the region ID 5 and the description 'Space'.
-- Then, in a second query, select the newly inserted data from the table using a WHERE clause.

INSERT INTO dbo.Region
VALUES ('5','Space');

SELECT * FROM REGION
WHERE RegionID = '5';

-- --07. Update the region descriptions in the Region table to be all uppercase, using SET and UPPER().
-- Next, select all data from the table to view your updates.

UPDATE Region
SET RegionDescription = UPPER(RegionDescription);

SELECT * FROM Region

-- 08. Write a script that safely checks whether a certain region exists:
-- Declare a custom region @region called 'Space', of type NVARCHAR(25).
-- Use IF NOT EXISTS, ELSE, and BEGIN..END to:
-- throw an error with THROW 50001, 'Error!', 0 if no record whose RegionDescription matches @region exists.
-- select all columns for that region from the Region table if the record does exist.

DECLARE @region NVARCHAR(25)='Space'

IF NOT EXISTS (Select * From Region WHERE RegionDescription=@region)
BEGIN
    THROW 50001,'error!',0;
    END
ELSE
BEGIN
(SELECT * from Region Where RegionDescription=@region)
END