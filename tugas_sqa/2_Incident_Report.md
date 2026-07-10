# Incident Report & Bug Monitoring Analysis
**Aplikasi:** Edutech (Aplikasi Capstone)
**Tanggal Testing:** 10 Juli 2026
**Platform:** Android / Flutter

Dokumen ini berisi analisis pemantauan bug (bug monitoring) dan laporan insiden (incident report) dari pengujian fungsionalitas seluruh modul aplikasi Edutech.

## 1. Bug Monitoring Dashboard (Summary)
Berdasarkan hasil testing menyeluruh pada seluruh fitur, ditemukan beberapa *issue* dengan berbagai tingkat keparahan (*severity*).

| Modul / Fitur | Status Testing | Bug Ditemukan | Severity Tertinggi | Status Resolusi |
| :--- | :--- | :--- | :--- | :--- |
| **Splash Screen** | Selesai | 0 | - | - |
| **Login & Register** | Selesai | 1 | Medium | Dalam Perbaikan |
| **OTP Verification** | Selesai | 1 | High | Open |
| **Home** | Selesai | 0 | - | - |
| **Profile & Edit Profile** | Selesai | 2 | Low | Closed |
| **Leaderboard** | Selesai | 1 | Medium | Open |
| **Multiplayer** | Selesai | 2 | Critical | Dalam Perbaikan |
| **Guess Object** | Selesai | 0 | - | - |
| **Object Hunt** | Selesai | 1 | High | Open |
| **Spelling Practice & Exam**| Selesai | 1 | Medium | Closed |
| **Writing Practice & Exam** | Selesai | 0 | - | - |
| **Raport** | Selesai | 1 | Low | Open |

**Ringkasan Status Bug:**
- **Critical:** 1 Bug
- **High:** 2 Bug
- **Medium:** 3 Bug
- **Low:** 3 Bug

---

## 2. Detailed Incident Report (Laporan Insiden)

Berikut adalah detail laporan insiden (bug report) untuk bug yang dikategorikan *Critical* dan *High*:

### Incident #001 (Critical) - Game Crash pada Mode Multiplayer
* **ID Bug:** BUG-EDU-001
* **Reporter:** QA Tester
* **Modul:** Multiplayer
* **Deskripsi:** Aplikasi langsung mengalami *crash* (force close) ketika pemain kedua mencoba bergabung ke dalam sesi (room) multiplayer yang sudah dibuat oleh pemain pertama.
* **Langkah Reproduksi (Steps to Reproduce):**
  1. Login dengan akun Player A.
  2. Masuk ke menu "Multiplayer" dan buat room baru.
  3. Buka aplikasi di perangkat lain, login dengan akun Player B.
  4. Masuk ke menu "Multiplayer" dan pilih room Player A.
  5. Klik tombol "Join Room".
* **Expected Result:** Player B berhasil masuk ke room dan game bersiap untuk dimulai.
* **Actual Result:** Aplikasi di perangkat Player B force close (crash) kembali ke home screen Android.
* **Environment:** Android 13 (Samsung Galaxy S22), Flutter release build.
* **Status:** Dalam Perbaikan (In Progress) oleh tim Backend/Socket.io.

### Incident #002 (High) - Kegagalan Pengiriman Kode OTP
* **ID Bug:** BUG-EDU-002
* **Reporter:** QA Tester
* **Modul:** OTP / Register
* **Deskripsi:** Email OTP tidak masuk ke kotak masuk (inbox) atau spam pengguna saat melakukan registrasi akun baru pada jam-jam sibuk (high load).
* **Langkah Reproduksi:**
  1. Masuk ke halaman Register.
  2. Isi data valid dan tekan tombol "Daftar".
  3. Sistem mengarahkan ke halaman Input OTP.
  4. Cek email yang didaftarkan.
* **Expected Result:** Email OTP diterima maksimal 1-2 menit setelah tombol daftar ditekan.
* **Actual Result:** Email tidak masuk meskipun sudah ditunggu lebih dari 10 menit.
* **Environment:** Production Server, SMTP Email Service.
* **Status:** Open (Menunggu eskalasi ke tim DevOps).

### Incident #003 (High) - AR/Kamera Freeze pada Fitur Object Hunt
* **ID Bug:** BUG-EDU-003
* **Reporter:** QA Tester
* **Modul:** Object Hunt
* **Deskripsi:** Tampilan kamera pada fitur Object Hunt membeku (freeze) setelah mendeteksi lebih dari 3 objek secara berurutan tanpa jeda.
* **Langkah Reproduksi:**
  1. Buka fitur "Object Hunt".
  2. Arahkan kamera ke objek 1 (berhasil dideteksi).
  3. Secara cepat arahkan ke objek 2 (berhasil dideteksi).
  4. Secara cepat arahkan ke objek 3 (berhasil dideteksi).
  5. Kamera membeku (freeze UI).
* **Expected Result:** Kamera tetap berjalan lancar (*smooth*) meskipun memproses banyak deteksi objek.
* **Actual Result:** UI thread terblokir, kamera freeze, membutuhkan *restart* aplikasi.
* **Environment:** Android 11 (Xiaomi Redmi Note 10).
* **Status:** Open.
