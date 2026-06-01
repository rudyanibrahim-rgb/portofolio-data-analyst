
# Cost - revenue Analysis periode 2024

Proyek ini berusaha menganalisis data transaksi retail untuk menemukan tren penjualan dan wilayah dengan profitabilitas terendah menggunakan Python, SQL dan Looker Studio.

analisis berbentuk exploratory analysis yang diaplikasikan di setiap kategori untuk menemukan strong-weaknes spot di setiap kategori, lalu dilanjutkan dengan membedah data dengan granularitas lebih lanjut untuk lebih memetakan Point of Occurance dari permasalahannya  

## data sumber : 
- Order_detail (informasi lengkap pesanan yang masuk)
- Product_detail (data rincian informasi produk)
- Customer_detail (data rincian informasi Customer)
- Transaction_detail (informasi lengkap transaksi yang masuk)
- Payment_detail (informasi lengkap pembayaran masuk)
- Funnel_detail (informasi detail untuk tiap tingkat funnel marketing)
## Tahapan tahapan kerja analisa :
### Data extraction 
Proses ini menggunakan query SQL dengan melakukan operasi **"LEFT JOIN"** dengan "order_detail" sebagai data dasar dan data data lainnya  sebaghai data pelengkap, tak lupa menambahkan baris khusus operasi window function row_number untuk kebutuhan data cleaning selanjutnya

<img width="628" height="314" alt="image" src="https://github.com/user-attachments/assets/44c078cb-a061-41f9-be8e-f26332a4ec99" />

### Data Cleaning 
Proses ini adalah proses SQL heavy dan menggunakan sedikit kode python, pembersihan data mencakup pengecekan null values dan pendeteksian nilai duplikat, pendeteksian null values menggunakan query SQL  
1. **pengecekan duplicate values** : dilakukan dengan menjalankan query mencari baris yang memiliki nilai rn = 2, hasil query "select * from `Latihan.full_data_cleaned` where rn > 1" menunjukkan "no result" menandakan tidak ada baris data terduplikasi dalam artian semua data unique
2. **pengecekan null values** : secara visual terhadap beberapa data yang kosong hal ini dipastikan setelah menjalankan kode df.info() di python menunjukkan beberapa kolom kosong setelah itu saya menjalankan query seperti di gambar ini

   <img width="628" height="145" alt="image" src="https://github.com/user-attachments/assets/82a3708b-20e9-46b5-92b6-a5a833533546" />
setelah query diatas dijalankan semua kolom yang kosong tersebut memiliki null values lebih dari 50% (56%) hal ini menyebabkan ketidak akuratan analisis jika kolom kolom tersebut digunakan, maka dari sini kolom tersebut tidak digunakan untuk analisis lebih lanjut

## Analisa Deskriptive

## Live Interactive Dashboard : 

https://datastudio.google.com/reporting/2dcca930-3309-4e00-b079-85f1278162c7

## Python code analysis :
https://nbviewer.org/github/rudyanibrahim-rgb/portofolio-data-analyst/blob/main/Python%20Analysis.ipynb

## Preview Dashboard
<img width="1200" height="782" alt="image" src="https://github.com/user-attachments/assets/dfe5e4d1-d3ad-4fcc-bef9-a7ff6a02f80d" />



## Key Insights (Temuan Utama)
* **Insight 1:** Terdapat pertumbuhan aggregat yang sehat dimana kenaikan volume penjualan (+16,9% Quantity) selaras dengan laju pertumbuhan pendapatan (+25,0% Revenue), hal ini menunjukkan juga perusahaan berhasil menciptakan pertumbuhan yang efisien dimana pertumbuhan revenue lebih tinggi daripada pertumbuhan kuantitas penjualan.
* **Insight 2:** terdapat anomali pada kategori **Electronic** dan **Gaming Gear** dimana keduanya memiliki **kuantitas penjualan yang paling rendah** sedangkan **proporsi biayanya yang paling tinggi** dibandingkan dengan marginnya diantara kategori lainnya .
* **insight 3:** Game controller dan Gaming Monitor memiliki kontribusi margin terendah (34% - 37%) dibandingkan produk lainnya
* **insight 4:** Terdapat Anomali di jajaran produk bermargin tinggi dimana kategori **Books & Stationary** memiliki **kontribusi margin tertinggi** namun dengan **kuantitas penjualan** yang **relatif rendah** dibandinngkn produk bermargin tinggi lainnya
* **insight 5:** adanya pelemahan (downward trend) pada kategori **Books & stationary** sepanjang periode 2024 dimana **indeks kuantitas menyusut 16%** menandakan indikasi pelemahan penjualan yang kemudian berimbas di **total revenue turun 17%**, dan **penyusutan margin 2.4%**. terjadi juga **lonjakan indeks COGS sebesar 5,1%** dimana ini menandakan indikasi inefisiensi operasional, perhatian diperlukan untuk kategori ini karena ini menandakan potensi yang belum digapai
  
