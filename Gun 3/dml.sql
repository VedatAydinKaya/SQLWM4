-- DML 
-- INSERT INTO
-- DELETE
-- UPDATE

	
INSERT INTO Kategoriler (KategoriAdi,Aciklama)
Values ('Icecekler','Sıcak & soouk icecekler')

INSERT INTO Kategoriler (KategoriAdi,Aciklama)
Values ('Deniz urunleri','Sıcak & soouk deniz urunleri')

INSERT INTO Kategoriler (KategoriAdi,Aciklama)
Values ('Elektronik','Sıcak & soguk elektronik urunler')

use master
go
insert into ETicaret.dbo.Kategoriler (KategoriAdi,Aciklama)
select CategoryName,[Description] from Northwind.dbo.Categories

use Northwind
go

delete from Products

use ETicaret
go

--select * from Kategoriler
delete from Kategoriler 
where KategoriId = 8

select * from Kategoriler
update Kategoriler
set Aciklama = 'Sıcak soguk icecekler'
where KategoriId = 4

update Customers 
set Region ='Siparissiz'
where CustomerId IN (
	SELECT C.CustomerId
	FROM Customers C
	WHERE C.CustomerID NOT IN(
		SELECT DISTINCT O.CustomerID
		FROM ORDERS O 
	)
)

declare @kid int
select @kid=KategoriId from Kategoriler
where KategoriAdi = 'Icecekler'

insert into Urunler (UrunAdi,Fiyat,KategoriId,TedarikciId)
values ('Kola',10,@kid,NULL)

select * from Urunler

