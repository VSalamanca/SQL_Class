--01. Use a subquery to get the product name and unit price of products from the Products table which have a unit price greater than the average unit price from the Order Details table.
-- Note that you need to use [Order Details] since the table name contains whitespace.
SELECT DISTINCT P.ProductName, P.UnitPrice
FROM
(SELECT p.ProductName, p.UnitPrice
FROM dbo.Products as p
JOIN dbo.[Order Details] as od
ON od.UnitPrice = p.Unitprice) AS P
WHERE P.UnitPrice > (SELECT AVG(UnitPrice) FROM dbo.[Order Details])
ORDER BY P.ProductName;


--02. Select from the Employees and Orders tables. Use a subquery to get the first name and employee ID for employees who were associated with orders which shipped from the USA.
SELECT DISTINCT eo.FirstName, eo.EmployeeID
FROM(SELECT e.FirstName, o.EmployeeID, o.ShipCountry
FROM dbo.Employees as e
JOIN dbo.Orders as o
ON e.EmployeeID = o.EmployeeID
WHERE o.ShipCountry = 'USA') AS eo;


-- 03. Use the # to create a new temporary table called ProductNames which has one field called ProductName (a VARCHAR of max length 40).
-- Insert into this table the names of every product from the Products table. Note that there are two syntaxes for the INSERT INTO statement. Use the syntax that does not specify the column names since the table only has one field.
-- Select all columns from the ProductNames table you created.
CREATE TABLE #ProductNames
(ProductName VARCHAR(40))

INSERT INTO #ProductNames
SELECT ProductName
FROM Products

SELECT * FROM #ProductNames;