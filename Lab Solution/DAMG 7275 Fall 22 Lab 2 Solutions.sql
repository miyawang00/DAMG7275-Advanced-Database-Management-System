
-- Lab 2 Solutions

-- Part 1

 /*
 Submit:
 1) SQL code
 2) Screenshots of the two configured data synch jobs
 */


/* In Source */


create view vCounsel
WITH SCHEMABINDING
AS SELECT c.ClientID, c.LastName, c.FirstName, Phone,
          a.CounselDate, CounselID, ModifiedDate
   FROM dbo.Client c
   JOIN dbo.Counseling a
   ON c.ClientID = a.ClientID;

CREATE UNIQUE CLUSTERED INDEX vOI   
   ON vCounsel (CounselID);
  
  DROP PROCEDURE [dp];
 
 EXEC dp;

CREATE PROC dp
AS
BEGIN

MERGE Destaa.dbo.CounselingReport r
USING vCounsel s
ON s.CounselID = r.CounselID
WHEN MATCHED AND s.ModifiedDate > r.ModifiedDate THEN
		update set CounselDate = s.CounselDate, ModifiedDate = s.ModifiedDate
WHEN NOT MATCHED BY SOURCE THEN
		delete
WHEN NOT MATCHED THEN
		INSERT (CounselID, LastName, FirstName, Phone, CounselDate, ModifiedDate)
		VALUES (s.CounselID, s.LastName, s.FirstName, Phone, s.CounselDate, s.ModifiedDate)
OUTPUT
  $action
  ,ISNULL(Deleted.CounselID, Inserted.CounselID)
  ,Deleted.CounselDate
  ,Inserted.CounselDate
INTO Destaa.dbo.DateAudit
 ([Action]
  ,CounselID
  ,OldDate
  ,NewDate);

END



-- Part 2

-- Add source database and schema to code

/* In Source */

/* First Trigger */
drop trigger trPipelineOrder
drop trigger trPipelineItem





create trigger trPipelineOrder
on SaleOrder
after insert, update, delete
as
begin

declare @d int, @i int, @a varchar(10);
select @d = count(1) from deleted;
select @i = count(1) from inserted;

if @d > 0 and @i = 0
begin
   delete Destaa.dbo.SaleOrderReport
   from Destaa.dbo.SaleOrderReport s
   join deleted d
   on s.OrderID = d.OrderID;

   set @a = 'delete';
end

if @d = 0 and @i > 0
begin
   insert Destaa.dbo.SaleOrderReport (OrderID, OrderDate, CustomerID, Modified)
   select OrderID, OrderDate, CustomerID, Modified from inserted;
   set @a = 'insert';
end

if @d > 0 and @i > 0
begin
   update Destaa.dbo.SaleOrderReport
   set OrderID = i.OrderID, OrderDate= i.OrderDate,
       CustomerID = i.CustomerID, Modified = i.Modified
   from Destaa.dbo.SaleOrderReport s
   join inserted i
   on s.OrderID = i.OrderID;
   set @a = 'update';
end

insert Destaa.dbo.AuditSaleOrder ([Action], OrderID, OldOrderDate, NewOrderDate,
                       OldCustomerID, NewCustomerID)
select @a
  ,ISNULL(d.orderid, i.orderid)
  ,d.orderdate
  ,i.orderdate
  ,d.CustomerID
  ,i.CustomerID
from inserted i
full join deleted d
on i.OrderID = d.OrderID

end


/* Second Trigger */

alter trigger trPipelineItem
on OrderItem
after insert, update, delete
as
begin

declare @d int, @i int, @a varchar(10);
select @d = count(1) from deleted;
select @i = count(1) from inserted;

if @d > 0 and @i = 0
begin
   delete Destaa.dbo.OrderItemReport
   from Destaa.dbo.OrderItemReport s
   join deleted d
   on s.OrderID = d.OrderID and s.ItemID = d.ItemID;

   set @a = 'delete';
end


if @d = 0 and @i > 0
begin
   insert Destaa.dbo.OrderItemReport (OrderID, ItemID, Quantity, UnitPrice)
   select OrderID, ItemID, Quantity, UnitPrice from inserted;
   set @a = 'insert';
end

if @d > 0 and @i > 0
begin
   update Destaa.dbo.OrderItemReport
   set OrderID = i.OrderID, ItemID= i.ItemID,
       Quantity = i.Quantity, UnitPrice = i.UnitPrice
   from Destaa.dbo.OrderItemReport s
   join inserted i
   on s.OrderID = i.OrderID and s.ItemID = i.ItemID;
   set @a = 'update';
end

insert Destaa.dbo.AuditOrderItem ([Action], OrderID, OldItemID, NewItemID, OldQuantity,
                       NewQuantity, OldUnitPrice, NewUnitPrice)
select @a
  ,ISNULL(d.orderid, i.orderid)
  ,d.ItemID
  ,i.ItemID
  ,d.Quantity
  ,i.Quantity
  ,d.UnitPrice
  ,i.UnitPrice
from inserted i
full join deleted d
on i.OrderID = d.OrderID and i.ItemID = d.ItemID

end

