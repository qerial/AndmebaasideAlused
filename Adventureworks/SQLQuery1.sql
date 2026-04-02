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
,
	IF @Price > 1000
	print 'Kallis';
	else if @Price between 100 and 1000
	print 'Keskmine';
	else
	print 'Odav';
	end;

	exec CheckProductPriceLevel 101

--	1. GetAllCustomers_ITVF
--Koosta inline funktsioon, mis tagastab kõik kliendid.
--Tabel:
--SalesLT.Customer
create function GetAllCustomers_ITVF()
returns table
return (select * from SalesLT.Customer)


select * from GetAllCustomers_ITVF()

--2. GetCustomerByID_ITVF
--Koosta funktsioon, mis:
--võtab @CustomerID
--tagastab:
--FirstName
--LastName
create function GetCustomerByID_ITVF (@CustomerId int)
returns @Table Table (CustomerId int,FirstName nvarchar(20), LastName nvarchar(20))
as begin 
insert into @Table
select CustomerId ,FirstName , LastName
from SalesLT.Customer
where CustomerID = @CustomerId
return
end

select * from GetCustomerByID_ITVF(42)

--3. GetOrdersByCustomer_ITVF
--Koosta funktsioon, mis:
--võtab @CustomerID
--tagastab kõik selle kliendi tellimused
--Tabel:
--SalesLT.SalesOrderHeader

CREATE FUNCTION GetOrdersByCustomer_ITVF (@CustomerId INT)
RETURNS @Table TABLE 
(
    CustomerId INT,
    SalesOrderNumber NVARCHAR(MAX),
    ShipMethod NVARCHAR(MAX),
    SubTotal MONEY
)
as 
begin 
    insert into @Table
    select 
        CustomerId,
        SalesOrderNumber,
        ShipMethod,
        SubTotal
    from SalesLT.SalesOrderHeader
    where CustomerID = @CustomerId
    return
end

select * from GetOrdersByCustomer_ITVF(29938)

--4. GetProductsByPrice_ITVF
--Koosta funktsioon, mis:
--võtab @MinPrice, @MaxPrice
--tagastab tooted hinnavahemikus
--Tabel:
--SalesLT.Product

create function GetProductsByPrice_ITVF(@MinPrice money, @MaxPrice money)
returns table as 
return
(select * from SalesLT.product
where ListPrice between @MinPrice and @MaxPrice);

select * from GetProductsByPrice_ITVF(200, 500)



--5. GetTopExpensiveProducts_ITVF
--Koosta funktsioon, mis:
--tagastab TOP 10 kõige kallimat toodet
--OSA 2: Multi-Statement Functions (keerulisemad)

create function GetTopExpensiveProducts_ITVF()
returns table as 
return
(select top 10 * from SalesLT.product
order by listprice desc);

select * from GetTopExpensiveProducts_ITVF()


--6. GetCustomerFullInfo_MSTVF
--Koosta funktsioon, mis:
--võtab @CustomerID
--tagastab tabeli, kus on:
--nimi (First + Last kokku)
--email
--telefon
--Tabel:
--SalesLT.Customer
--kasuta @Result TABLE

create function GetCustomerFullInfo_MSTVF(@CustomerID int)
returns @Table Table (FullName nvarchar(50), Email nvarchar(50), Phone nvarchar(20))
as 
begin 
    insert into @Table
    select FirstName + ' ' + LastName as fullname, EmailAddress, Phone
    from SalesLT.Customer
    where CustomerID = @CustomerID

    return
end

select * from GetCustomerFullInfo_MSTVF(5)

--7. GetCustomerOrderSummary_MSTVF
--Koosta funktsioon, mis:
--võtab @CustomerID
--tagastab:
--tellimuste arv
--kogusumma
--Tabel:
--SalesLT.SalesOrderHeader

create function GetCustomerOrderSummary_MSTVF(@CustomerId int)
returns @Table table (
    OrderCount int,
    TotalAmount money
)
as
begin
    insert into @Table
    select 
        count(*) as OrderCount,
        sum(SubTotal) as TotalAmount
    from SalesLT.SalesOrderHeader
    where CustomerId = @CustomerId

    return
end

select * from GetCustomerOrderSummary_MSTVF(30033)

--8. GetProductPriceCategory_MSTVF
--Koosta funktsioon, mis:
--tagastab kõik tooted + hinnaklass:
--"Odav", "Keskmine", "Kallis"
--Tabel:
--SalesLT.Product

create function GetProductPriceCategory_MSTVF()
returns @result Table
(ProductId int, Name nvarchar(200), ListPrice money,
PriceCategory nvarchar(50))
as begin 
	insert into @result
	select ProductID, Name, ListPrice, case
	when ListPrice < 100 then 'odav'
	when ListPrice between 100 and 1000 then 'keskmine'
	else 'kallis'
end
	from.SalesLT.product
	return;
end;

select * from GetProductPriceCategory_MSTVF()



--9. GetCustomersWithOrders_MSTVF
--Koosta funktsioon, mis:
--tagastab ainult need kliendid, kellel on vähemalt 1 tellimus
--Tabelid:
--SalesLT.Customer
--SalesLT.SalesOrderHeader

--10. GetTopCustomersBySpending_MSTVF
--Koosta funktsioon, mis:
--tagastab TOP 5 klienti
--koos:
--nimega
--kogukuluga

create function GetTopCustomersBySpending_MSTVF()
returns @result TABLE
(
	CustomerID INT,
	FullName NVARCHAR(200)
	TotalSpent MONEY
)
as begin
	insert into @Result
	select top 5
	c.CustomerId,
	c.FirstName + ' ' + c.LastName,
	SUM(soh.TotalDue),
	from SalesLT.SalesOrderHeader soh,
	ON c.CustomerID = soh.CustomerID,
	group by c.CustomerID c.FirstName, c.LastName,
	order by TotalSpent DESC ;
	return;
	end;


select * from GetTopCustomersBySpending_MSTVF()
