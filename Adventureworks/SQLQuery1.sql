--inner join
select soh.salesorderid, soh.orderdate, c.firstname, c.lastname
from saleslt.salesorderheader as soh
inner join saleslt.customer as c
    on soh.customerid = c.customerid;
--left join
select c.customerid, c.firstname, c.lastname, soh.salesorderid
from saleslt.customer as c
left join saleslt.salesorderheader as soh
    on c.customerid = soh.customerid;
--right join
select c.customerid, c.firstname, c.lastname, soh.salesorderid
from saleslt.customer as c
right join saleslt.salesorderheader as soh
    on c.customerid = soh.customerid;
--full outer join
select c.customerid, c.firstname, c.lastname, soh.salesorderid
from saleslt.customer as c
full outer join saleslt.salesorderheader as soh
    on c.customerid = soh.customerid;
--cross join
select c.customerid, c.firstname, c.lastname, soh.salesorderid
from saleslt.customer c
cross join saleslt.salesorderheader soh;

--1
select * from SalesLT.Customer

--2
create proc GetCustomerByID
@CustomerID int
as begin
	select FirstName, LastName, EmailAddress from SalesLT.Customer
end

GetCustomerByID 2
--3
create proc GetOrdersByDateRange
	@StartDate datetime,
	@EndDate datetime
as begin
	select * from SalesLT.SalesOrderHeader
	where OrderDate between @StartDate and @EndDate
end

GetOrdersByDateRange 2006, 2008

--4
create proc AddNewProduct
	@Name nvarchar(50),
	@ProductNumber nvarchar(25),
	@ListPrice MONEY,
	@StandardCost MONEY
as begin
	insert into SalesLT.Product
	(
	Name,
	ProductNumber,
	ListPrice,
	StandardCost,
	SellStartDate
	)
	VALUES
	(
	@Name,
	@ProductNumber,
	@ListPrice,
	@StandardCost,
	GETDATE()
	);
	end

	select * from SalesLT.Product
	AddNewProduct Armand, 100, 20, 20

	--5
CREATE PROCEDURE UpdateProductPrice
    @ProductID INT,
    @NewPrice MONEY
AS
BEGIN
    UPDATE SalesLT.Product
    SET ListPrice = @NewPrice
    WHERE ProductID = @ProductID;
END;

SELECT TOP 10 ProductID, Name, ListPrice
FROM SalesLT.Product;
EXEC UpdateProductPrice
    @ProductID = 713,
    @NewPrice = 59.99;

	--6
CREATE PROCEDURE DeleteCustomer
    @CustomerID INT
AS BEGIN
	if not exists (
		select 1 
		from SalesLT.SalesOrderHeader
		where CustomerID = @CustomerID
		)
		begin 
			delete from SalesLT.Customer
			where CustomerID = @CustomerID;

		print 'klient kustutatud';

	end
	else begin 
		Print 'kliendi tellimust ei saa kustutada';
	end
end;

--7
create proc GetOrderCountByCustomer
@CustomerID int,
@OrderCount int output
as begin
	Select @OrderCount = COUNT(*)
	from SalesLT.SalesOrderHeader
	where CustomerID = @CustomerID
end;


--8
create proc CheckProductPriceLevel
	@ProductID int
as begin
	declare @Price MONEY;

	select @Price = ListPrice
	from SalesLT.Product 
	where ProductID = @ProductID;

	IF @Price > 1000
	print 'Kallis';
	else if @Price between 100 and 1000
	print 'Keskmine';
	else
	print 'Odav';
	end;

	exec CheckProductPriceLevel 101
