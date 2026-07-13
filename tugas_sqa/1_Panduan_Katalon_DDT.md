# Panduan Data Driven Testing (DDT) dengan Katalon Studio

Tugas ini meminta Anda untuk membuat automated testing menggunakan teknik Data Driven Testing (DDT) pada minimal 1 fitur. Fitur yang paling tepat dan umum digunakan untuk DDT adalah **Fitur Login**.

## 1. Persiapan Data (File CSV)
Buat file Excel dan simpan sebagai `Data_Login.csv` dengan format berikut:

| username | password | expected_result |
| :--- | :--- | :--- |
| user_valid@email.com | password123 | passed |
| user_salah@email.com | password123 | failed |
| user_valid@email.com | pass_salah | failed |
| | password123 | failed |
| user_valid@email.com | | failed |

## 2. Langkah-langkah di Katalon Studio

### A. Buat Test Data
1. Buka Katalon Studio, di panel **Test Explorer**, klik kanan pada **Data Files** > **New** > **Test Data**.
2. Beri nama `Login Data`, pilih **Data Type: CSV File**.
3. Browse dan pilih file `Data_Login.csv` yang sudah dibuat tadi. Jangan lupa centang *Use first row as header*.

### B. Buat Test Case
1. Klik kanan pada **Test Cases** > **New** > **Test Case**. Beri nama `TC_Login`.
2. Masuk ke tab **Variables** di bagian bawah Test Case. Tambahkan 3 variabel:
   - Name: `username`, Type: `String`, Default Value: `""`
   - Name: `password`, Type: `String`, Default Value: `""`
   - Name: `expected_result`, Type: `String`, Default Value: `""`
3. Masuk ke tab **Script** dan masukkan kode berikut (disesuaikan dengan ID elemen aplikasi Edutech Anda, jika aplikasi mobile flutter gunakan Appium/Katalon Mobile Spy untuk mendapatkan locator):

```groovy
import static com.kms.katalon.core.checkpoint.CheckpointFactory.findCheckpoint
import static com.kms.katalon.core.testcase.TestCaseFactory.findTestCase
import static com.kms.katalon.core.testdata.TestDataFactory.findTestData
import static com.kms.katalon.core.testobject.ObjectRepository.findTestObject
import com.kms.katalon.core.mobile.keyword.MobileBuiltInKeywords as Mobile

// Mulai aplikasi (isi dengan path APK aplikasi Edutech jika testing mobile)
Mobile.startApplication('path/to/edutech.apk', false)

// Input Username dari variabel DDT
Mobile.setText(findTestObject('Object Repository/Login/input_Username'), username, 0)

// Input Password dari variabel DDT
Mobile.setText(findTestObject('Object Repository/Login/input_Password'), password, 0)

// Klik tombol Login
Mobile.tap(findTestObject('Object Repository/Login/btn_Login'), 0)

// Verifikasi berdasarkan expected result
if (expected_result == 'passed') {
    // Verifikasi jika login sukses (misal: muncul elemen Home)
    Mobile.verifyElementExist(findTestObject('Object Repository/Home/txt_Welcome'), 5)
} else {
    // Verifikasi jika login gagal (misal: muncul pesan error)
    Mobile.verifyElementExist(findTestObject('Object Repository/Login/txt_ErrorMessage'), 5)
}

// Tutup aplikasi
Mobile.closeApplication()
```

### C. Buat Test Suite & Mapping Data (Inti dari DDT)
1. Klik kanan pada **Test Suites** > **New** > **Test Suite**. Beri nama `TS_Login_DDT`.
2. Klik tombol **Add** dan pilih Test Case `TC_Login`.
3. Klik tombol **Show Data Binding** di bagian atas Test Suite.
4. Di bagian **Test Data**, klik tombol **Add** dan pilih `Login Data` yang dibuat di langkah A.
5. Di bagian **Variable Binding**, Anda akan melihat 3 variabel dari Test Case. Lakukan mapping (Type: `Data Column`):
   - `username` -> pilih Test Data `Login Data`, Value: `username`
   - `password` -> pilih Test Data `Login Data`, Value: `password`
   - `expected_result` -> pilih Test Data `Login Data`, Value: `expected_result`
6. Simpan dan jalankan Test Suite. Katalon akan otomatis menjalankan `TC_Login` berulang kali sebanyak baris data yang ada di file CSV.
