
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

3. **Exploratory Data Analysis** 
analisa dilakukan setelah data bersih untuk mencari tahu performa bisnis, sebelumnya analisa deskriptif terhadap kategori dilakukan di python dengan memperhatikan standar pemusatan data yang bisa dilihat di link google colab di bagian berikutnya
<img width="635" height="335" alt="image" src="https://github.com/user-attachments/assets/fb338d2a-3898-454e-ae46-e5c9f2cb2d7f" />

## Python code analysis :
https://colab.research.google.com/drive/19u531o6mT7cvRKiBARjPaqGwen_ARbA2?usp=sharing

### Live Interactive Dashboard : 

https://datastudio.google.com/reporting/2dcca930-3309-4e00-b079-85f1278162c7

## Preview Dashboard
<img width="993" height="731" alt="image" src="https://github.com/user-attachments/assets/d7af7507-7bfc-42b7-a12d-b91b0dc4480a" />

## Key Insights (Temuan Utama)
* **Insight 1:** Terdapat pertumbuhan aggregat yang sehat dimana kenaikan volume penjualan (+16,9% Quantity) selaras dengan laju pertumbuhan pendapatan (+25,0% Revenue) dan berhasil menekan kenaikan biaya pengadaan (7.3%) dibawah laju pertumbuhan pendapatan, hal ini menunjukkan juga perusahaan berhasil menciptakan pertumbuhan yang efisien dimana pertumbuhan revenue lebih tinggi daripada pertumbuhan kuantitas penjualan ini menunjukkan efektifitas pertumbuhan volume penjualan dalam meningkatkan revenue perusahaan, rasio margin terhadap pendapatan juga meningkat 8% hal ini menunjukkan peningkatan efisiensi pengadaan barang oleh perusahaan.
* **Insight 2:** **Electronic** dan **Gaming Gear**, kedua kategori ini memiliki **kuantitas penjualan yang paling rendah** sedangkan **proporsi biayanya yang paling tinggi** dibandingkan dengan marginnya diantara kategori lainnya, namun jika diperhatikan lebih Electronic menjadi kategori yang menyumbang margin teratas menjadikannya produk **low volume high margin**, Di sisi lain, Gaming Gear bernasib kontras. Rasio marginnya sama-sama tipis dan kuantitasnya sama-sama rendah, tetapi nominal marginnya terpuruk di peringkat ke-5
* **insight 3:**  Kategori Electroning memang sebagai kontributor margin teratas, kuantitasnya yang sedikit bisa diartikan setiap kuantitasnya memiliki rata rata kontribusi margin yang besar, hal ini menandakan efisiensi penjualan di kategori ini, namun jika melihat dari skala makro dimana kontribusi kategori kategori yang lain hanya setengah dari kontribusi kategori electronic, hal ini menandakan kategori bisnis bergantung sekali dengan elektronik yang kuantitas penjualannya yang rendah, artinya **jika ada perubahan di pasar yang mempengaruhi sektor elektronik seperti kelangkaan chip yang diimpor dari taiwan dan china, atau pergeseran demand masyarakat, profil pendapatan bisnis akan terguncang signifikan**, hal ini menuntut strategi dukungan kategori lain untuk menjadi kontributor besar bagi margin perusahaan untuk manajemen resiko dan strategi penguatan sektor elektronik agar lebih resilien terhadap potensi guncangan pasar kedepannya
* **insight 4:** Gaming Gear Sebagai kategori dengan performa terlemah memiliki produk Game controller dan Gaming Monitor di memiliki kontribusi margin terendah (34% - 37%) dibandingkan produk lainnya
* **insight 5:** Terdapat Anomali di jajaran produk bermargin tinggi dimana kategori **Books & Stationary** memiliki **kontribusi margin tertinggi** namun dengan **kuantitas penjualan** yang **relatif rendah** dibandinngkn produk bermargin tinggi lainnya, hal ini bisa mengindikasikan penetapan margin yang terlalu tinggi sehingga harga terlalu mahal dibandingkan kompetitor lainnya 
*  **insight 6 :** adanya pelemahan (downward trend) pada kategori **Books & stationary** sepanjang periode 2024 dimana **indeks kuantitas menyusut 16%** menandakan indikasi pelemahan penjualan yang kemudian berimbas di **total revenue turun 17%**, dan **penyusutan margin 2.4%**. terjadi juga **lonjakan indeks COGS sebesar 5,1%** dimana ini menandakan indikasi inefisiensi operasional, perhatian diperlukan untuk kategori ini karena ini menandakan potensi yang belum digapai
  
