use powerbi;
select  customerid from customer_purchase;
-- Normalization of table
-- create customers table using customer_purchase table 
CREATE TABLE customers1 AS
with cte as (
    SELECT customername, country,purchasedate FROM customer_purchase )
select row_number() over(order by purchasedate )+3000 as customerid,customername, country from cte ;

-- create customers table using customer_purchase table 
CREATE TABLE Purchase AS with cte1 as
(SELECT row_number()over(order by purchasedate asc)+5000 as PurchaseID,PurchaseQuantity,PurchasePrice,PurchaseDate,
cs.customerid,p.ProductID,TransactionID
FROM customer_purchase c join products p on c.productname = p.productname 
join customers cs on c.customername = cs.customername  AND c.Country=cs.Country)
select PurchaseID,  PurchaseQuantity, PurchasePrice, PurchaseDate,
customerid, ProductID, TransactionID from cte1 ;

-- create customers table using customer_purchase table 
CREATE TABLE Products AS
(with cte as (select distinct productname , productcategory , dense_rank() over(partition by productcategory order by productName)+200 as pid from customer_purchase)
select row_number() over(order by productname)+200 as productid 
,productname,productcategory from cte);



-- check null values in TransactionID 
SELECT *
FROM customer_purchase
WHERE TransactionID IS NULL;
-- check null values in CustomerID 
SELECT *
FROM customer_purchase
WHERE Customerid IS NULL;
-- check null values in ProductName 
SELECT *
FROM customer_purchase
WHERE ProductName IS NULL;
-- check null values in ProductCategory 
SELECT *
FROM customer_purchase
WHERE ProductCategory IS NULL;
-- check null values in PurchaseQuantity 
SELECT *
FROM customer_purchase
WHERE PurchaseQuantity IS NULL;
-- check null values in PurchasePrice 
SELECT *
FROM customer_purchase
WHERE PurchasePrice IS NULL;
-- check null values in PurchaseDate 
SELECT *
FROM customer_purchase
WHERE PurchaseDate IS NULL;
-- check null values in Country 
SELECT *
FROM customer_purchase
WHERE Country IS NULL;


-- build relationship in between tables 
ALTER TABLE customers
ADD PRIMARY KEY (CustomerID);

ALTER TABLE products
ADD PRIMARY KEY (productID);

ALTER TABLE purchase
ADD CONSTRAINT fk FOREIGN KEY (CustomerID)
REFERENCES customers(CustomerID);

ALTER TABLE purchase
ADD CONSTRAINT fk2 FOREIGN KEY (productID)
REFERENCES products(productID);


