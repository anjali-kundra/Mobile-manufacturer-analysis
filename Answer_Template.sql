	--SQL Advance Case Study

	SELECT * FROM DIM_CUSTOMER
	SELECT * FROM DIM_DATE
	SELECT * FROM DIM_LOCATION
	SELECT * FROM DIM_MANUFACTURER
	SELECT * FROM DIM_MODEL
	SELECT * FROM FACT_TRANSACTIONS

--Q1.List all the states in which we have customers who have bought cellphones from 2005 till today.
	
SELECT STATE 
FROM FACT_TRANSACTIONS T1
INNER JOIN DIM_LOCATION T2 ON T1.IDLocation= T2.IDLocation
INNER JOIN DIM_MODEL T3 ON T1.IDModel= T3.IDModel
WHERE Trans_date BETWEEN '2005-01-01' AND GETDATE()

--Q1--END


--Q2. What state in the US is buying the most 'Samsung' cell phones?
	
SELECT TOP 1 
State_location FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON ID_Location=IDLocation
INNER JOIN DIM_MODEL ON IDModel = ID_Model
INNER JOIN DIM_MANUFACTURER ON ID_Manufacturer=IDManufacturer
WHERE Manufacturer_Name = 'Samsung'
GROUP BY State_location
ORDER BY SUM(Quantity) DESC

--Q2--END

--Q3.Show the number of transactions for each model per zip code per state.

SELECT Model_Name, ZipCode, State_location, COUNT(IDCustomer) AS NO_OF_TRANSACTIONS FROM DIM_LOCATION
INNER JOIN FACT_TRANSACTIONS ON ID_Location=IDLocation
INNER JOIN DIM_MODEL ON IDModel = ID_Model
GROUP BY Model_Name, ZipCode, State_location
	
--Q3--END


--Q4.Show the cheapest cellphone (Output should contain the price also)

SELECT TOP 1
ID_Model, Model_Name FROM DIM_MODEL
ORDER BY Unit_price

--pending price
--Q4--END

--Q5.Find out the average price for each model in the top5 manufacturers in terms of sales quantity and order by average price.

SELECT Model_Name, AVG(Unit_price) AS AVG_PRICE FROM DIM_MODEL
INNER JOIN DIM_MANUFACTURER ON ID_Manufacturer = IDManufacturer
WHERE Manufacturer_Name IN 
(
SELECT TOP 5 Manufacturer_Name FROM FACT_TRANSACTIONS 
INNER JOIN DIM_MODEL ON IDModel = ID_Model
INNER JOIN DIM_MANUFACTURER ON ID_Manufacturer = IDManufacturer 
GROUP BY Manufacturer_Name
ORDER BY SUM(Quantity)
)
GROUP BY Model_Name
ORDER BY AVG(Unit_price) DESC


--Q5--END

--Q6.List the names of the customers and the average amount spent in 2009, where the average is higher than 500

SELECT Customer_Name, AVG(TotalPrice) AVG_SPENT
FROM DIM_CUSTOMER
INNER JOIN FACT_TRANSACTIONS ON ID_Customer = IDCustomer
WHERE YEAR(DATE) = 2009 
GROUP BY Customer_Name
HAVING AVG(TotalPrice)>500

--date column name

--Q6--END
	
--Q7. List if there is any model that was in the top 5 in terms of quantity, simultaneously in 2008, 2009 and 2010

SELECT Model_Name
FROM FACT_TRANSACTIONS
INNER JOIN DIM_MODEL ON IDModel= ID_Model
GROUP BY Model_Name
HAVING 
SUM(Quantity) >= (SELECT TOP 5 SUM(Quantity) FROM FACT_TRANSACTIONS WHERE YEAR(DTE) = 2008  GROUP BY IDModel ORDER BY SUM(Quantity) DESC) AND 
SUM(Quantity) >= (SELECT TOP 5 SUM(Quantity) FROM FACT_TRANSACTIONS WHERE YEAR(DTE) = 2009  GROUP BY IDModel  ORDER BY SUM(Quantity) DESC) AND 
SUM(Quantity) >= (SELECT TOP 5 SUM(Quantity) FROM FACT_TRANSACTIONS WHERE YEAR(DTE) = 2010  GROUP BY IDModel  ORDER BY SUM(Quantity) DESC)
	
	--date column name

--Q7--END	

--Q8.Show the manufacturer with the 2nd top sales in the year of 2009 and the manufacturer with the 2nd top sales in the year of 2010.

SELECT TOP 1 Manufacturer_Name
FROM DIM_MANUFACTURER T1
INNER JOIN DIM_MODEL T2 ON T1.ID_Manufacturer= T2.IDManufacturer
INNER JOIN FACT_TRANSACTIONS T3 ON T2.ID_Model= T3.IDModel
GROUP BY Manufacturer_Name
ORDER BY SUM(TotalPrice) DESC

--Q8--END

--Q9.Show the manufacturers that sold cellphones in 2010 but did not in 2009.
	
SELECT Manufacturer_Name FROM DIM_MANUFACTURER T1
INNER JOIN DIM_MODEL T2 ON T1.ID_Manufacturer= T2.IDManufacturer
INNER JOIN FACT_TRANSACTIONS T3 ON T2.ID_Model= T3.IDModel
WHERE YEAR(DTE) = 2010 
EXCEPT 
SELECT Manufacturer_Name FROM DIM_MANUFACTURER T1
INNER JOIN DIM_MODEL T2 ON T1.ID_Manufacturer= T2.IDManufacturer
INNER JOIN FACT_TRANSACTIONS T3 ON T2.ID_Model= T3.IDModel
WHERE YEAR(DTE) = 2009

--date name change

--Q9--END

--Q10.Find top 100 customers and their average spend, average quantity by each year. Also find the percentage of change in their spend.
	
SELECT TOP 100 Customer_Name, 
AVG(CASE WHEN YEAR(DTE) = 2005 THEN TotalPrice END) AS AVERAGE_PRICE_2005,
AVG(CASE WHEN YEAR(DTE) = 2005 THEN Quantity END) AS AVERAGE_QTY_2005,
AVG(CASE WHEN YEAR(DTE) = 2018 THEN TotalPrice END) AS AVERAGE_PRICE_2018,
AVG(CASE WHEN YEAR(DTE) = 2018 THEN Quantity END) AS AVERAGE_QTY_2018
FROM DIM_CUSTOMER
INNER JOIN FACT_TRANSACTIONS T1 ON T1.IDCustomer= DIM_CUSTOMER.ID_Customer
GROUP BY Customer_Name

--date column


EXEC sp_rename 'DIM_DATE.DATE' , 'DTE', 'COLUMN'












--Q10--END
	