-- 1. Product isimlerini (`ProductName`) 
--ve birim başına miktar (`QuantityPerUnit`) değerlerini almak için sorgu yazın.
select product_name, quantity_per_unit from products; 

--2. Ürün Numaralarını (`ProductID`) ve Product isimlerini (`ProductName`) değerlerini almak için sorgu yazın. 
--Artık satılmayan ürünleri (`Discontinued`) filtreleyiniz.
select product_id, product_name, discontinued from products where discontinued = 1

--3. Durdurulan Ürün Listesini, Ürün kimliği ve ismi (`ProductID`, `ProductName`) 
--değerleriyle almak için bir sorgu yazın.
select product_id, product_name, discontinued from products where discontinued = 0

--4. Ürünlerin maliyeti 20'dan az olan Ürün listesini (`ProductID`, `ProductName`, `UnitPrice`) 
--almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price <20

--5. Ürünlerin maliyetinin 15 ile 25 arasında olduğu Ürün listesini 
--(`ProductID`, `ProductName`, `UnitPrice`) almak için bir sorgu yazın.
select product_id, product_name, unit_price from products where unit_price >15 AND unit_price <25

--6. Ürün listesinin (`ProductName`, `UnitsOnOrder`, `UnitsInStock`) 
--stoğun siparişteki miktardan az olduğunu almak için bir sorgu yazın.
select product_name, units_on_order, units_in_stock from products where units_in_stock < units_on_order

--7. İsmi `a` ile başlayan ürünleri listeleyeniz.
select * from products where product_name LIKE 'A%'

--8. İsmi `i` ile biten ürünleri listeleyeniz.
select * from products where product_name LIKE '%i'

--9. Ürün birim fiyatlarına %18’lik KDV ekleyerek listesini almak
--(ProductName, UnitPrice, UnitPriceKDV) için bir sorgu yazın.
select product_name , unit_price, (unit_price * 1.18) as unit_price_kdv from products

--10. Fiyatı 30 dan büyük kaç ürün var?
select COUNT(unit_price) from products where unit_price >30

--11. Ürünlerin adını tamamen küçültüp fiyat sırasına göre tersten listele
Select LOWER(product_name), unit_price from products order by unit_price DESC

--12. Çalışanların ad ve soyadlarını yanyana gelecek şekilde yazdır
Select first_name || ' ' || last_name as AdSoyad from employees

--13. Region alanı NULL olan kaç tedarikçim var?
Select COUNT(*) from suppliers where region is null

--14. a.Null olmayanlar?
Select COUNT(*) from suppliers where region is not null

--15. Ürün adlarının hepsinin soluna TR koy ve büyültüp olarak ekrana yazdır.
select concat('TR', UPPER(product_name)) from products 

--16. a.Fiyatı 20den küçük ürünlerin adının başına TR ekle
select concat('TR', UPPER(product_name)) from products where unit_price <20

--17. En pahalı ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products where unit_price = (select MAX(unit_price) from products)

--18. En pahalı on ürünün Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products order by unit_price DESC LIMIT 10

--19. Ürünlerin ortalama fiyatının üzerindeki Ürün listesini (`ProductName` , `UnitPrice`) almak için bir sorgu yazın.
select product_name, unit_price from products where unit_price > (select avg(unit_price) from products)

--20. Stokta olan ürünler satıldığında elde edilen miktar ne kadardır.
select sum(unit_price) from products where units_in_stock > 0

--21. Mevcut ve Durdurulan ürünlerin sayılarını almak için bir sorgu yazın.
select COUNT(product_id) from products where units_in_stock > 0 and discontinued = 1

--22. Ürünleri kategori isimleriyle birlikte almak için bir sorgu yazın.
SELECT product_id, product_name, category_name
FROM products
FULL JOIN categories ON products.category_id = categories.category_id

--23. Ürünlerin kategorilerine göre fiyat ortalamasını almak için bir sorgu yazın.
select category_name, avg(unit_price) from products 
right join categories on products.category_id = categories.category_id group by category_name

--24. En pahalı ürünümün adı, fiyatı ve kategorisin adı nedir?
select product_name, category_name, unit_price from products 
left join categories on categories.category_id = products.product_id order by unit_price desc limit 1

--25. En çok satılan ürününün adı, kategorisinin adı ve tedarikçisinin adı
select product_name, category_name, company_name, units_on_order from products 
left join categories on categories.category_id = products.product_id 
left join suppliers on suppliers.supplier_id = products.supplier_id order by units_on_order desc limit 1





