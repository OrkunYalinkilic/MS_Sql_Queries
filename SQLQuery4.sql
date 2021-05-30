select EnglishProductName,SafetyStockLevel from DimProduct

---- MAx Kullanýmý 

Select Max(SafetyStockLevel) as EnYuksekDeger from DimProduct

---- Min Kullanimi

Select Min(SafetyStockLevel) as EnYuksekDeger from DimProduct

select *from Production.Product

select count(*) from Production.Product where color='Black'

select AVG(SafetyStockLevel) from Production.Product where color='Black' 
-- Rengi siyah olan tüm ürünlerin ortalama stok bilgisidir.

 select SUM(SafetyStockLevel) from Production.Product where color='Black'
 --Rengi siyah olan ürün sayýsý



