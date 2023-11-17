--86. a.Bu ülkeler hangileri..?
select distinct ship_country from orders

--87. En Pahalı 5 ürün
select * from products
order by unit_price desc limit 5

--88. ALFKI CustomerID’sine sahip müşterimin sipariş sayısı..?
select o.order_id from customers c
inner join orders o on o.customer_id = c.customer_id
where c.customer_id = 'ALFKI'

--89. Ürünlerimin toplam maliyeti
select  sum(od.quantity * od.unit_price) AS toplammaliyet, p.product_id, product_name from order_details od 
inner join products p on p.product_id=od.product_id
group by p.product_id, product_name

--90. Şirketim, şimdiye kadar ne kadar ciro yapmış..?
select sum(quantity * unit_price) AS toplamciro
from order_details

--91. Ortalama Ürün Fiyatım
select avg(unit_price) from products

--92. En Pahalı Ürünün Adı
select product_name, unit_price from products
order by unit_price desc limit 1

--93. En az kazandıran sipariş
select order_id, (unit_price*quantity) as siparis_tutari from order_details
order by (unit_price*quantity) limit 1

--94. Müşterilerimin içinde en uzun isimli müşteri
select company_name, length(company_name) from customers
order by length(company_name) desc limit 1

--95. Çalışanlarımın Ad, Soyad ve Yaşları
select first_name || ' ' || last_name as ad_soyad, EXTRACT(YEAR FROM age(NOW(), birth_date)) as Yas from employees

--96. Hangi üründen toplam kaç adet alınmış..?
select product_name, count(units_on_order) from products
group by product_name

--97. Hangi siparişte toplam ne kadar kazanmışım..?
select od.order_id, sum(od.unit_price*od.quantity) from products p
inner join order_details od on od.product_id = p.product_id
inner join orders o on o.order_id = od.order_id
group by od.order_id

--98. Hangi kategoride toplam kaç adet ürün bulunuyor..?
select category_id, count(product_id) as toplam_urun from products
group by category_id

--99. 1000 Adetten fazla satılan ürünler?
select product_id, sum(quantity) totalsales from order_details
group by product_id
having sum(quantity) > 1000

--100. Hangi Müşterilerim hiç sipariş vermemiş..?
select c.company_name, p.units_on_order from customers c
inner join orders o on o.customer_id = c.customer_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
where p.units_on_order = 0
group by c.company_name, p.units_on_order

--101. Hangi tedarikçi hangi ürünü sağlıyor ?
select p.product_name, s.company_name from products p
inner join suppliers s on s.supplier_id = p.supplier_id

--102. Hangi sipariş hangi kargo şirketi ile ne zaman gönderilmiş..?
select order_id, shipped_date, ship_name from orders

--103. Hangi siparişi hangi müşteri verir..?
select o.order_id, c.company_name from orders o
inner join customers c on c.customer_id = o.customer_id

--104. Hangi çalışan, toplam kaç sipariş almış..?
select e.first_name || ' ' || e.last_name as calisan_ad_soyad, sum(p.units_on_order) from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
group by calisan_ad_soyad, p.units_on_order

--105. En fazla siparişi kim almış..?
select e.first_name || ' ' || e.last_name as calisan_ad_soyad, sum(p.units_on_order) as toplam_siparis from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
group by calisan_ad_soyad, p.units_on_order
order by toplam_siparis desc limit 1

--106. Hangi siparişi, hangi çalışan, hangi müşteri vermiştir..?
select o.order_id, e.first_name || ' ' || e.last_name as calisan_ad_soyad, c.company_name from employees e
inner join orders o on o.employee_id = e.employee_id
inner join order_details od on od.order_id = o.order_id
inner join products p on p.product_id = od.product_id
inner join customers c on c.customer_id = o.customer_id
group by o.order_id, calisan_ad_soyad, c.company_name

--107. Hangi ürün, hangi kategoride bulunmaktadır..? Bu ürünü kim tedarik etmektedir..?
select p.product_name, c.category_name, s.company_name from products p
inner join categories c on c.category_id = p.category_id
inner join suppliers s on s.supplier_id = p.supplier_id

--108. Hangi siparişi hangi müşteri vermiş, hangi çalışan almış, hangi tarihte,
-- hangi kargo şirketi tarafından gönderilmiş hangi üründen kaç adet alınmış, hangi fiyattan alınmış, 
-- ürün hangi kategorideymiş bu ürünü hangi tedarikçi sağlamış
select o.order_id, cu.customer_id, CONCAT(cu.contact_name, ' ', cu.contact_title), e.employee_id, CONCAT(e.first_name, ' ', e.last_name),  o.order_date, s.company_name,
       p.product_name,
       od.quantity,
       od.unit_price,
       c.category_name,
       sup.company_name FROM orders o
join customers cu on o.customer_id = cu.customer_id
join employees e on o.employee_id = e.employee_id
join shippers s on o.ship_via = s.shipper_id
join order_details od on o.order_id = od.order_id
join products p on od.product_id = p.product_id
join categories c on p.category_id = c.category_id
join suppliers sup on p.supplier_id = sup.supplier_id;

--109. Altında ürün bulunmayan kategoriler
select c.category_id, c.category_name from categories c
left join products p on p.category_id = c.category_id
where c.category_id is null

--110. Manager ünvanına sahip tüm müşterileri listeleyiniz.
select * from customers
where contact_title like '%Manager'

--111. FR ile başlayan 5 karekter olan tüm müşterileri listeleyiniz.
select * from customers
where company_name like 'Fr%'

--112. (171) alan kodlu telefon numarasına sahip müşterileri listeleyiniz.
select * from customers 
where phone like '(171)%'

--113. BirimdekiMiktar alanında boxes geçen tüm ürünleri listeleyiniz.
select * from products
where quantity_per_unit like '%boxes%'

--114. Fransa ve Almanyadaki (France,Germany) Müdürlerin (Manager) Adını ve Telefonunu listeleyiniz.(MusteriAdi,Telefon)
select company_name, contact_name, phone from customers
where country in ('France', 'Germany') and contact_title like '%Manager%'

--115. En yüksek birim fiyata sahip 10 ürünü listeleyiniz.
select * from products
order by unit_price desc limit 10

--116. Müşterileri ülke ve şehir bilgisine göre sıralayıp listeleyiniz.
select customer_id, city, country from customers

--117. Personellerin ad,soyad ve yaş bilgilerini listeleyiniz.
select first_name || ' ' || last_name as ad_soyad, EXTRACT(YEAR FROM age(NOW(), birth_date)) as Yas from employees

--118. 35 gün içinde sevk edilmeyen satışları listeleyiniz.
select * from orders
where shipped_date is null or (shipped_date - order_date) > 35

--119. Birim fiyatı en yüksek olan ürünün kategori adını listeleyiniz. (Alt Sorgu)
select c.category_name from products p
inner join categories c on c.category_id = p.category_id
order by p.unit_price desc limit 1

--120. Kategori adında 'on' geçen kategorilerin ürünlerini listeleyiniz. (Alt Sorgu)
select c.category_name, p.product_name from products p
inner join categories c on c.category_id = p.category_id
where c.category_name like '%on%'

--121. Konbu adlı üründen kaç adet satılmıştır.
select product_name, count(units_on_order) from products
where product_name = 'Konbu'
group by product_name

--122. Japonyadan kaç farklı ürün tedarik edilmektedir.
select count(p.product_id) from products p
inner join suppliers s on s.supplier_id = p.supplier_id
where country = 'Japan'

--123. 1997 yılında yapılmış satışların en yüksek, en düşük ve ortalama nakliye ücretlisi ne kadardır?
select max(freight) as maximum_fee, min(freight) as minimum_fee, avg(freight) as average_fee from orders
where extract(year from order_date) = 1997

--124. Faks numarası olan tüm müşterileri listeleyiniz.
select * from customers
where fax is not null

--125. 1996-07-16 ile 1996-07-30 arasında sevk edilen satışları listeleyiniz. 
select order_id, customer_id, order_date, shipped_date from orders
where shipped_date between '1996-07-16' and '1996-07-30'