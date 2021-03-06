-- DDL(CREATE ALTER DROP) DML(INSERT-UPDATE-DELETE- SELECT)

SELECT 'WISSEN'  -- column name
SELECT LOWER('WISSEN')
SELECT UPPER('wissen')
SELECT MONTH(GETDATE()) 
SELECT YEAR(GETDATE())
SELECT GETDATE()    -- 2021-11-24 22:05:24
SELECT GETUTCDATE() -- 2021-11-24 19:04:48
SELECT DATENAME(qq,GETDATE())  --4  
SELECT DATENAME(YY,GETDATE()) 
SELECT DATENAME(MM,GETDATE())


-- *********

SELECT *
FROM Orders

SELECT OrderID, CustomerID,OrderDate,ShipName,ShipAddress
FROM Orders

SELECT CustomerID,DATENAME(MM,OrderDate)+' '+ DATENAME(YY,OrderDate) AS "SIPARIS YILI"
FROM Orders

SELECT OrderID, DATEDIFF(DAY,OrderDate,GETDATE()) AS "SIPARIS GUN FARK"
FROM Orders

SELECT CustomerID,OrderDate,DATEADD(year,10,OrderDate) AS "10 YIL EKLENDI"
FROM Orders

SELECT CustomerID,OrderDate,DateName(YY,DATEADD(year,10,OrderDate)) AS "10 YIL EKLENDI"
FROM Orders

----- ****** ------- 

SELECT TOP 20 ProductID,CategoryID, ProductName,UnitPrice
FROM Products


SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice>=50 AND UnitPrice<=200

SELECT ProductName,UnitPrice
FROM Products
WHERE UnitPrice BETWEEN 50 AND 150


SELECT ProductName,UnitPrice
FROM Products
--WHERE UnitPrice BETWEEN 50 AND 150
ORDER BY UnitPrice DESC

-- KDV'LI FIYAT
SELECT ProductName,UnitPrice,UnitPrice*1.18 AS "KDVLI FIYAT"
FROM Products
ORDER BY UnitPrice*1.18 DESC

-- MALIYET URUNLER
SELECT ProductName,UnitPrice,UnitsInStock,UnitPrice*UnitsInStock as "MALIYET"
FROM Products
ORDER BY UnitPrice,"MALIYET" ASC

-- JOIN IFADELERI
SELECT P.ProductName,c.CategoryName,P.CategoryID,P.UnitPrice
FROM Products P
INNER JOIN Categories C ON P.CategoryID=C.CategoryID

SELECT P.ProductName,c.CategoryName,P.CategoryID,P.UnitPrice
FROM Products P
INNER JOIN Categories C ON P.CategoryID=C.CategoryID
ORDER BY UnitPrice DESC

SELECT p.ProductName,C.CategoryName,S.CompanyName
FROM Products P
INNER JOIN Categories C ON P.CategoryID=C.CategoryID
INNER JOIN Suppliers S ON S.SupplierID=P.SupplierID


--FEDARAL SHIPPING ILE TASINMIS VE NANCY'NIN ALMIS OLDUGU SIPARISLERI GOSTERINIZ


SELECT O.OrderID
FROM Orders O
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
INNER JOIN Employees E ON E.EmployeeID=O.EmployeeID
WHERE S.CompanyName='Federal Shipping' AND E.FirstName='Nancy'

-- M????TER?? ADI,ONAYLAYAN ??ALI??ANIN ADI,ALDI??I ??R??NLER??N ADINI L??STELEY??N
SELECT C.ContactName,e.FirstName+''+e.LastName AS CALISAN , P.ProductName
FROM [Order Details] OD
INNER JOIN Products P ON OD.ProductID=P.ProductID
INNER JOIN Orders O ON O.OrderID=OD.OrderID
INNER JOIN Employees E ON E.EmployeeID=O.EmployeeID
INNER JOIN Customers C ON C.CustomerID=O.CustomerID


-- 01.01.1998 tarihinden sonra Siparis veren m????terilerin isimlerini ve siparis tarihlerini listeleyiniz.
SELECT C.ContactName,O.OrderDate
FROM Orders O
INNER JOIN Customers C ON C.CustomerID=O.CustomerID
WHERE O.OrderDate>'01.01.1998'
ORDER BY O.OrderDate ASC

-- 10248 nolu Sipari?? hangi kargo sirketi ile gonderilmi??tir.
SELECT S.CompanyName
FROM Orders O
INNER JOIN Shippers S ON S.ShipperID=O.ShipVia
WHERE O.OrderID=10248

-- TOFU isimli ??r??n al??nan sipari??lerin sipari?? numaralar??n?? listeleyiniz.
SELECT OD.OrderID
FROM Products P
INNER JOIN [Order Details] OD ON P.ProductID=OD.ProductID
WHERE P.ProductName='Tofu'

-- DUMON VEYA ALFKI M????TER??LER??N??N ALDI??I 1 ID L?? ??ALI??ANIMIN ONAYLADI??I 1 VEYA 3 NOLU KARGO F??RMASIYLA TA??INMI?? S??PAR????LER?? GET??R??N
SELECT *
FROM Orders O 
WHERE O.CustomerID IN ('DUMON','ALFKI') AND O.EmployeeID=1 AND O.ShipVia IN(1,3)
