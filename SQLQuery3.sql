create table Musteri
(
ID int primary key,
Isim nvarchar(30),
Soyisim nvarchar(30),
EmailAdres nvarchar(60) default 'info@abc.com',
OlusturmaTarih datetime default getdate() -- Tabloya veri eklerken bunu hi� istememize gerek yok. Kendisi �u an� atas�n.
)

create table MusteriGirisBilgileri
(
MID int primary key, 
KullaniciAdi nvarchar(30) unique not null,
Sifre nvarchar(10) check(Len(Sifre)>6),
GizliSoru nvarchar(40),
Cevap nvarchar(40)
foreign key (MID) references Musteri(ID)
)

create table Urun 
(
UrunID int primary key,
Tanim nvarchar(50) not null,
Adet int check(Adet>0)
)

create table Satis
(
ID int primary key,
MID int not null,
UID int not null , 
SatilanAdet int check(SatilanAdet>0)
)

-- create proc 
create procedure SP_Musteri_YeniKayit
(
@ID int,
@Isim nvarchar(30),
@Soyisim nvarchar(30),
@EmailAdres nvarchar(60),
@KullaniciAdi nvarchar(30),
@Sifre nvarchar(10),
@GizliSoru nvarchar(40),
@Cevap nvarchar(40)
)
as
begin -- C# daki s�sl� parantezler burada -> begin-end tir.
insert into Musteri (ID,Isim,Soyisim,EmailAdres) values (@ID,@Isim,@Soyisim,@EmailAdres)
	if(@@rowcount>0)  -- Etkilenen kay�t say�s� s�f�rdan b�y�k ise
	begin
		insert into MusteriGirisBilgileri (MID,KullaniciAdi,Sifre,GizliSoru,Cevap) values (@ID,@KullaniciAdi,@Sifre,@GizliSoru,@Cevap)
	end

end

create proc SP_Urun_YeniKayit
(
@UrunID int,
@Tanim nvarchar(50),
@Adet int
)
as
begin
insert into Urun (UrunID,Tanim,Adet) values (@UrunID,@Tanim,@Adet)
end

go

create proc SP_Urun_KayitDuzenle
(
@UrunID int,
@Tanim nvarchar(50),
@Adet int
)
as
begin
update Urun set Tanim = @Tanim , Adet = @Adet where UrunID = @UrunID
end

go

create proc SP_Urun_KayitSil
(
@UrunID int
)
as
begin
delete Urun where UrunID = @UrunID
end

go

create proc SP_UrunListe
as
begin
select * from Urun
end

go

create proc SP_Urun_TekKayitListe
(
@UrunID int
)
as
begin
select * from Urun where UrunId = @UrunID
end


create table Satis
(
ID int primary key,
MID int not null,
UID int not null , 
SatilanAdet int check(SatilanAdet>0)
)

create proc SP_Satis_YeniKayit
(
@ID int,
@MID int,
@UID int,
@SatilanAdet int
)
as
begin
insert into Satis (ID,MID,UID,SatilanAdet) values (@ID,@MID,@UID,@SatilanAdet)
end

create proc SP_Satis_KayitDuzenle
(
@ID int,
@MID int,
@UID int,
@SatilanAdet int
)
as
begin
update Satis 
set 
MID = @MID,
UID = @UID,
SatilanAdet = @SatilanAdet
where 
ID = @ID
end

create proc SP_Satis_KayitSil
(
@ID int
)
with encryption  -- procedure'yi �ifreler. Sa� t�klay�p art�k modify 'a gidemeyiz.�nemli. TSQL kodlar� yedeklenmeli bu y�zden.
as
begin
delete Satis where ID = @ID
end





