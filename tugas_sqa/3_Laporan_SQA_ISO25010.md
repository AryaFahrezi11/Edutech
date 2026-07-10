# Laporan Software Quality Assurance (SQA)
**Standar Pengujian:** ISO/IEC 25010 (Software Product Quality Model)
**Aplikasi:** Edutech (Capstone Project)
**Tanggal Laporan:** 10 Juli 2026

Dokumen ini berisi hasil evaluasi kualitas perangkat lunak (SQA) aplikasi Edutech berdasarkan 8 karakteristik model kualitas ISO/IEC 25010.

---

## 1. Functional Suitability (Kesesuaian Fungsional)
Mengevaluasi sejauh mana aplikasi menyediakan fungsi yang memenuhi kebutuhan yang dinyatakan dan tersirat.
* **Functional Completeness:** Aplikasi telah mencakup semua fitur edukasi utama yang direncanakan (Login, Register, Multiplayer, Object Hunt, Spelling/Writing Practice, Leaderboard, Raport). (**Tingkat Pemenuhan: 95%**)
* **Functional Correctness:** Hasil perhitungan skor di Leaderboard dan Raport akurat. Namun, ada sedikit masalah pada pengiriman OTP yang kadang tidak akurat waktunya (bug terdeteksi). (**Tingkat Pemenuhan: 85%**)
* **Functional Appropriateness:** Fungsionalitas sesuai dengan target pengguna (anak-anak/pelajar) untuk tujuan pembelajaran (*edutech*). (**Tingkat Pemenuhan: 100%**)

## 2. Performance Efficiency (Efisiensi Kinerja)
Mengevaluasi kinerja aplikasi relatif terhadap jumlah sumber daya yang digunakan.
* **Time Behavior:** Waktu muat (load time) aplikasi pada *Splash Screen* hingga *Home* memakan waktu rata-rata kurang dari 3 detik (Baik).
* **Resource Utilization:** Fitur *Object Hunt* (Kamera/AR) menggunakan RAM dan CPU yang cukup tinggi. Terdapat isu *freeze* pada perangkat spesifikasi rendah. (**Perlu Peningkatan**)
* **Capacity:** Server mampu menangani simulasi *Multiplayer* hingga 50 *concurrent users* (pengguna bersamaan) dalam satu waktu tanpa kendala berarti.

## 3. Compatibility (Kompatibilitas)
Mengevaluasi kemampuan produk saling bertukar informasi atau bekerja di *environment* yang sama.
* **Co-existence:** Aplikasi Edutech (Flutter) dapat berjalan berdampingan dengan aplikasi lain tanpa memonopoli sumber daya secara tidak wajar.
* **Interoperability:** Integrasi aplikasi dengan API Backend untuk sinkronisasi data (profil, raport, dll) berjalan dengan baik (format JSON/REST API digunakan dengan standar yang tepat).

## 4. Usability (Kebergunaan)
Mengevaluasi sejauh mana aplikasi dapat digunakan secara mudah oleh pengguna.
* **Appropriateness Recognizability:** Desain UI/UX (termasuk tombol, ikon) mudah dipahami oleh pengguna target (edukasi anak/remaja).
* **Learnability:** Mode permainan seperti *Guess Object* dan *Spelling Practice* memiliki *learning curve* yang sangat rendah. Mudah dimengerti pada percobaan pertama.
* **User Error Protection:** Terdapat validasi *form* pada halaman Register (misal: password harus 8 karakter) untuk mencegah *user error*.

## 5. Reliability (Keandalan)
Mengevaluasi sejauh mana sistem dapat mempertahankan tingkat kinerja tertentu ketika digunakan dalam kondisi yang ditentukan.
* **Maturity:** Aplikasi cukup stabil di fitur-fitur dasar (Home, Profile). Namun fitur *Multiplayer* masih menunjukkan tingkat *crash* pada kondisi tertentu (lihat *Incident Report*). (**Tingkat Pemenuhan: 70%**)
* **Fault Tolerance:** Jika koneksi internet terputus di tengah ujian (*Spelling Exam*), aplikasi mampu memberikan notifikasi *offline* tanpa langsung *force close*.
* **Recoverability:** Dapat memulihkan data progres terakhir saat aplikasi dijalankan kembali.

## 6. Security (Keamanan)
Mengevaluasi tingkat perlindungan informasi dan data.
* **Confidentiality:** Password pengguna sudah dienkripsi di *database* (hash). Data *Raport* hanya bisa dilihat oleh pengguna yang bersangkutan.
* **Integrity:** Tidak ada pihak luar yang bisa memodifikasi skor *Leaderboard* secara tidak sah. Terdapat token autentikasi (JWT).
* **Accountability:** Adanya log aktivitas (*Activity Log*) merekam kapan siswa mengerjakan *practice* atau *exam*.

## 7. Maintainability (Pemeliharaan)
Mengevaluasi tingkat efektivitas dan efisiensi produk agar dapat dimodifikasi.
* **Modularity:** Arsitektur kode Flutter dipisahkan berdasarkan modul (seperti yang terlihat pada struktur `lib/app/modules/`), sehingga perubahan pada *login* tidak merusak *leaderboard*. (**Sangat Baik**)
* **Reusability:** Komponen *widgets* (seperti *custom buttons*, *text fields*) diletakkan terpisah di folder `lib/app/widgets/` sehingga dapat digunakan kembali.
* **Testability:** Arsitektur yang modular sangat mendukung untuk pengujian terotomatisasi (Katalon/Appium/Flutter Test).

## 8. Portability (Portabilitas)
Mengevaluasi sejauh mana suatu sistem dapat ditransfer dari satu *environment* ke *environment* lain.
* **Adaptability:** Aplikasi dibangun menggunakan Flutter (*Cross-Platform*), yang artinya *codebase* yang sama dapat beradaptasi dan di-*build* untuk Android maupun iOS (sesuai folder `android/` dan `ios/` yang terdapat di proyek).
* **Installability:** Pemasangan file APK ke berbagai versi Android (minimal Android 8.0) berjalan lancar tanpa *error dependencies*.

---
**Kesimpulan Umum:**
Aplikasi Edutech telah memenuhi sebagian besar standar ISO 25010. Peningkatan *(improvement)* yang signifikan perlu dilakukan pada karakteristik **Reliability** (khususnya stabilitas modul Multiplayer) dan **Performance Efficiency** (optimasi penggunaan kamera pada fitur Object Hunt).
