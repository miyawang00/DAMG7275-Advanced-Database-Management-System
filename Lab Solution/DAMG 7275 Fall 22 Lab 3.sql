
--===================== DAMG 7275 Lab 3


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


-- Question 2 (3 points)

/*
  Write a SQL query using "FOR JSON PATH" and AdventureWorks to 
  get the customers and their orders. Return the data
  in the format described below. Return data only for the customer id's
  in the range between 30000 and 30011. OrderValue is the TotalDue column
  in SalesOrderHeader.
*/

/*
{"CustomerID":30000,
 "Orders":[{"SalesOrderID":46645,"OrderValue":114198},
           {"SalesOrderID":51124,"OrderValue":87230},
		   {"SalesOrderID":55275,"OrderValue":72873},
		   {"SalesOrderID":67295,"OrderValue":70791},
		   {"SalesOrderID":47696,"OrderValue":68210},
		   {"SalesOrderID":49848,"OrderValue":66757},
		   {"SalesOrderID":61196,"OrderValue":31615},
		   {"SalesOrderID":48744,"OrderValue":21404}]},
{"CustomerID":30001,
 "Orders":[{"SalesOrderID":61176,"OrderValue":1631},
           {"SalesOrderID":55237,"OrderValue":82}]},
{"CustomerID":30002,
 "Orders":[{"SalesOrderID":51866,"OrderValue":1100},
           {"SalesOrderID":63274,"OrderValue":403},
		   {"SalesOrderID":69523,"OrderValue":403},
		   {"SalesOrderID":57117,"OrderValue":229}]}

 ***** There is more data which is not displayed here *****
*/


/*
  Import the generated data into a Cosmos DB SQL API database.
*/


/*
  Write a SQL query for the Cosmos DB SQL API to get
  the number of orders each customer has, a customer's total purchase,
  and a customer's average order value.
*/


-- Question 3 (3 points)

/*
  Write a SQL query using "FOR JSON PATH" and AdventureWorks to 
  get the top 3 colors in a sales territory and a color's
  total sales dollar amount. Return the data in the format 
  displayed below. TotalSales$ is the total sales of a color. 
  
  The top 3 colors have the 3 highest total sales in a territory.
  If there is a tie, the tie needs to be retrieved.

  Exclude the products which didn't have a color specified.

  Submit the SQL code.
*/


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


/*
  Import the generated data into a Cosmos DB SQL API database.
  Submit a screenshot of importing results.
*/


/*
  Write a SQL query for the Cosmos DB SQL API to get the 
  grand totals of Total sales regardless of the sales territory
  for each color. Submit the code and a screenshot of the
  executing results.
*/


