--26. Stokta bulunmayan ürünlerin ürün listesiyle birlikte tedarikçilerin ismi ve iletişim numarasını 
--(`ProductID`, `ProductName`, `CompanyName`, `Phone`) almak için bir sorgu yazın.
select p.product_id, p.product_name, s.company_name, s.phone from products p
inner join suppliers s on s.supplier_id = p.supplier_id
where units_in_stock = 0;

--27. 1998 yılı mart ayındaki siparişlerimin adresi, siparişi alan çalışanın adı, çalışanın soyadı
select ship_address, e.first_name || ' ' || e.last_name as first_last_name from orders o
inner join employees e on e.employee_id = o.employee_id
where extract(month from order_date) = 03 and extract(year from order_date) = 1998

--28. 1997 yılı şubat ayında kaç siparişim var?
select Count(order_id) from orders
--where order_date between '1997-02-01' and '1997-02-28'
where extract(month from order_date) = 02 and extract(year from order_date) = 1997

--29. London şehrinden 1998 yılında kaç siparişim var?
select Count(order_id),order_date from orders
where extract(year from order_date) = 1998 and ship_city = 'London'
group by order_date

--30. 1997 yılında sipariş veren müşterilerimin contactname ve telefon numarası
select distinct(contact_name), phone from customers c
inner join orders o on o.customer_id = c.customer_id
where extract(year from order_date) = 1997

--31. Taşıma ücreti 40 üzeri olan siparişlerim
select * from orders
where freight > 40

--32. Taşıma ücreti 40 ve üzeri olan siparişlerimin şehri, müşterisinin adı
select company_name, contact_name, ship_city from orders o
inner join customers c on c.customer_id = o.customer_id
where freight >= 40

--33. 1997 yılında verilen siparişlerin tarihi, şehri, çalışan adı -soyadı ( ad soyad birleşik olacak ve büyük harf),
select order_date, ship_city, first_name || ' ' || last_name  as FirstName_LastName from orders o
inner join employees e on e.employee_id = o.employee_id
where extract(year from order_date) = 1997

--34. 1997 yılında sipariş veren müşterilerin contactname i, ve telefon numaraları ( telefon formatı 2223322 gibi olmalı )
select distinct contact_name, phone from customers c
inner join orders o on o.customer_id = c.customer_id
where extract(year from order_date) = 1997

--35. Sipariş tarihi, müşteri contact name, çalışan ad, çalışan soyad
select order_date, contact_name, first_name, last_name from customers c
inner join orders o on o.customer_id = c.customer_id
inner join employees e on e.employee_id = o.employee_id
where extract(year from order_date) = 1997

--36. Geciken siparişlerim?
select * from orders
where required_date < shipped_date

--37. Geciken siparişlerimin tarihi, müşterisinin adı
select order_date, company_name, contact_name from orders o
inner join customers c on c.customer_id = o.customer_id
where required_date < shipped_date

--38. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select product_name, category_name, units_in_stock from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where order_id = '10248'

--39. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select product_name, s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join order_details od on od.product_id = p.product_id
where order_id = '10248'

--40. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select e.employee_id, product_name, units_on_order, order_date from orders o
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
inner join employees e on e.employee_id = o.employee_id
where e.employee_id = '3' and extract(year from order_date) = 1997 and units_on_order > 0

--41. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name, SUM(quantity*unit_price) as satis_miktari from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from order_date) = 1997
group by e.employee_id, e.first_name,e.last_name
order by satis_miktari desc limit 1

--42. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, e.first_name || ' ' || e.last_name, SUM(quantity*unit_price) as satis_miktari from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from order_date) = 1997
group by e.employee_id, e.first_name,e.last_name
order by satis_miktari desc limit 1

--43. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, p.unit_price, c.category_name from products p
inner join categories c on c.category_id = p.category_id
group by p.product_name, c.category_name, p.unit_price
order by p.unit_price desc limit 1

--44. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name as ad_soyad, o.order_date, o.order_id from employees e
inner join orders o on o.employee_id = e.employee_id
group by ad_soyad, o.order_date, o.order_id
order by o.order_date 

--45. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id, avg(od.unit_price*od.quantity) from orders o
inner join order_details od on od.order_id = o.order_id
group by o.order_id
order by o.order_date desc limit 5

--46. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity*od.unit_price) from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where extract(month from order_date) = 1
group by p.product_name, c.category_name

--47. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select order_id, (quantity*unit_price) as satis_miktari from order_details
where (quantity*unit_price) > (select avg(quantity*unit_price) from order_details)
group by order_id, satis_miktari

--48. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name, p.units_on_order from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
order by p.units_on_order desc limit 1

--49. Kaç ülkeden müşterim var
select count(distinct country) from customers
 
--50. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(quantity*unit_price) from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
where e.employee_id = 3 and o.order_date between '1998-01-01' and '2023-11-15'

--51. 10248 nolu siparişte satılan ürünlerin adı, kategorisinin adı, adedi
select p.product_name, c.category_name, p.units_on_order from order_details od
inner join products p on p.product_id = od.product_id
inner join categories c on c.category_id = p.category_id
where order_id = '10248'

--52. 10248 nolu siparişin ürünlerinin adı , tedarikçi adı
select p.product_name, s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id
inner join order_details od on od.product_id = p.product_id
where od.order_id = '10248'

--53. 3 numaralı ID ye sahip çalışanın 1997 yılında sattığı ürünlerin adı ve adeti
select p.product_name, p.units_on_order from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
where e.employee_id = 3 and extract(year from order_date) = 1997

--54. 1997 yılında bir defasinda en çok satış yapan çalışanımın ID,Ad soyad
select e.employee_id, e.first_name || ' ' || e.last_name, SUM(quantity*unit_price) as satis_miktari from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from order_date) = 1997
group by e.employee_id, e.first_name,e.last_name
order by satis_miktari desc limit 1

--55. 1997 yılında en çok satış yapan çalışanımın ID,Ad soyad ****
select e.employee_id, e.first_name || ' ' || e.last_name, SUM(quantity*unit_price) as satis_miktari from employees e
inner join orders o on e.employee_id = o.employee_id
inner join order_details od on o.order_id = od.order_id
where extract(year from order_date) = 1997
group by e.employee_id, e.first_name,e.last_name
order by satis_miktari desc limit 1

--56. En pahalı ürünümün adı,fiyatı ve kategorisin adı nedir?
select p.product_name, c.category_name, p.unit_price from products p
inner join categories c on c.category_id = p.category_id
order by p.unit_price desc limit 1

--57. Siparişi alan personelin adı,soyadı, sipariş tarihi, sipariş ID. Sıralama sipariş tarihine göre
select e.first_name || ' ' || e.last_name as ad_soyad, o.order_date, o.order_id from employees e
inner join orders o on o.employee_id = e.employee_id
group by ad_soyad, o.order_date, o.order_id
order by o.order_date 

--58. SON 5 siparişimin ortalama fiyatı ve orderid nedir?
select o.order_id, avg(od.unit_price*od.quantity) from orders o
inner join order_details od on od.order_id = o.order_id
group by o.order_id
order by o.order_date desc limit 5

--59. Ocak ayında satılan ürünlerimin adı ve kategorisinin adı ve toplam satış miktarı nedir?
select p.product_name, c.category_name, sum(od.quantity*od.unit_price) from products p
inner join categories c on c.category_id = p.category_id
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where extract(month from order_date) = 1
group by p.product_name, c.category_name

--60. Ortalama satış miktarımın üzerindeki satışlarım nelerdir?
select order_id, (quantity*unit_price) as satis_miktari from order_details
where (quantity*unit_price) > (select avg(quantity*unit_price) from order_details)
group by order_id, satis_miktari

--61. En çok satılan ürünümün(adet bazında) adı, kategorisinin adı ve tedarikçisinin adı
select p.product_name, c.category_name, s.company_name, p.units_on_order from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id
order by p.units_on_order desc limit 1

--62. Kaç ülkeden müşterim var
select count(distinct country) from customers

--63. Hangi ülkeden kaç müşterimiz var
select count(distinct customer_id), country from customers
group by country

--64. 3 numaralı ID ye sahip çalışan (employee) son Ocak ayından BUGÜNE toplamda ne kadarlık ürün sattı?
select sum(quantity*unit_price) from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
where e.employee_id = 3 and o.order_date between '1998-01-01' and '2023-11-15'

--65. 10 numaralı ID ye sahip ürünümden son 3 ayda ne kadarlık ciro sağladım?
select SUM(od.quantity * p.unit_price) from products p
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
where p.product_id = 10 AND o.order_date >= CURRENT_DATE - INTERVAL '3 months'

--66. Hangi çalışan şimdiye kadar toplam kaç sipariş almış..?
select e.first_name || ' ' || e.last_name as ad_soyad, sum(p.units_on_order) as toplam_siparis from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
group by ad_soyad

--67. 91 müşterim var. Sadece 89’u sipariş vermiş. Sipariş vermeyen 2 kişiyi bulun
select customer_id from customers
where customer_id not in (select customer_id from orders)

--68. Brazil’de bulunan müşterilerin Şirket Adı, TemsilciAdi, Adres, Şehir, Ülke bilgileri
select company_name, contact_name, address, city, country from customers
where country = 'Brazil'

--69. Brezilya’da olmayan müşteriler
select company_name, contact_name, address, city, country from customers
where not country = 'Brazil'

--70. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers
where country in ('Spain', 'France', 'Germany')

--71. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

--72. Londra’da ya da Paris’de bulunan müşterilerim
select * from customers
where city in ('London', 'Paris')

--73. Hem Mexico D.F’da ikamet eden HEM DE ContactTitle bilgisi ‘owner’ olan müşteriler
select * from customers
where city = 'México D.F.' and contact_title = 'Owner'

--74. C ile başlayan ürünlerimin isimleri ve fiyatları
select product_name, unit_price from products
where product_name like 'C%'

--75. Adı (FirstName) ‘A’ harfiyle başlayan çalışanların (Employees); Ad, Soyad ve Doğum Tarihleri
select first_name || ' ' || last_name as ad_soyad, birth_date from employees
where first_name like 'A%'

--76. İsminde ‘RESTAURANT’ geçen müşterilerimin şirket adları
select company_name from customers
where company_name like '%Restaurant%'

--77. 50$ ile 100$ arasında bulunan tüm ürünlerin adları ve fiyatları
select product_name, unit_price from products
where unit_price between 50 and 100

--78. 1 temmuz 1996 ile 31 Aralık 1996 tarihleri arasındaki siparişlerin (Orders), SiparişID (OrderID) 
--ve SiparişTarihi (OrderDate) bilgileri
select order_id, order_date from orders
where order_date between '1996-07-01' and '1996-12-31'

--79. Ülkesi (Country) YA Spain, Ya France, Ya da Germany olan müşteriler
select company_name, contact_name, address, city, country from customers
where country in ('Spain', 'France', 'Germany')

--80. Faks numarasını bilmediğim müşteriler
select * from customers
where fax is null

--81. Müşterilerimi ülkeye göre sıralıyorum:
select customer_id, company_name, country from customers
order by country

--82. Ürünlerimi en pahalıdan en ucuza doğru sıralama, sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price from products
order by unit_price desc

--83. Ürünlerimi en pahalıdan en ucuza doğru sıralasın, ama stoklarını küçükten-büyüğe doğru göstersin 
--sonuç olarak ürün adı ve fiyatını istiyoruz
select product_name, unit_price, units_in_stock from products
order by unit_price desc, units_in_stock asc

--84. 1 Numaralı kategoride kaç ürün vardır..?
select count(product_id) from products
where category_id = 1

--85. Kaç farklı ülkeye ihracat yapıyorum..?
select count(distinct ship_country) from orders
