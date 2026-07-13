# Incident Report & Bug Monitoring Analysis
**Aplikasi:** Edutech (Aplikasi Capstone)
**Tanggal Testing:** 12 Juli 2026
**Platform:** Android / Flutter

Dokumen ini berisi analisis pemantauan bug (bug monitoring) dan laporan insiden (incident report) dari pengujian fungsionalitas seluruh modul aplikasi Edutech menggunakan Katalon Mobile UI dan API Testing.

## 1. Bug Monitoring Dashboard (Summary)
Berdasarkan hasil testing menyeluruh pada seluruh fitur, ditemukan beberapa *issue* yang harus segera ditangani sebelum dirilis.

| Modul / Fitur | Status Testing | Bug Ditemukan | Severity Tertinggi | Status Resolusi |
| :--- | :--- | :--- | :--- | :--- |
| **Login** | Selesai | 1 | Low | Open |
| **Deteksi Benda** | Selesai | 1 | High | Open |
| **Ujian & Evaluasi Gemini** | Selesai | 1 | Critical | Open |
| **Latihan Menulis & Mengeja**| Selesai | 0 | - | - |
| **Menebak Benda Sekitar** | Selesai | 0 | - | - |
| **Game Multiplayer** | Selesai | 0 | - | - |
| **Leaderboard & Profil** | Selesai | 0 | - | - |
| **Raport & Pengaturan** | Selesai | 0 | - | - |

**Ringkasan Status Bug:**
- **Critical:** 1 Bug
- **High:** 1 Bug
- **Medium:** 0 Bug
- **Low:** 1 Bug

---

## 2. Detailed Incident Report (Laporan Insiden)

Berikut adalah detail laporan insiden (bug report) berdasarkan temuan pengujian otomatis dan manual:

### Incident #001 (Critical) - Kegagalan Evaluasi AI (Gemini) pada Ujian
* **ID Bug:** BUG-EDU-001
* **Reporter:** QA Tester
* **Modul:** Ujian & Evaluasi
* **Deskripsi:** Sistem sering mengalami kegagalan (*failed*) saat mencoba mengirimkan data hasil ujian ke API Gemini untuk diproses menjadi hasil evaluasi. Akibatnya, pengguna tidak mendapatkan *feedback* atau nilai evaluasi setelah bersusah payah menyelesaikan ujian.
* **Langkah Reproduksi (Steps to Reproduce):**
  1. Masuk ke aplikasi dan pilih menu Ujian.
  2. Selesaikan seluruh soal ujian yang diberikan.
  3. Tekan tombol kumpulkan/selesai ujian.
  4. Sistem mencoba mengirim data ke Gemini AI.
* **Expected Result:** Evaluasi dari Gemini AI muncul dalam beberapa detik dan memberikan nilai serta saran.
* **Actual Result:** Terjadi *error* pengiriman ke server/Gemini, sehingga evaluasi gagal dibuat dan layar terkadang terhenti (stuck).
* **Environment:** Production Server, Android (Flutter).
* **Status:** Open (Menunggu perbaikan koneksi/prompt ke Gemini API).

### Incident #002 (High) - Performa Lag dan Crash pada Kamera Deteksi Benda
* **ID Bug:** BUG-EDU-002
* **Reporter:** QA Tester
* **Modul:** Deteksi Benda
* **Deskripsi:** Saat membuka atau menggunakan fitur kamera pada menu Deteksi Benda, aplikasi merespon dengan sangat lambat (*lagging* / penurunan *frame rate* yang drastis). Pada beberapa kasus saat pengujian berlangsung, aplikasi bahkan mengalami *Force Close* (*Crash*) dan keluar dengan sendirinya.
* **Langkah Reproduksi:**
  1. Buka menu Deteksi Benda.
  2. Arahkan kamera ke berbagai objek sekitar.
  3. Perhatikan pergerakan UI dan respon aplikasi.
* **Expected Result:** Kamera berjalan dengan mulus (*smooth*) secara *real-time* saat mendeteksi objek, tanpa membebani memori secara berlebihan.
* **Actual Result:** Layar mengalami *lag* parah, UI macet, dan terkadang berujung pada *crash* (aplikasi tertutup paksa).
* **Environment:** Android Device (Mobile Testing).
* **Status:** Open (Dibutuhkan optimasi memori/model Machine Learning pada Flutter).

### Incident #003 (Low) - Keterlambatan Respon (Lag) pada Proses Login
* **ID Bug:** BUG-EDU-003
* **Reporter:** QA Tester
* **Modul:** Login
* **Deskripsi:** Terdapat sedikit *delay* atau *lag* pada aplikasi ketika pengguna menekan tombol Login. Transisi dari halaman Login menuju halaman Beranda (Home) tidak instan dan terasa berat.
* **Langkah Reproduksi:**
  1. Masukkan email dan password yang valid.
  2. Tekan tombol Login.
* **Expected Result:** Transisi halaman (*routing*) ke Beranda berlangsung cepat, mulus, dan menampilkan indikator *loading* yang jelas.
* **Actual Result:** Terasa ada jeda (lag) UI yang mengganggu sebelum halaman Beranda sepenuhnya terbuka.
* **Environment:** Android Device (Mobile Testing).
* **Status:** Open (Disarankan penambahan *loading spinner* atau optimasi pemanggilan API awal).
