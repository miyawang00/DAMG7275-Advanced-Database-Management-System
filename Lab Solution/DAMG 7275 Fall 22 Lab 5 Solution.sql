
-- DAMG 7275 Lab 5c Solution (11 points)


-- Get all employees, their number of reports, and the names of the top five reports

IF OBJECT_ID('tempdb..#TempTable') IS NOT NULL
DROP TABLE #TempTable;

IF OBJECT_ID('tempdb..#TempTable2') IS NOT NULL
DROP TABLE #TempTable2
;

--DROP TABLE #TempTable;
--DROP TABLE #TempTable2;

WITH DirectReports
AS
	 (
		  -- Anchor member definition
		  SELECT
				ReportsTo
				,Department
				, EmployeeID
				, LastName
				, 0 AS [Level]
			   , CONVERT(NVARCHAR(20), NULL) AS MgrName
		  FROM OrgHierarchy
		  WHERE ReportsTo IS NULL
		  UNION ALL
		   --Recursive member definition
		  SELECT
			   E.ReportsTo
			   ,E.Department
			   , E.EmployeeID
			   , E.LastName
			   , [Level] + 1
			   , (SELECT LastName 
				   FROM OrgHierarchy Emp
				   WHERE Emp.EmployeeID = E.ReportsTo) AS MgrName
		  FROM OrgHierarchy E INNER JOIN DirectReports DR
			   ON E.ReportsTo = DR.EmployeeID
	 )
-- Statement that executes the CTE
SELECT EmployeeID AS EmpID
	  ,LastName AS EmpLName
	  ,Department
	  ,[Level]
	  ,ReportsTo AS MgrID
	  ,MgrName AS MgrLName

INTO #TempTable

FROM DirectReports
ORDER BY [Level], LastName;


CREATE TABLE #TempTable2
(EmpID INT,
 EmpLName varchar(20),
 Department varchar(20),
 [Level] INT,
 ManagerLName varchar(20),
 NumberOfReports INT,
 DirectReportNames varchar(1000),
 IndirectReportNames varchar(1000)) 

DECLARE EmpCur CURSOR
FOR
  select EmpID, [Level], EmpLName, Department
  from #TempTable;

--Declare holding vars
  declare @ID INT;
  declare @Level INT;
  declare @EmpLName varchar(20);
  declare @dept varchar(20);
  declare @Total INT;
  declare @mgr varchar(20);
 
  DECLARE @list varchar(1000) = '';
  DECLARE @list2 varchar(1000) = '';
 
 OPEN EmpCur;
 FETCH NEXT FROM EmpCur into @ID, @Level, @EmpLName, @dept;
 
 while @@FETCH_STATUS = 0
 BEGIN

   
WITH DirectReports
AS
	 (
		  -- Anchor member definition
		  SELECT
				ReportsTo
				,Department
				, EmployeeID
				, LastName
				, 0 AS [Level]
			   , CONVERT(NVARCHAR(20), NULL) AS MgrName
		  FROM OrgHierarchy
		  WHERE EmployeeID = @ID
		  UNION ALL
		   --Recursive member definition
		  SELECT
			   E.ReportsTo
			   ,E.Department
			   , E.EmployeeID
			   , E.LastName
			   , [Level] + 1
			   , (SELECT LastName 
				   FROM OrgHierarchy Emp
				   WHERE Emp.EmployeeID = E.ReportsTo) AS MgrName
		  FROM OrgHierarchy E INNER JOIN DirectReports DR
			   ON E.ReportsTo = DR.EmployeeID
	 )
-- Statement that executes the CTE

SELECT *
INTO #TempTable3 
FROM DirectReports;

-- Get the number of reports
SELECT @Total = COUNT(EmployeeID)-1 
FROM #TempTable3;


select @mgr = MgrLName
from #TempTable
where EmpID = @ID;


-- Get the names of the top five reports

SET @list = '';
SET @list2 = '';

SELECT @list = @list + ' ' + Lastname + ',' 
FROM  #TempTable3
WHERE EmployeeID <> @ID and Level = 1
ORDER BY Lastname;

IF LEN(@list) > 0
   SET @list = LEFT(@list, LEN(@list)-1);


SELECT @list2 = @list2 + ' ' + Lastname + ',' 
FROM  #TempTable3
WHERE EmployeeID <> @ID and Level > 1
ORDER BY Lastname;

IF LEN(@list2) > 0
   SET @list2 = LEFT(@list2, LEN(@list2)-1);


   INSERT INTO #TempTable2 (EmpID, EmpLName, Department, [Level], ManagerLName, 
                            NumberOfReports, DirectReportNames, IndirectReportNames)
   VALUES (@ID,  @EmpLName, @dept, @Level, @mgr, @Total, @list, @list2);
   
   DROP TABLE #TempTable3;

   FETCH NEXT FROM EmpCur into @ID, @Level, @EmpLName, @dept
END
CLOSE EmpCur
DEALLOCATE EmpCur;

SELECT EmpID,
       EmpLName,
       isnull(Department, '') Department,
       [Level],
       isnull(ManagerLName, '') ManagerLName,
       NumberOfReports,
       DirectReportNames,
       IndirectReportNames 
from #TempTable2
where NumberOfReports > 5
ORDER BY NumberOfReports desc;




