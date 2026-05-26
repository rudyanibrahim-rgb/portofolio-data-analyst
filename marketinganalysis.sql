

select * from `Latihan.full_data_cleaned` where rn > 1; -- tidak ada data yang muncul tandanya tidak ada data duplikat

-- pengecekan null values sudah dilakukan di google colab (python)

select 
  round((count(case when channel_source is null then 1 end)/count(*))*100,2) as Null_perc,
  round((count(case when funnel_id is null then 1 end)/count(*))*100,2) as Website_perc,
  round((count(case when funnel_date is null then 1 end)/count(*))*100,2) as NonFunnel_perc,
  round((count(case when status is null then 1 end)/count(*))*100,2) as Appstore_perc,
  round((count(case when event is null then 1 end)/count(*))*100,2) as event_perc
from `Latihan.Full_data`; --beberapa kolom memiliki null values 56% ini adlaah jumlah signifikan untuk null values perlu manipulasi data maka kita tidak menggunakan kolom ini menjadi dasar analisis

select * from `Latihan.full_data_cleaned`; --data setelah dimanipulasi di python untuk memudahkan analisa lebih lanjut

-- kolom channel source tidak kredibel untuk dianalisis sehingga kita berpindah menggunakan kolom channel type

-- analisa funnel dan performa marketing
select 
  count(case when status is null then 1 else null end)/count(*) as null_percentage
from `Latihan.full_data_cleaned`; -- null values menguasai 56% dari	 data di status sehingga 

with f as (
  select 
    count(case when status = 'Click' then 1 end) as c,
    count(case when status = 'Viewed' then 1 end) as V,
    count(case when status = 'Add to Cart' then 1 end) as atc,
    count(case when status = 'Purchase' then 1 end) as p,
  from `Latihan.funnel_detail_cleaned`)
  select
    round((c+v+atc+p)/(c+v+atc+p)*100,2) as click,
    round(((v+atc+p)/(c+v+atc+p))*100,2) as Viewperc,
    round(((atc+p)/(v+atc+p))*100,2) as addtocartperc,
    round((p/(atc+p))*100,2) as purchperc
  from f; -- mencari convertion rate di funnel
          -- convertion rate terus menurun di setiap corongnya
--kolom berbentuk horizontal tidak bisa dianalisis menjadi convertion rate sehingga saya melakukan transpose menggunakan python

select 
  * 
from `Latihan.convertion_rate`; -- kolom convertion rate setelah ditranspose di python


select 
  customer_name,
  customer_id,
  max(transaction_date) as last_date,
  count(transaction_id) as count_trans,
  sum(after_discount) as volume
from `Latihan.full_data_cleaned`
where is_net = 1 
group by customer_name,customer_id
order by count(transaction_id) desc ,sum(after_discount) desc
limit  100; -- 100 pelaanggan dengan nilai dan frekuensi tertinggi

select 
  customer_name,
  customer_id,
  max(transaction_date) as last_date,
  count(transaction_id) as count_trans,
  sum(after_discount) as volume
from `Latihan.full_data_cleaned`
where is_net = 1 
group by customer_name,customer_id
order by count(transaction_id) asc ,sum(after_discount) asc
limit 100; --100 pelanggan dengan pembelian terendah

--Cost-margin Analysis

select 
  category,
  sum(quantity) as quantity,
  round(((sum(after_discount)-sum(cogs))/sum(after_discount))*100,2) as margin_percentage
from `Latihan.full_data_cleaned`
where is_net = 1
group by category
order by 3 desc; -- mencari mana kategori yang marginnya paling tinggi dan mana yang marginnya janggal terhadap quantitynya

select 
  product,
  ((sum(after_discount)-sum(cogs))/sum(after_discount))*100 as gross_profit_margin,
  (sum(cogs)/sum(after_discount))*100 as cogs_comp
from `Latihan.full_data_cleaned`
where category = 'Gaming Gear'
group by product
order by 2 asc; -- mencari produk dengan struktur biayanya


-- melakukan analisa resensi pelanggan, retensi, dan volume transaksi pelanggan (RFM )

select
  customer_name,
  case when recency_rank = 1 then 'most recent'
       when recency_rank = 2 then 'recent'
       when recency_rank = 3 then 'not recent'
       when recency_rank = 4 then 'past'
       when recency_rank = 5 then 'very past'
       end as recency_status,--memberikan label status kepada setiap data berdasarkan poin recencynya
  case when freq_rank = 1 then 'very High'
       when freq_rank = 2 then 'High'
       when freq_rank = 3 then 'medium'
       when freq_rank = 4 then 'Low'
       when freq_rank = 5 then 'very Low'
       end as freq_status, --memberikan label status kepada setiap data berdasarkan poin frequencynya
  case when volume_rank = 1 then 'very High'
       when volume_rank = 2 then 'High'
       when volume_rank = 3 then 'medium'
       when volume_rank = 4 then 'Low'
       when volume_rank = 5 then 'very Low'
      end as volume_status --memberikan label status kepada setiap data berdasarkan poin volumenya
from(
with rfm as (
  select 
    customer_name,
    date_diff(current_date(),date(max(order_date)),day) as recency_value,--menghitung jarak hari ini dengan pembelian terakhir custoomer
    count(distinct transaction_id) as freq_order, -- menghitung transaksi yang dijalankan customer
    sum(after_discount) as volume --menghitung volume transaksi setiap customer
  from `Latihan.full_data_cleaned`
  where is_net = 1 and is_valid = 1
  group by customer_name --dengan menngunakan cte, saya membuat dasar analisa RFM 
)
select
  *,
  ntile(5) over(order by rfm.recency_value asc) as recency_rank,
  ntile(5) over(order by rfm.freq_order desc) as freq_rank,
  ntile(5) over(order by rfm.volume desc) as volume_rank
from rfm -- membagi setiap data menjadi 5 kuatil
) as rfm_rank
