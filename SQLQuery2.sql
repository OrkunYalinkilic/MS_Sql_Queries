use AdventureWorks2017

select * from person.Person

select FirstName,LastName from Person.Person

select Title as 'Urun',FirstName + ' ' + LastName [Ýsim Soyisim] , MiddleName orta from person.Person

select top 10 FirstName,LastName  from person.Person 
---- ilk 10 kaydý getirir.

select top 10 percent FirstName,LastName  from person.Person 
-- tablonun yüzde 10'unu getirir.

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
-- Geniþ arama yapmamýzý saðlar , ProductCode deðeri AB ile baþlayan kayýtlarý getir , içerisinde 1290 olan kayýtlarý getir , son deðeri 9 olan kayýtlarý getir diyebiliriz. 
-- kolon like '%a' baþýnda ne olursa olsun sonunda a olan kayýtlarý bana getir. 
-- kolon like 'a%' baþýnda a ile baþlayan ve devamýnda ne olursa olsun bana kayýtlarý getir. 
-- kolon like '%a%' baþýnda ve sonunda ne olursa olsun içerisinde a harfi geçen tum kayýtlarý bana getir. 
-- kolon like '_a' ilk karakteri ne olursa olsun ikinci karakteri a olan kayýtlarý getir. 

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
In  -- içeren kayýtlar 
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
Not In  -- içermeyen kayýtlar 
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
order by ProductID  desc -- product Id ye göre tersten sýralar.
 A-Z : asc * opsiyonel default olarak zaten a-z ye dogru sýralar
 Z-A : desc

select Color,Sum(SafetyStockLevel) as SafetyStockLevelSum ,Avg(ListPrice) ListPriceAvg from Production.Product
where color is not null
group by Color
having Color != 'Black'
-- Önce Veriler where komutuna göre çekilir.Sonra group by ile ayný color'a sahip olanlar gruplanýr.
--En sonda da rengi black olanlar atýlýr. Having group bydan sonra kullanýlýr. Where ile ayný iþi yapar.

select distinct Color from Production.Product -- renkleri tekrarsýz getirir

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

--Inner Join : Ýki veya daha fazla tabloyu birlestirir. 
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

-- Database'in yedeðini almak için databese üzerinde sað týk task\back up..
--Sonra o databesi silebiliriz. Sonradan tekrardan yüklemek istersek databese üzerinde 
--sað týk restore databese\device ...

constraint == kýsýtlayýcý
not null ->> boþ geçilemez
id int not null,
 
--  unique ->> deðerler unique olmalýdýr. Özel olmalý. Ayný baþka bir sutun olamaz.
-- primary key ->> not null ve unique özelligini tanýmlar.
--yas int check(yas>=15) -> degeri kaydetmeden önce belirli sarta uyumlulugunu kontrol eder.
--olusturmaTarih datetime default getdate() -> Deger bvos gecildiginde otomatik olarak defaulttaki deger atanýr.
 
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

--Burada foreign key -> musteriId'nin musteri tablosundaki id den referans alýndýðýný belirtiyor.
--Yani musteriId degeri sadece musteri tablosundaki id lerden birini kabul eder.

