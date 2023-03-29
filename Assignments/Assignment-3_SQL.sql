-- Assignment-3
			
-- Customer
Customer_Id Customer_Name
1				John
2				Smith
3				Ricky
4				Walsh
5				Stefen
6				Fleming
7				Thomson
8				David

CREATE TABLE CUSTOMER ( 
	Customer_ID int PRIMARY KEY,
    Customer_Name varchar(50)
    );
    
SELECT * FROM CUSTOMER;


-- Product
Product_Id	Product_Name	Product_Price
1			Television		19000
2			DVD				3600
3			Washing Machine	7600
4			Computer		35900
5			Ipod			3210
6			Panasonic Phone	2100
7			Chair			360
8			Table			490
9			Sound System	12050
10			Home Theatre	19350

CREATE TABLE PRODUCT (
	Product_ID int PRIMARY KEY,
    Product_Name varchar(50),
    Product_Price int
    );

Select * from PRODUCT;

-- Order
Order_Id	Customer_Id	Ordered_Date
1				4		10-Jan-05
2				2		10-Feb-06
3				3		20-Mar-05
4				3		10-Mar-06
5				1		5-Apr-07
6				7		13-Dec-06
7				6		13-Mar-08
8				6		29-Nov-04
9				5		13-Jan-05
10				1		12-Dep-2007

CREATE TABLE ORDERS (
	Order_ID INT,
    Customer_ID int,
    Ordered_Date DATE,
    PRIMARY KEY (Order_ID),
    FOREIGN KEY (Customer_ID) references CUSTOMER(Customer_ID)
    );
    
SELECT * FROM ORDERS;

-- Order_Details
Order_Detail_Id	Order_Id	Product_Id	Quantity
1					1			3			1
2					1			2			3
3					2			10			2
4					3			7			10
5					3			4			2
6					3			5			4
7					4			3			1
8					5			1			2
9					5			2			1
10					6			5			1
11					7			6			1
12					8			10			2
13					8			3			1
14					9			10			3
15					10			1			1

CREATE TABLE ORDER_DETAILS(
	Order_Detail_ID int PRIMARY KEY,
    Order_ID int,
    Product_ID INT,
    QUANTITY INT,
    FOREIGN KEY (Order_ID) REFERENCES ORDERS(Order_ID),
    FOREIGN KEY (Product_ID) REFERENCES PRODUCT(Product_ID)
);
SELECT * FROM ORDER_DETAILS;


-- 1.	Fetch all the Customer Details along with the product names that the customer has ordered.
	SELECT c.Customer_ID,c.Customer_Name, p.Product_Name FROM CUSTOMER c
	JOIN ORDERS o ON c.Customer_ID=o.Customer_ID
	JOIN ORDER_DETAILS od ON od.Order_ID=o.Order_ID
	JOIN PRODUCT p on p.Product_ID = od.Product_ID;

-- 2.	Fetch Order_Id, Ordered_Date, Total Price of the order (product price*qty).
	SELECT o.Order_ID, o.Ordered_Date , SUM(p.Product_Price * od.Quantity) AS Total_Price FROM ORDERS o
	JOIN ORDER_DETAILS od ON o.Order_ID=od.Order_ID
	JOIN PRODUCT p on p.Product_ID = od.Product_ID
	GROUP BY o.Order_ID, o.Ordered_Date;

-- 3.	Fetch the Customer Name, who has not placed any order
	SELECT Customer_Name FROM CUSTOMER WHERE Customer_ID NOT IN (SELECT Customer_ID FROM ORDERS);

-- 4.	Fetch the Product Details without any order(purchase)
	SELECT * FROM PRODUCT WHERE Product_ID NOT IN (SELECT Product_ID FROM ORDER_DETAILS);

-- 5.	Fetch the Customer name along with the total Purchase Amount
	SELECT c.Customer_Name, SUM(od.Quantity * p.Product_Price) AS purchase_amount
	FROM CUSTOMER c , ORDER_DETAILS od, PRODUCT p , ORDERS o
	WHERE c.Customer_ID=o.Customer_ID AND od.Product_ID=p.Product_ID
	GROUP BY c.Customer_ID;

-- 6.	Fetch the Customer details, who has placed the first and last order
	-- First ordered ---
	SELECT C.* FROM CUSTOMER C , ORDERS O
	WHERE C.Customer_ID = O.Customer_ID
	ORDER BY O.Ordered_Date ASC
	LIMIT 1;

	-- Last Ordered---
	SELECT C.* FROM CUSTOMER C , ORDERS O
	WHERE C.Customer_ID = O.Customer_ID
	ORDER BY O.Ordered_Date DESC
	LIMIT 1;

-- 7.	Fetch the customer details , who has placed more number of orders
	SELECT c.* FROM CUSTOMER c
	JOIN (
  		SELECT Customer_ID, COUNT(*) AS orders
  		FROM orders GROUP BY Customer_ID ORDER BY orders DESC LIMIT 1
		) o ON c.Customer_ID = o.Customer_ID;

-- 8.	Fetch the customer details, who has placed multiple orders in the same year
	SELECT c.Customer_ID, c.Customer_Name, COUNT(DISTINCT 	YEAR(o.Ordered_Date)) as num_years 
    FROM CUSTOMER c 
    JOIN ORDERS o ON c.Customer_ID = o.Customer_ID 
    GROUP BY c.Customer_ID, c.Customer_Name 
    HAVING COUNT(DISTINCT YEAR(o.Ordered_Date)) > 1;

-- 9.	Fetch the name of the month, in which more number of orders has been placed
	SELECT DATE_FORMAT(Ordered_Date, '%M') AS Month_Name, COUNT(Order_ID) AS Orders
	FROM ORDERS
	GROUP BY Month_Name
	ORDER BY Orders DESC
	LIMIT 1;

-- 10.	Fetch the maximum priced Ordered Product
	SELECT p.* 
	FROM PRODUCT p, ORDER_DETAILS od
	WHERE p.Product_ID = od.Product_ID 
	ORDER BY Product_Price DESC
	LIMIT 1;
