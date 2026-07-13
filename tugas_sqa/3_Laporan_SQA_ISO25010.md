# LAPORAN QUALITY ASSURANCE (QA)
Capstone Project QA – Program Studi Teknik Informatika
Universitas Harkat Negeri

## 1. Identitas Proyek
* **Nama Aplikasi**: Edutech
* **Tim Pengembang**: Kelompok Capstone (AryaFahrezi11 dkk)
* **Nama Mahasiswa**: [NAMA ANDA DI SINI]
* **Dosen Pembimbing**: [NAMA DOSEN PEMBIMBING DI SINI]
* **Tanggal Uji**: 12 Juli 2026

## 2. Deskripsi Sistem yang Diuji
Aplikasi Edutech adalah sebuah platform edukasi interaktif berbasis *mobile* yang dikembangkan menggunakan *framework* Flutter untuk menunjang proses pembelajaran secara digital. Aplikasi ini dirancang untuk menggabungkan metode pembelajaran dasar (membaca, menulis, dan mengeja) dengan teknologi kecerdasan buatan, sehingga menciptakan pengalaman belajar yang *gamified* (menyenangkan layaknya bermain *game*) dan interaktif. 

Secara teknis, Edutech mengintegrasikan model *Machine Learning* (*Computer Vision*) pada fiturnya untuk mendeteksi dan mengenali objek di dunia nyata secara *real-time* melalui tangkapan kamera ponsel. Selain itu, aplikasi ini memanfaatkan *Generative AI* (melalui integrasi Gemini API) sebagai asisten penilai pintar yang mampu memberikan umpan balik (*feedback*) dan evaluasi otomatis pada hasil ujian siswa. Untuk menjaga motivasi belajar, Edutech juga menyediakan ekosistem kompetitif melalui fitur *Game Multiplayer* secara langsung (*real-time*) dan papan peringkat (*Leaderboard*) yang direkap secara komprehensif di dalam fitur Raport pengguna.

Fungsionalitas utama dari aplikasi ini mencakup:
* Halaman Login & Register
* Halaman Latihan & Ujian Menulis Huruf & Kata
* Halaman Mengeja Huruf & Kata
* Halaman Deteksi Benda & Ujian Deteksi Benda
* Halaman Menebak Benda Sekitar
* Halaman Game Multiplayer & Leaderboard
* Halaman Profil (Edit Profil, Raport, Log Aktifitas, Pengaturan)

## 3. Tujuan dan Ruang Lingkup Pengujian
Tujuan utama dari kegiatan *Quality Assurance* (QA) ini adalah untuk memvalidasi dan memverifikasi kelayakan operasional aplikasi Edutech sebelum didistribusikan kepada pengguna akhir. Pengujian ini difokuskan untuk memastikan bahwa seluruh modul pembelajaran cerdas, seperti evaluasi otomatis berbasis AI dan deteksi objek, berfungsi dengan tingkat keandalan yang tinggi dan terbebas dari kecacatan fatal (*zero critical bugs*). Selain itu, QA ini juga bertujuan untuk menyelaraskan kualitas aplikasi dengan standar metrik perangkat lunak internasional (ISO/IEC 25010), khususnya dalam hal menjaga performa dan kenyamanan pengalaman belajar (*User Experience*) anak.

Adapun ruang lingkup pengujian (*Scope of Testing*) dibatasi secara spesifik pada fungsionalitas seluruh fitur utama aplikasi (sebagaimana dijabarkan pada poin 2). Proses validasi dilakukan secara komprehensif menggunakan pendekatan *End-to-End* (E2E) *Testing*. Cakupan pengujian ini meliputi interaksi antarmuka pengguna (UI) pada sistem operasi Android (*Mobile Testing*), observasi beban memori saat menjalankan model *Machine Learning*, hingga uji stabilitas pertukaran data (*payload*) antara aplikasi *client* dengan arsitektur *backend* (*Web Service / API Testing*).

## 4. Karakteristik ISO/IEC 25010 yang Diuji
Dalam pelaksanaan *Quality Assurance* ini, parameter pengujian merujuk pada model kualitas perangkat lunak ISO/IEC 25010. Dipilih 4 (empat) karakteristik utama yang dinilai paling relevan dan esensial terhadap arsitektur serta tujuan bisnis dari aplikasi Edutech. Berikut adalah alasan pemilihannya:

1. **Functional Suitability (Kesesuaian Fungsional):** 
Karakteristik ini dipilih untuk memvalidasi tingkat kelengkapan, kebenaran, dan ketepatan fungsional aplikasi. Mengingat Edutech adalah *platform* edukasi, sangat krusial untuk memastikan bahwa alur logika inti—seperti autentikasi pengguna, sinkronisasi *Leaderboard*, hingga validasi jawaban pada menu latihan dan ujian—dapat mengeksekusi *input* pengguna secara presisi dan mengembalikan *output* yang terverifikasi benar tanpa adanya *logic error*.

2. **Performance Efficiency (Efisiensi Kinerja):** 
Dipilih sebagai fokus utama karena aplikasi Edutech mengandalkan pemrosesan komputasi berat (*Computer Vision* untuk deteksi objek) secara *real-time* dan melakukan *request* eksternal ke *Generative AI* (Gemini). Pengujian pada aspek ini bertujuan untuk mengukur tingkat responsivitas UI, efisiensi penggunaan sumber daya memori (RAM/CPU) pada perangkat *mobile*, serta durasi latensi (*delay*) saat terjadi pertukaran data, guna mencegah terjadinya *frame drop* atau hambatan performa yang signifikan.

3. **Reliability (Keandalan):** 
Karakteristik keandalan (*Reliability*) diuji untuk mengukur sejauh mana aplikasi mampu mempertahankan tingkat kinerjanya di bawah kondisi yang tidak ideal (*stress condition*). Hal ini meliputi pengujian toleransi kesalahan (*Fault Tolerance*) ketika terjadi penumpukan *cache* memori kamera, putusnya koneksi secara tiba-tiba saat mode *Multiplayer*, atau ketika *backend API* lambat merespon. Tujuannya adalah untuk memastikan aplikasi memiliki mekanisme pemulihan yang baik dan meminimalisir potensi *Force Close* (*Crash*).

4. **Usability (Kebergunaan):** 
Mengingat target pengguna utama aplikasi ini adalah siswa atau anak-anak dalam masa belajar, aspek *Usability* sangat penting untuk dievaluasi. Pengujian ini difokuskan pada tingkat kemudahan dipelajari (*Learnability*) dan operabilitas antarmuka. Evaluasi mencakup kejelasan hierarki navigasi antar menu (Latihan, Raport, Pengaturan), kejelasan instruksi visual, serta memastikan bahwa desain *gamifikasi* dapat dioperasikan secara intuitif tanpa menimbulkan kebingungan bagi pengguna awam.

## 5. Metodologi Pengujian
Pelaksanaan *Quality Assurance* pada aplikasi Edutech ini mengkombinasikan dua metodologi pengujian utama guna mencapai cakupan tes (*test coverage*) yang komprehensif, yaitu:

1. **Automated Testing (Pengujian Otomatis):** 
Metode ini diterapkan untuk memvalidasi fungsionalitas inti yang bersifat repetitif dan membutuhkan variasi *input* data yang besar. Teknik spesifik yang digunakan adalah *Data Driven Testing* (DDT). Melalui DDT, skenario pengujian dieksekusi secara berulang (*looping*) oleh mesin berdasarkan kumpulan data uji (*test data*) yang disuplai dari sumber eksternal, sehingga meminimalisir *human error* dan meningkatkan efisiensi waktu eksekusi.

2. **Manual Exploratory Testing (Pengujian Eksploratif Manual):** 
Metode ini digunakan untuk mengevaluasi fitur-fitur dinamis yang sulit diotomatisasi, seperti akurasi kamera pada *Object Hunt*, stabilitas koneksi *Multiplayer*, dan kenyamanan navigasi (*Usability*). *Tester* berperan layaknya pengguna nyata (*End-User*) untuk menemukan anomali visual atau perilaku sistem yang tidak terduga di luar skenario standar (*happy path*).

**Instrumen dan Alat Uji (Tools):**
* **Katalon Studio:** Bertindak sebagai *framework* utama untuk merekam dan menjalankan *script* pengujian antarmuka Android (*Mobile Recorder / Appium*) serta memvalidasi respon *backend server* (*Web Service / API Request*).
* **Android Device / Emulator:** Digunakan sebagai *environment* (lingkungan) eksekusi untuk menjalankan *build* aplikasi (*.apk*) Flutter.

**Data Uji (Test Data):**
Dataset eksternal dalam format *Spreadsheet* (Excel/CSV) yang berisi puluhan kombinasi data valid dan tidak valid (email, *password*, dan *Expected Result*). Data ini di-*binding* secara langsung ke dalam sistem Katalon untuk menguji fitur Login secara masif dan simultan.

## 6. Hasil Pengujian dan Evaluasi Kualitas

| Karakteristik ISO 25010 | Indikator Pengujian | Hasil Uji | Evaluasi |
| :--- | :--- | :--- | :--- |
| **Functional Suitability** | Fitur Login menggunakan Data Driven Testing (DDT). | Sukses (*Passed*). | Aplikasi mampu merespon *input* valid dan tidak valid secara akurat sesuai data Excel. |
| **Functional Suitability** | Pengiriman hasil ujian ke Gemini API. | Gagal (*Failed*). | Integrasi API perlu diperbaiki karena *request* evaluasi dari Gemini sering gagal terkirim. |
| **Performance Efficiency** | Kecepatan buka halaman Beranda (*Home*) setelah Login. | *Delay* (Lag). | Terdapat *lagging* UI pada proses *routing*. Disarankan menambah indikator *loading*. |
| **Performance Efficiency** | Frame rate (FPS) saat kamera membuka fitur Deteksi Benda. | Turun drastis (*Lag* parah). | Proses *Machine Learning* sangat membebani RAM/CPU. Butuh optimasi model *inference*. |
| **Reliability** | Kestabilan aplikasi saat memuat ulang kamera Deteksi Benda. | *Force Close* (*Crash*). | Aplikasi tidak dapat menangani pelepasan memori (*memory leak*) pada kamera, sehingga *crash*. |
| **Usability** | Aksesibilitas antar halaman menu profil dan *log* aktivitas. | Sukses (*Passed*). | Alur navigasi sudah intuitif dan mudah dipahami oleh pengguna. |

*(Lihat file PDF Reports Katalon yang dilampirkan sebagai bukti pendukung testing otomatis)*

## 7. Rekomendasi Perbaikan
Berdasarkan analisis hasil evaluasi pengujian yang mengacu pada standar ISO/IEC 25010, terdapat beberapa celah kerentanan (*vulnerability*) pada aspek performa dan keandalan sistem. Oleh karena itu, direkomendasikan tindak lanjut perbaikan (*corrective actions*) secara teknis sebagai berikut:

1. **Restrukturisasi Integrasi API Gemini (Evaluasi Ujian):** 
Mengingat tingginya tingkat kegagalan respons (*failure rate*) dari layanan AI eksternal, tim pengembang diwajibkan untuk mengimplementasikan pola asinkron yang lebih tangguh (*robust asynchronous handling*). Hal ini mencakup penerapan *Retry Mechanism* (mekanisme coba ulang otomatis jika *request* gagal), pembatasan *Timeout* yang rasional, serta penanganan eksepsi (*Exception Handling* / *Try-Catch*) yang komprehensif agar antarmuka (UI) tidak mengalami kondisi *hang* (membeku) ketika peladen (*server*) AI sedang mengalami kelebihan beban (*overload*).

2. **Optimasi Manajemen Memori pada Modul Deteksi Benda (*Computer Vision*):** 
Insiden *Force Close* yang berulang mengindikasikan adanya kebocoran memori (*Memory Leak*) yang masif saat aplikasi mengakses *hardware* kamera secara berkesinambungan. Direkomendasikan agar tim *developer* melakukan peninjauan ulang (*code refactoring*) pada *lifecycle* (siklus hidup) komponen *Flutter*. Sangat krusial untuk memastikan eksekusi metode `dispose()` pada *Camera Controller* dan pembersihan *cache* model *Machine Learning* setiap kali pengguna berpindah rute (navigasi keluar dari halaman Deteksi Benda).

3. **Peningkatan Pengalaman Pengguna (*Visual Feedback*) pada Modul Autentikasi:** 
Untuk mengatasi persepsi *lagging* atau aplikasi yang terasa tidak responsif saat proses Login, disarankan penambahan elemen *Micro-interaction*. Implementasi indikator pemrosesan seperti *Loading Spinner*, *Skeleton Loading*, atau *Toast Message* akan memberikan sinyal visual (umpan balik) yang jelas kepada pengguna bahwa sistem sedang memproses *request* ke server, sehingga meningkatkan karakteristik *Usability* secara signifikan.

## 8. Kesimpulan
Secara keseluruhan berdasarkan pendekatan ISO/IEC 25010, aplikasi Edutech sudah memiliki tingkat kesesuaian fungsional (*Functional Suitability*) dan kegunaan (*Usability*) yang sangat baik pada sebagian besar fiturnya. Namun, aplikasi ini masih membutuhkan perbaikan mendesak pada aspek **Performance Efficiency** dan **Reliability**, khususnya pada fitur Deteksi Benda yang memicu memori *crash* dan fitur evaluasi ujian otomatis (Gemini API) yang memiliki tingkat kegagalan respons (*failure rate*) cukup tinggi.

---
**Lampiran:**
* Laporan PDF Hasil Pengujian (*Data Driven Testing Katalon*)
* Dokumen *Incident Report & Bug Monitoring* (File `2_Incident_Report.md`)
