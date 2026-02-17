# LogBook App - Authentication & Navigation (Proyek 4 - Modul 2)

**Nama:** Qlio Amanda Febriany
**NIM:** 241511087
**Kelas:** 2C
**Tanggal:** 17 Februari 2026

---

## 🏗️ Struktur Proyek (Modular Architecture)
Pada modul ini, proyek telah di-refactor menggunakan **Modular Folder Structure** untuk memisahkan fitur secara rapi dan menjaga prinsip **Single Responsibility Principle (SRP)**:
* **`features/auth/`:** Berisi `login_controller.dart` (menangani database *Map* multi-user, logika keamanan batas percobaan, dan timer) serta `login_view.dart` (antarmuka gerbang masuk, form input, dan validasi visual).
* **`features/logbook/`:** Berisi fitur utama aplikasi dari minggu sebelumnya (`counter_controller.dart` dan `counter_view.dart`), yang kini terisolasi dan hanya bisa diakses setelah melewati *Login Gatekeeper*.
* **`features/onboarding/`:** Berisi `onboarding_view.dart` sebagai layar perkenalan (*placeholder* sebelum *Login*).

---

## 📝 Self-Reflection
**Pertanyaan:** "Bagaimana prinsip SRP dan Arsitektur Modular membantu Anda saat mengimplementasikan fitur Keamanan Login?"

**Jawaban:**
Penerapan struktur modular dan SRP membuat penanganan fitur keamanan menjadi sangat bersih. Semua logika perhitungan waktu mundur (10 detik) dan validasi kecocokan *username/password* murni dikerjakan oleh `LoginController`. Sementara itu, `LoginView` murni berfokus pada UI (seperti mendengarkan status *lock* via `ValueNotifier` dan memunculkan *SnackBar*). Pemisahan ini membuat kode UI tidak kotor oleh logika `Timer` atau *looping*, sehingga meminimalisir risiko *memory leak* dan membuat proses *debugging* sangat terarah.

---

## 🧠 Lesson Learnt (Refleksi Akhir)
3 Poin utama yang dipelajari dari pengerjaan Modul 2:

1.  **Konsep Baru:** Memahami cara kerja `ValueNotifier` dan `ValueListenableBuilder` untuk membuat UI yang reaktif. Tombol bisa otomatis *disable* dan *update* teks detiknya tanpa harus memanggil `setState()` yang membebani seluruh halaman.
2.  **Kemenangan Kecil:** Berhasil memecahkan masalah *Bottom Overflow* pada layar saat *keyboard* HP muncul. Dengan membungkus Form menggunakan `Center` dan `SingleChildScrollView`, UI menjadi responsif dan aman di berbagai ukuran layar.
3.  **Target Berikutnya:** Mempelajari manajemen *Shared Preferences* (Data Persistence) agar riwayat hitungan *Counter* tidak kembali ke 0 saat aplikasi ditutup (Hot Restart).

---

## 🤖 Integritas AI: Log LLM
Berikut adalah rekam jejak penggunaan AI sebagai asisten coding yang kritis.

| Komponen | Isian Mahasiswa |
| :--- | :--- |
| **Pertanyaan (Prompt)** | "Bagaimana cara membuat tombol login disable selama 10 detik jika salah 3 kali di Flutter?" |
| **Jawaban AI (Intisari)** | AI menyarankan penggunaan `Future.delayed` atau `Timer` lalu memanggil `setState()` di dalam file View untuk mengubah status tombol. |
| **The Fact Check (Validasi)** | **Analisa:** Saya mengecek kode tersebut dan menyadari bahwa menaruh logika waktu (timer) di dalam View melanggar prinsip SRP. Selain itu, jika layar tertutup saat timer berjalan, bisa memicu *memory leak*.<br>**Koreksi:** Saya memindahkan seluruh logika *Counter* salah dan *Timer* ke `LoginController` menggunakan `ValueNotifier`, sehingga View hanya bertugas "mendengarkan" perubahannya. |
| **The Twist (Modifikasi)** | **Kreativitas:** Saya menambahkan fitur *Countdown* detik yang berjalan *real-time* tepat di dalam teks tombol (contoh: "Terkunci (8 detik)") agar UX-nya jauh lebih informatif bagi pengguna. |
| --- | --- |
| **Pertanyaan (Prompt)** | "Bagaimana cara membuat validasi agar field Username dan Password tidak boleh kosong di Flutter?" |
| **Jawaban AI (Intisari)** | AI menyarankan penggunaan widget `Form` dan `TextFormField`, lalu memberikan fungsi `validator` sederhana untuk mengecek `if (value == null \|\| value.isEmpty)`. |
| **The Fact Check (Validasi)** | **Analisa:** Saran AI sudah menyelesaikan syarat minimal modul. Namun, untuk sistem keamanan di dunia nyata, mengecek kolom kosong saja tidak cukup. Dibutuhkan batasan panjang karakter agar sistem tidak menerima *spam input*.<br>**Koreksi:** Saya memperluas fungsi `validator` untuk juga mengecek `if (value.length < 3)` mengingat password akun 'admin' dan 'qlio' panjangnya persis 3 karakter. |
| **The Twist (Modifikasi)** | **Kreativitas:** Saya menambahkan properti `maxLength: 10` pada `TextFormField` password. Ini membatasi input pengguna secara visual dan otomatis mencegah *Buffer Overflow* atau form yang terlalu panjang. |
| --- | --- |
| **Pertanyaan (Prompt)** | "Saat menambahkan maxLength, muncul peringatan kuning hitam 'Bottom overflow by 6.1 pixels' saat keyboard HP terbuka. Bagaimana cara mengatasinya?" |
| **Jawaban AI (Intisari)** | AI mengidentifikasi bahwa ukuran form membesar melampaui layar. AI menyarankan untuk membungkus `Column` dengan `SingleChildScrollView`. |
| **The Fact Check (Validasi)** | **Analisa:** Saat saya terapkan `SingleChildScrollView` secara langsung, *overflow* memang hilang, tetapi form-nya malah menempel berantakan ke atas layar saat *keyboard* ditutup.<br>**Koreksi:** Saya perlu menjaga form agar tetap di tengah layar saat posisi normal, namun bisa di-*scroll* saat *keyboard* muncul. |
| **The Twist (Modifikasi)** | **Kreativitas:** Saya memadukan saran tersebut dengan membungkus `SingleChildScrollView` ke dalam widget `Center`, sehingga UI tetap memiliki proporsi *alignment* yang presisi baik saat *keyboard* disembunyikan maupun ditampilkan. |