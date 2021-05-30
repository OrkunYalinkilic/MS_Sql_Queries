use AdventureWorks2017

select * from person.Person

select FirstName,LastName from Person.Person

select Title as 'Urun',FirstName + ' ' + LastName [�sim Soyisim] , MiddleName orta from person.Person

select top 10 FirstName,LastName  from person.Person 
---- ilk 10 kayd� getirir.

select top 10 percent FirstName,LastName  from person.Person 
-- tablonun y�zde 10'unu getirir.

select *from Production.Product
where
color = 'Black' and SafetyStockLevel = 500

select *from Production.Product
where
color = 'Black' or SafetyStockLevel = 500

select *from Production.Product
where SafetyStockLevel <=500

select *from Production.Product
where SafetyStockLevel !=500

-- Like 
-- Geni� arama yapmam�z� sa�lar , ProductCode de�eri AB ile ba�layan kay�tlar� getir , i�erisinde 1290 olan kay�tlar� getir , son de�eri 9 olan kay�tlar� getir diyebiliriz. 
-- kolon like '%a' ba��nda ne olursa olsun sonunda a olan kay�tlar� bana getir. 
-- kolon like 'a%' ba��nda a ile ba�layan ve devam�nda ne olursa olsun bana kay�tlar� getir. 
-- kolon like '%a%' ba��nda ve sonunda ne olursa olsun i�erisinde a harfi ge�en tum kay�tlar� bana getir. 
-- kolon like '_a' ilk karakteri ne olursa olsun ikinci karakteri a olan kay�tlar� getir. 

select *from HumanResources.Employee 
where 
NationalIDNumber like '%96%' and
JobTitle like 'Research%' and
Gender='M' 

select *from Sales.SalesOrderDetail
where
ProductID >100 and ProductID<1000 
and
CarrierTrackingNumber like '%AE'

select * from Production.Product
where 
ProductNumber 
In  -- i�eren kay�tlar 
(
'AR-5381','BA-8327',
'BE-2349','BE-2908',
'BL-2036','CA-596225',
'CA-6738','CA-7457',
'CB-2903','CN-6137'
)

select * from Production.Product
where 
ProductNumber 
Not In  -- i�ermeyen kay�tlar 
(
'AR-5381','BA-8327',
'BE-2349','BE-2908',
'BL-2036','CA-6738',
'CA-7457','CB-2903',
'CN-6137'
)

select * from Production.Product
where 
ProductNumber like '%20%'
order by ProductID  desc -- product Id ye g�re tersten s�ralar.
 A-Z : asc * opsiyonel default olarak zaten a-z ye dogru s�ralar
 Z-A : desc

select Color,Sum(SafetyStockLevel) as SafetyStockLevelSum ,Avg(ListPrice) ListPriceAvg from Production.Product
where color is not null
group by Color
having Color != 'Black'
-- �nce Veriler where komutuna g�re �ekilir.Sonra group by ile ayn� color'a sahip olanlar gruplan�r.
--En sonda da rengi black olanlar at�l�r. Having group bydan sonra kullan�l�r. Where ile ayn� i�i yapar.

select distinct Color from Production.Product -- renkleri tekrars�z getirir

select Color,Sum(ListPrice) from Production.Product
where 
ProductID in 
(
select distinct ProductID from Sales.SalesOrderDetail
)
group by Color

select *from Production.Product
where 
ProductID between 1 and  500

--Inner Join : �ki veya daha fazla tabloyu birlestirir. 
select 
PP.BusinessEntityID,
PP.FirstName,
PP.LastName,
PP.PersonType,
HRE.BirthDate,
HRE.JobTitle,
HRE.MaritalStatus
from Person.Person as PP
inner join HumanResources.Employee HRE
on PP.BusinessEntityID = HRE.BusinessEntityID

select PP.BusinessEntityID,PP.FirstName,PP.LastName,HE.*
from 
Person.Person PP left join 
HumanResources.Employee HE
on PP.BusinessEntityID = HE.BusinessEntityID

select 
SSP.BusinessEntityID,
SSP.Bonus,
PP.FirstName,
PP.LastName,
PP.BusinessEntityID
from
Sales.SalesPerson SSP
right join Person.Person PP 
on SSP.BusinessEntityID = PP.BusinessEntityID

select PP.BusinessEntityID,PP.FirstName,PP.LastName, HE.BirthDate,HE.MaritalStatus from 
Person.Person PP inner join 
HumanResources.Employee HE
on PP.BusinessEntityID = HE.BusinessEntityID

select 
BusinessEntityID,
FirstName,
LastName,
(select BirthDate from HumanResources.Employee where BusinessEntityID = Person.BusinessEntityID) as BirthDate,
(select MaritalStatus from HumanResources.Employee where BusinessEntityID = Person.BusinessEntityID) as MS
from person.Person

select
PP.ProductID,
PP.Name ProductName,
PP.Color ProductColor,
PC.Name ProductCategoryName,
PSC.Name ProductSubCategoryName,
PP.ListPrice
from 
Production.Product PP
left join Production.ProductSubcategory PSC
on PP.ProductSubcategoryID = PSC.ProductSubcategoryID
left join Production.ProductCategory PC 
on PSC.ProductCategoryID = PC.ProductCategoryID

CREATE database Udemy
drop database Udemy

-- Database'in yede�ini almak i�in databese �zerinde sa� t�k task\back up..
--Sonra o databesi silebiliriz. Sonradan tekrardan y�klemek istersek databese �zerinde 
--sa� t�k restore databese\device ...

constraint == k�s�tlay�c�
not null ->> bo� ge�ilemez
id int not null,
 
--  unique ->> de�erler unique olmal�d�r. �zel olmal�. Ayn� ba�ka bir sutun olamaz.
-- primary key ->> not null ve unique �zelligini tan�mlar.
--yas int check(yas>=15) -> degeri kaydetmeden �nce belirli sarta uyumlulugunu kontrol eder.
--olusturmaTarih datetime default getdate() -> Deger bvos gecildiginde otomatik olarak defaulttaki deger atan�r.
 
create table musteri
(
id int primary key,
musteriNumara int,
tckn nvarchar(15),
isim nvarchar(50),
soyisim nvarchar(50),
olusturmaTarih datetime
)
create table musteriIletisimBilgileri
(
id int primary key,
musteriId int,
iletisimTip int,
deger nvarchar(100),
olusturmaTarih datetime,
foreign key (musteriId) references musteri(id)
)

--Burada foreign key -> musteriId'nin musteri tablosundaki id den referans al�nd���n� belirtiyor.
--Yani musteriId degeri sadece musteri tablosundaki id lerden birini kabul eder.

