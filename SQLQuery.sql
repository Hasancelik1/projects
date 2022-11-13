




select DATEDIFF(year,BirthDate,HireDate) 'Toplam Y�l' ,e.* from Employees e where DATEDIFF(year,BirthDate,HireDate) >28

--soru7- �u an 35 ya��ndan b�y�k olanlar kimler?

select DATEDIFF(year,BirthDate,GETDATE()) as 'age' from Employees e where DATEDIFF(year,BirthDate,GETDATE()) >35

--soru 8- company name Q ile ba�layanlar?, do ge�enler ve i�inde hi� a olmayanlar
select * from Customers where CompanyName like 'Q%'
select * from Customers where CompanyName like '%do%'
select * from Customers where CompanyName not like '%a%'

--soru9- almanyan�n berlinden olanlar, USA olanlar�n regionlar�, regionlar� bo� olmayanlar?

select * from Orders where ShipCountry = 'Germany' and ShipCity = 'Berlin'
select ShipRegion from Orders where ShipCountry = 'USA'
select * from Orders where ShipRegion is not null


--soru15-- Ka� adet farkl� contact title var*

select Count(Distinct ContactTitle) from Suppliers

--soru16-- DISCONTINUED Yes (Y) olanlar�n stok toplam� 

select sum(UnitsInStock)  from Products where Discontinued = 'True'

--soru17-- bir sipari� i�in �denen �cret?

select sum(UnitPrice*Quantity*(1-Discount)) totalpyment ,OrderID from [Order Details]
group by OrderID
order by  sum(UnitPrice*Quantity*(1-Discount)) desc
--soru18-- Her sipari� i�in yap�lan indirim toplam�?

select OrderID , sum(Discount*UnitPrice) from [Order Details] GROUP BY OrderID ------------ (CHECKED)

--soru19-- ipari�in indirim �ncesi ve indirim sonras� �denen �creti 

select UnitPrice*Quantity beforediscount,UnitPrice*Quantity*(1-Discount) afterdiscount ,*from [Order Details] 




select * from [Order Details]

select OrderID,SUM(UnitPrice*Quantity*Discount)/SUM(UnitPrice*Quantity) from [Order Details] group by OrderID


	-- soru20--Sipari�ler ka� g�nde gitmi�?

select DATEDIFF(DAY,OrderDate,RequiredDate) g�n, * from Orders

--soru21-- kargolama s�releri g�ne g�re gruplama

select DATEDIFF(DAY,OrderDate,RequiredDate) AS g�n, OrderID 
	from Orders  GROUP BY DATEDIFF(DAY,OrderDate,RequiredDate), OrderID

--soru22-- shipregion'u RJ ve CA olmayan sipari�lerin ADEdi

select * from Orders where not (ShipRegion = 'RJ' or ShipRegion =  'CA') 

--soru23--ismi A ile ba�layanlar�n sat�� toplam� ve paras�

select Employees.FirstName,
sum([Order Details].Quantity) as sat��,
sum(UnitPrice*Quantity) as toplampara
from 
	[Order Details] 
	LEFT JOIN Orders
	on [Order Details].OrderID = Orders.OrderID
	LEFT JOIN Employees
	on orders.EmployeeID = Employees.EmployeeID
where Employees.FirstName like 'A%'
GROUP BY Employees.FirstName

--soru24-- fax numaras� 8den b�y�k olanlar� getir
--soru25-- DESCRIPTIONLARI V�RG�LE G�RE AYIRARAK KATEGOR� �S�MLER�N� KAR�ISINA GET�R

--select STRING_SPLIT(Categories.Description, ','), Categories from Categories STRING_SPLIT(Categories.Description, ',')

--soru26--order_Date ile shipped_date aras�nda 30 g�nden fazla olan sipari�lere ortalama ne kadar indirim yap�ld�?

select avg(Discount) from 
Orders 
left join [Order Details] 
on Orders.OrderID = [Order Details].OrderID
where DATEDIFF(DAY,OrderDate,ShippedDate)>30

--soru27-- order baz�nda en �ok quantitysi olanlar

select OrderID,max(Quantity) as  maxquantity from [Order Details] group by OrderID

--soru28--sipari� ve kargolanma aras�nda 7 g�nden fazla olan �r�nlerin ayl�k adet g�r�nt�s�

select MONTH(ShippedDate) as AY, count(*) as ADET from Orders 
where  DATEDIFF(DAY,OrderDate,ShippedDate)>7 
GROUP BY MONTH(ShippedDate)

--soru29--toplam 7 g�nden fazla olan �r�n adetlerinin toplam�

select sum(Quantity) from Orders left join [Order Details] 
on Orders.OrderID = [Order Details].OrderID
where DATEDIFF(DAY,OrderDate,ShippedDate)>7

--soru30--ka� adet �r�n supply oldu�u �lke d���na gidiyor?

select sum(Quantity) 
from 
	Orders
	left join [Order Details] 
	on Orders.OrderID = [Order Details].OrderID
	left join Products
	on [Order Details].ProductID = Products.ProductID
	left join Suppliers
	on Products.SupplierID = Suppliers.SupplierID

where ShipCountry != Country

--soru31--employeninh ortalama kargo sipari� s�resini bul


select EmployeeID, avg(DATEDIFF(DAY,OrderDate,ShippedDate)) as ortalama g�n 
from Orders
group by EmployeeID


--soru32--categori isimlerini yan yana yazd�r.


SELECT   categorynamee = COALESCE(categoryname + ',', '')  FROM Categories 


--soru33--DESCRIPTIONLARI V�RG�LE G�RE AYIRARAK KATEGOR� �S�MLER�N� KAR�ISINA GET�R


SELECT   categoryname = COALESCE(Description + ',', '')  FROM Categories 


-- soru34-employeenin bir sonraki sipari�ne kadar ge�en s�re ortalamas� +


select df.EmployeeID , avg(df.diff) as ort
from (
	select EmployeeID,OrderDate, lead(OrderDate) over(partition by EmployeeID order by OrderDate) as x, 
	DATEDIFF(DAY,OrderDate,lead(OrderDate) over(partition by EmployeeID order by OrderDate)) as diff
	from orders
) as df

group by df.EmployeeID


-- soru 35- employee baz�nda sonraki sipari� tahmini tarihi +


select df.EmployeeID , avg(df.diff) + max(orderdate) as tahmin
from (
	select EmployeeID,
	OrderDate,
	lead(OrderDate) over(partition by EmployeeID order by OrderDate) as bd, 
	DATEDIFF(DAY,OrderDate,lead(OrderDate) over(partition by EmployeeID order by OrderDate)) as diff
	from orders
) as df

group by df.EmployeeID


-- soru 37-employenin ortalama kargo sipari� s�resini bul


 select EmployeeID,avg(DATEDIFF(DAY,OrderDate, ShippedDate)) as sipari� 
 from Orders 
 group by EmployeeID


 --soru38 --  soru 35 deki sipair�in hangi g�n kargoya ��kaca��n� bul.. 

select max(od)+AVG(diff)+AVG(dif2)
from(
	select 
	EmployeeID,
	OrderDate as od,
	ShippedDate as sd,
	lead(OrderDate) over(partition by EmployeeID order by OrderDate) as bd, 
	DATEDIFF(DAY,OrderDate,lead(OrderDate) over(partition by EmployeeID order by OrderDate)) as diff,
	DATEDIFF(DAY,OrderDate, ShippedDate) dif2
	from orders
) as s1
group by EmployeeID

select * from Orders

--soru 39 -- Hangi �lkeye gidecek tahmini

	SELECT EmployeeID, ShipCountry, ct   
	from (
		select EmployeeID,
		ShipCountry,
		COUNT(OrderID) ct ,
		ROW_NUMBER() OVER(partition by EmployeeID order by COUNT(OrderID) desc ) as row
		from Orders 
		group by EmployeeID,ShipCountry
	)as s1
where Row = 1


--soru 40 -- Employee baz�nda sat�� miktar� esas al�narak bir sonraki sipari� hangi �lkeye gidecek


select  tb.FirstName,tb.LastName,tb.ShipCountry,tb.summ
	
	from(
			select sum(ord.Quantity*ord.UnitPrice) as summ,
			e.EmployeeID,
			o.ShipCountry ,
			e.FirstName,
			e.LastName,
			ROW_NUMBER() over (partition by e.EmployeeID order by sum(ord.Quantity) desc) as rown
			from 
			[Order Details] ord
			left join orders o
			on o.OrderID = ord.OrderID 
			left join Employees e
			on o.EmployeeID = e.EmployeeID
			group by e.EmployeeID , o.ShipCountry ,e.FirstName, e.LastName
			
	) as tb

where rown = 1

---




--- Change Data Capture i�in g�ncelleme

select * from customers

UPDATE [dbo].[customers]
   SET [CustomerID] = CD.CustomerID
      ,[CompanyName] = CD.CompanyName
      ,[ContactName] = CD.ContactName
      ,[ContactTitle] = CD.ContactTitle
      
      ,[City] = CD.City
      ,[Region] = CD.Region
      ,[PostalCode] = CD.PostalCode
      ,[Country] = CD.Country
      ,[Phone] = CD.Phone
      ,[Fax] = CD.Fax
      ,[created_date] = CD.created_date
      ,[modifed_date] = CD.modifed_date
   from dbo.customers C
   left join dbo.customerdumptable	CD on C.CustomerID = CD.CustomerID



   -- Created date ve modified date s�tunlar� i�in trigger

   
USE [Northwind]  --specify database name
 GO
 SET ANSI_NULLS ON
 GO
 SET QUOTED_IDENTIFIER ON
 GO
 CREATE TRIGGER dbo.set_modified_date1 on dbo.[Customers] FOR UPDATE AS
 BEGIN
     UPDATE dbo.[Customers]
     SET modifed_Date = GETDATE()
     FROM dbo.[Customers] INNER JOIN deleted d ON dbo.[Customers].CustomerID = d.CustomerID
 END
 GO
 ALTER TABLE dbo.[Customers] ENABLE TRIGGER [set_modified_date1]
 GO




