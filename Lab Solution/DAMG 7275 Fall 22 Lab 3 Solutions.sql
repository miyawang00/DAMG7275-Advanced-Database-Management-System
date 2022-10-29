
-- DAMG 7275 Fall 22 Lab 3 Solutions

-- Question 1 (2 points)

-- Part 1
-- Question 1 (2 points)

/*
  Write a SQL query using "FOR JSON PATH" and AdventureWorks to 
  get the salespersons in each sales territory. Return the data
  in the format described below.
*/

/*
{"TerritoryID":1,
 "SalesPeople":[{"SalesPersonID":274},{"SalesPersonID":276},{"SalesPersonID":280},
                {"SalesPersonID":281},{"SalesPersonID":283},{"SalesPersonID":284}]},
{"TerritoryID":2,
 "SalesPeople":[{"SalesPersonID":274},{"SalesPersonID":275},{"SalesPersonID":277}]}
 ***** There is more data which is not displayed here *****
*/


/*
  Import the generated data into the Cosmos DB SQL API database.
*/


/*
  Write a SQL query for the Cosmos DB SQL API to get
  the total number of salespersons in each saes territory.
*/

SELECT TerritoryID,
    (   SELECT DISTINCT SalesPersonID
        FROM Sales.SalesOrderHeader sh 
		WHERE sh.TerritoryID = t.TerritoryID AND SalesPersonID IS NOT NULL
		ORDER BY SalesPersonID
        FOR JSON PATH
    ) AS SalesPeople
FROM Sales.SalesTerritory t
ORDER BY TerritoryID
FOR JSON PATH, WITHOUT_ARRAY_WRAPPER;


-- Part 2

/*
  Import the generated data into the Cosmos DB SQL API database.
*/


-- Part 3

SELECT  c.TerritoryID, COUNT(p.SalesPersonID) AS Total
FROM c4 c join p in c.SalesPeople
GROUP BY c.TerritoryID



-- Question 2 (3 points)

-- Part 1

SELECT CustomerID,
    (
        SELECT SalesOrderID, cast(round(TotalDue, 0) as int) OrderValue
        FROM Sales.SalesOrderHeader sh WHERE sh.CustomerID = c.CustomerID
		order by TotalDue desc
        FOR JSON PATH
    ) AS Orders
FROM Sales.Customer c

where c.CustomerID between 30000 and 30011

FOR JSON PATH--, WITHOUT_ARRAY_WRAPPER;


-- Part 2

/*
  Import the generated data into a Cosmos DB SQL API database.
*/


-- Part 3

SELECT c.CustomerID, count(o.SalesOrderID) OrderCount, 
       sum(o.OrderValue) TotalPurchase , avg(o.OrderValue) AvgOrderValue
FROM c JOIN o in c.Orders 
GROUP BY c.CustomerID



-- Question 3 (3 points)

-- Part 1
/*
[{"TerritoryID":1,
  "Top3Colors":[{"Color":"Black","TotalSales$":5918773},
                {"Color":"Silver","TotalSales$":3817329},
				{"Color":"Yellow","TotalSales$":2324072}]},
 {"TerritoryID":2,
  "Top3Colors":[{"Color":"Black","TotalSales$":2505403},
                {"Color":"Red","TotalSales$":1881110},
				{"Color":"Yellow","TotalSales$":1215118}]}
 ***** There is more data which is not displayed here *****
*/


with temp as (
select sh.TerritoryID, p.Color, 
	   cast(sum(UnitPrice*OrderQty) as int) TotalSales$,
	   rank() over (partition by sh.TerritoryID order by sum(UnitPrice*OrderQty) desc) Ranking
from Sales.SalesOrderHeader sh
join Sales.SalesOrderDetail sd
on sh.SalesOrderID = sd.SalesOrderID

join Production.Product p
on p.ProductID = sd.ProductID
where Color is not null

group by TerritoryID, p.Color)
SELECT distinct TerritoryID,
    (   SELECT Color, TotalSales$
        FROM temp 
		WHERE TerritoryID = t.TerritoryID and Ranking <= 3
		ORDER BY TotalSales$ desc
        FOR JSON PATH
    ) AS Top3Colors
FROM temp t
ORDER BY TerritoryID
FOR JSON PATH;


-- Part 2

/*
  Import the generated data into a Cosmos DB SQL API database.
  Submit a screenshot of importing results.
*/


-- Part 3

SELECT s.Color,  
       sum(s.TotalProductQuantity) GrandProductQuantity
FROM c JOIN s in c.Top3Products 
GROUP BY s.Color


