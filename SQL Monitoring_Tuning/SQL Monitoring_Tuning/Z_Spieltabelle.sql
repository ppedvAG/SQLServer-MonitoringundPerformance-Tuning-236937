--Spieltabelle

SELECT      Customers.CustomerID, Customers.CompanyName, Customers.ContactName, Customers.ContactTitle, Customers.City, Customers.Country, Employees.LastName, Employees.FirstName, Orders.OrderDate, Orders.EmployeeID, Orders.Freight, Orders.ShipName, Orders.ShipAddress, Orders.ShipCity,
                   Orders.ShipCountry, [Order Details].OrderID, [Order Details].ProductID, [Order Details].UnitPrice, [Order Details].Quantity, Products.ProductName, Products.UnitsInStock
INTO KundeUmsatz
FROM         Customers INNER JOIN
                   Orders ON Customers.CustomerID = Orders.CustomerID INNER JOIN
                   Employees ON Orders.EmployeeID = Employees.EmployeeID INNER JOIN
                   [Order Details] ON Orders.OrderID = [Order Details].OrderID INNER JOIN
                   Products ON [Order Details].ProductID = Products.ProductID
GO


insert into KundeUmsatz
select * from kundeumsatz
GO 9 --keine Varable darin möglich
-- 15 Sek


alter table kundeumsatz add id int identity


select top 3 * from kundeumsatz

set statistics io, time on


select country, city, sum(freight) 
from kundeumsatz group by country, city
option (maxdop 1)




--Kostenschwellwert auf Server(ob Paral. ja oder nein) OLAP 25  OLTP 50
----auf Server Maxdop, aber auch pro DB, aber abh. Kostenschwellwert
--auch bvei Abfragen MAXDOP möglich

--16 Kerne
--Server: Kostenschwellwert 50 
--			MAXDOP  6

--DB MAXDOP 0

--Abfrage 1


select * from sys.dm_os_wait_stats where wait_type like 'CX%'












alter table kundeUmsatz add ID int identity --8 Sekunden
--alter table..


--Messen
--Ausführungspläne..
set statistics io, time on
--IO Anzahl der Seiten, TIME CPU Dauer in ms Dauer in ms
--Messung gilt nur in diesem Fenster (Connection)
--wieder mal off 
--set statistics io, time off
--Messung kostet
select country, city , sum(unitprice*quantity)
from kundeumsatz
group by country, city 
--Seiten 65000  , CPU-Zeit = 861 ms, verstrichene Zeit = 115 ms.

--Hat sich Paralellismus gelohnt?..hat sich hier gelohnt

select country, city , sum(unitprice*quantity)
from kundeumsatz
group by country, city 
option  ( maxdop 4)

--ab Kostenschwellenwert wird MAXDOP für Abfragen verwendet
--5 ist extrem niedrig

--DW: 25 
--OLTP: 50 


13:36 :-)






Server: 2
DB 0
Abfrage  - --> 8-- 4--2








alter table kundeumsatz add ID int identity
GO

