  declare @TamIsim nvarchar(50)
  set @TamIsim = 'Orkun Yalinkilic'
  print @TamIsim

  declare @TamIsim1 nvarchar(50) = 'Orkun YK'
  print @TamIsim1

  declare @toplamKayitSayisi int
  select @toplamKayitSayisi = count(*) from Production.Product
  print @toplamKayitSayisi

 declare @Personel table -- tablo tipinde bir de�i�ken olu�turuldu
  (
  ID int,
  isim nvarchar(30) not null,
  soyisim nvarchar(30)
  )

declare @KullaniciAdi nvarchar (20), @Sifre nvarchar(20)
set @KullaniciAdi  = 'Demo1'
set @Sifre = 'Demo'

if @KullaniciAdi='Demo' and @Sifre='Demo'
begin
print 'Kullan�c� Giri� ��lemi Ba�ar�l�'
end
else
begin
print 'Kullan�c� Giri� ��lemi Ba�ar�s�z'
end

go

declare @toplamKayitSayisi int
select @toplamKayitSayisi = count(*) from Production.Product

if @toplamKayitSayisi<=100
begin
print 'Toplam kayit 100den b�y�k'
end
else if @toplamKayitSayisi>100 and @toplamKayitSayisi<=200
begin
print 'Toplam kayit 100-200 aras�nda'
end
else
begin
print 'Toplam kayit 200den b�y�k'
end

select 
Name,
(case Color
when 'Black' then 'Siyah'
when 'Blue' then 'Mavi'
when 'Red' then 'K�rm�z�'
when 'Silver' then 'G�m��'
else 'Renk tan�m� yap�lmam��'
end)
as 'Renkler'
from Production.Product

declare @isim nvarchar(20) = 'Orkun Yalinkilic'
declare @sayac int = 0

while @sayac<= len(@isim)
begin
print substring(@isim,1,@sayac)
set @sayac = @sayac +1
end
print 'While i�lemi bitti'

-- Local Temp Table : #  -- temp tablolar ge�ici olarak olu�turuluyor. SQL kapan�p a��ld���nda silinmi� oluyorlar.
-- Global Temp Table : ## -- ve sistem databese i�erisinde olu�urlar.

create table #Personel
(
id int primary key,
isim nvarchar(20) not null,
soyisim nvarchar(20) not null
)

insert into #Personel(id,isim,soyisim) values(1,'Cengiz','Atilla')
insert into #Personel(id,isim,soyisim) values(2,'Orkun','Yalinkilic')

select *from #Personel

update #Personel set isim = 'Fatih' where id=2

delete #Personel where id=1

begin try
insert into #Personel (id) values('Cengiz')
end try
begin catch
print 'Hata Olu�tu'
end catch

create function UrunIDIsimAl -- scaler fonksiyon: bir degeri d�nd�r�r.
(
 @ID int --parametre
)
returns nvarchar(200) -- geriye d�n�� tipi
as
begin
declare @Bulunanisim nvarchar(200)

if(Exists(Select * from Production.Product where ProductID= @ID))
begin
select @Bulunanisim = Name from Production.Product where ProductID=@ID
end
else
begin
set @Bulunanisim = 'Aradiginiz isim bulunamadi!'
end
return @Bulunanisim
end

select dbo.UrunIDIsimAl(1)
select dbo.UrunIDIsimAl(13421)

create function IDPRODUCT -- geriye sorgu d�nd�ren fonksiyon
(
@ID int
)
returns table
as
return ( select *from Production.Product where ProductID=@ID)

select *from dbo.IDPRODUCT(1)

create function Personel -- geriye tablo d�nd�ren fonksiyon (i�eride �zel olarak eklenen tabloyu d�nd�r�yor.)
( -- parametre almadan bu �ekilde fonksiyon kullan�l�r
)
returns @PersonelTablo table
(
ID int,
isim nvarchar(20),
soyisim nvarchar(20)
)
as
begin
insert into @PersonelTablo (ID,isim,soyisim) values(1,'Orkun','Yal�nk�l��')
return 
end

select *from dbo.Personel()

create table Personel(
id int,
isim nvarchar(20),
soyisim nvarchar(20)
)

create trigger YeniPersonelEkleTrigger -- personel tablosuna ekleme yap�ld�ktan sonra tetiklenir.
on Personel
after insert 
as
begin
select 'Yeni Personel Eklendi!' --print yapar.
end

insert into Personel values(2,'Orkun','yk')

drop trigger YeniPersonelEkleTrigger

create trigger YeniPersonelGuncelleTrigger
on Personel
after update 
as
begin
select 'Yeni Personel G�ncellendi!' --print yapar.
end

create trigger YeniPersonelSilTrigger
on Personel
after delete 
as
begin
select 'Yeni Personel Silindi!' --print yapar.
end

update Personel set isim = 'fatih' where id=2

delete Personel where id=2

drop trigger YeniPersonelSilTrigger

alter trigger YeniPersonelEkleInsertedTrigger --Personel tablosuna ekleme yapt�ktan sonra eklenen kayd� g�sterir
on Personel
after insert 
as
begin
select *from inserted -- sanal bir tablo
end

insert into Personel values(2,'Orkun','yk')

create trigger YeniPersonelEkleDeletedTrigger --Personel tablosuna silme yapt�ktan sonra silinen kayd� g�sterir
on Personel
after delete 
as
begin
select *from deleted -- sanal bir tablo -- silme i�leminden sonra silineni g�sterir
end

delete Personel where id=2

create trigger YeniPersonelEkleUpdatedTrigger --Personel tablosuna g�ncelleme yapt�ktan sonra silinen ve yeni kayd� g�sterir
on Personel
after update -- update bir silme ve bir eklemeden olu�ur asl�nda. 
as
begin
select *from deleted 
select *from inserted 
end

update Personel set isim='Fatih' where id=2

create trigger MusteriYasSinirKontrol
on Musteri
for insert  -- insert i�leminden �nce tetiklenir.
as
begin 
if exists (select *from inserted where yas < 20) -- eklenen kay�t�n ya�� 20 den k���k m�? -- exists soru soran yap�d�r.
begin
raiserror('Musteri yas siniri 20dir',1,1)
rollback transaction -- kaydetme i�lemini iptal eder.
return 
end
end

insert into Musteri values(10,'Murat','atilla','afdas.fas@com','5.5.2004','35')

insert into Musteri values(11,'hakan','can','afdaddsas.fas@com','5.5.2004','19')

-- Daha �ok after triggerlar kullan�l�rlar.

