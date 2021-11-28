USE Northwind
GO

SELECT C.CategoryName,COUNT(*) ADET
FROM Products P
JOIN Categories C ON P.CategoryID=C.CategoryID
GROUP BY C.CategoryName
ORDER BY ADET ASC



SELECT C.CategoryName,SUM(P.UnitPrice*P.UnitsInStock) AS MALIYET
FROM Products P
JOIN Categories C ON C.CategoryID=P.CategoryID
GROUP BY C.CategoryName
HAVING  SUM(P.UnitPrice*P.UnitsInStock)>7000
ORDER  BY MALIYET DESC


SELECT C.Country,COUNT(*) ADET
FROM Customers C
GROUP BY C.Country
ORDER BY ADET ASC

--SELECT COUNT(*)
--FROM [Order Details] OD
--HAVING COUNT(*)>100

SELECT P.ProductName,C.CategoryID,S.CompanyName,SUM(P.UnitPrice*P.UnitsInStock) AS MALIYET
FROM Products p
JOIN Categories C ON C.CategoryID=P.CategoryID
JOIN Suppliers S ON S.SupplierID=P.SupplierID
GROUP BY P.ProductName,S.CompanyName,C.CategoryID
HAVING SUM(P.UnitPrice*P.UnitsInStock)>180
ORDER BY S.CompanyName ASC

-- Siparişleri sipariş numarası ve sipariş toplam tutarı olarak listeleyiniz

SELECT OD.OrderID,ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2)  "TOPLAM TUTAR"
FROM [Order Details] OD
GROUP BY OD.OrderID
ORDER BY [TOPLAM TUTAR] DESC


-- Hangi urunden ne kadarlık siparis edilmis

SELECT P.ProductName,ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS "SIPARIS TUTAR"
FROM [Order Details] OD 
JOIN Products P ON P.ProductID =OD.ProductID
GROUP BY P.ProductName
ORDER BY [SIPARIS TUTAR] ASC

-- Hangi tedarikciden ne kadarlık siparis edilmis 

SELECT S.CompanyName,P.ProductName,COUNT(*) ADET,ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " SUPPLIERS SIPARIS TUTAR"
FROM Products P
JOIN [Order Details] OD ON OD.ProductID=P.ProductID
JOIN Suppliers S ON S.SupplierID=P.SupplierID
GROUP BY S.CompanyName,P.ProductName
--ORDER BY [SUPPLIERS TOPLAM TUTAR]  DESC


-- Hangi müsteriden ne kadarlık siparis alınmıs
SELECT C.CompanyName,ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " MUSTERI TOPLAM TUTAR TUTAR"
FROM Customers C
JOIN Orders O ON O.CustomerID=C.CustomerID
JOIN [Order Details] OD ON OD.OrderID=O.OrderID
GROUP BY C.CompanyName
ORDER BY C.ContactName ASC

-- Hangi çalısanım ne kadarlık ürün siparis etmis

SELECT E.FirstName+''+E.LastName AS EMPLOYEES ,ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " CALISAN TOPLAM TUTAR TUTAR"
FROM Orders O
JOIN Employees E ON E.EmployeeID=O.EmployeeID
JOIN [Order Details] OD ON OD.OrderID=O.OrderID
GROUP BY E.FirstName+''+E.LastName
ORDER BY  EMPLOYEES ASC


-- Hangi üründen ne kadarlIk siparis edilmis(YILLARA GÖRE GRUPLAYINIZ)

SELECT P.ProductName, DATENAME(YEAR,O.OrderDate) , ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " CALISAN TOPLAM TUTAR TUTAR"
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID=O.OrderID
JOIN Products P ON P.ProductID=OD.ProductID
GROUP BY P.ProductName, DATENAME(YEAR,O.OrderDate)
ORDER BY P.ProductName ASC,DATENAME(YEAR,O.OrderDate) DESC


-- Hangi üründen ne kadarlýk sipariþ edilmiþ(AYA GÖRE GRUPLAYINIZ)

SELECT P.ProductName, MONTH(O.OrderDate) , ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " CALISAN TOPLAM TUTAR TUTAR"
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID=O.OrderID
JOIN Products P ON P.ProductID=OD.ProductID
GROUP BY P.ProductName, MONTH(O.OrderDate)
ORDER BY P.ProductName ASC,MONTH(O.OrderDate) DESC

-- HENUZ ULASMAMIS SIPARISLERIN  SAYISI
SELECT COUNT(*)
FROM Orders O
WHERE O.ShippedDate is null


-- HENÜZ ULASMAMIS SIPARISLERIN TOPLAM MALIYETI NEDIR

SELECT ROUND(SUM((1-OD.Discount)*OD.UnitPrice*OD.Quantity),2) AS " CALISAN TOPLAM TUTAR TUTAR"
FROM Orders O
JOIN [Order Details] OD ON OD.OrderID=O.OrderID
WHERE O.ShippedDate is null

-- -- HENÜZ ULASMAMIS ÜRÜNLER ORTALAMA KAÇ GÜNDÜR BEKLEMEKTE

SELECT  AVG(DATEDIFF(DAY,O.RequiredDate,GETDATE())) as "ORTALAMA GUN"
FROM Orders O
WHERE O.ShippedDate is null

--ORTALAMA TESLIM ZAMANI

SELECT AVG(DATEDIFF(DAY,O.OrderDate,o.RequiredDate)) as "ORTALAMA TESLIM"
FROM Orders O
WHERE O.ShippedDate is not null

-- SİPARIS VERILEN ULKELERIN LISTESI(AYNI ULKE 2 DEFA GOSTERILMEYECEK)

SELECT DISTINCT O.ShipCountry 
FROM Orders O
--GROUP BY O.ShipCountry


-- ORTALAMA FIYATIN ÜSTÜNDE SATTIGIM ÜRÜNLERIN LISTESINI GETIRIN


SELECT P.ProductName,P.UnitPrice
FROM Products P
WHERE P.UnitPrice>(
		SELECT AVG(P.UnitPrice) ORTALAMA
		FROM Products P
)
ORDER BY P.UnitPrice

-- HANGI MÜSTERILERIN ORTALAMA SIPARISIN ÜSTÜNDE SIPARIS VERMIS VE NE KADARLIK SIPARIS VERMISLER

SELECT C.CompanyName,(1-OD.Discount)*(OD.UnitPrice*OD.Quantity) AS "MUSTERI SIPARIS TUTAR"
FROM Customers C
JOIN Orders O ON O.CustomerID=C.CustomerID
JOIN [Order Details] OD ON OD.OrderID =O.OrderID
WHERE (1-OD.Discount)*(OD.UnitPrice*OD.Quantity) >
(
		SELECT AVG((1-OD.Discount)*(OD.UnitPrice*OD.Quantity))
		FROM [Order Details] OD
)

ORDER BY [MUSTERI SIPARIS TUTAR] ASC

-- HENUZ SIPARIS VERMEMIS MUSTERILER

SELECT C.CompanyName,C.ContactName
FROM Customers C
WHERE C.CustomerID NOT IN(
SELECT DISTINCT  O.CustomerID
	FROM ORDERS O 
)