# LogBook App: Task 1, 2 & 3 🚀

Aplikasi LogBook pencatat aktivitas yang dikembangkan menggunakan Flutter. Proyek ini mendemonstrasikan pemahaman mendalam terkait State Management, Arsitektur Modular (Clean Code), dan Data Persistence.

**Dikembangkan oleh:**
* **Nama:** Qlio Amanda Febriany
* **NIM:** 241511087
* **Kelas:** 2C

---

## 🌟 Fitur Utama (Features)

### Task 1 & 2: Autentikasi & Keamanan (The Gatekeeper)
* **Multiple Users Database:** Mendukung login lebih dari satu akun menggunakan `Map<String, String>` (contoh: `admin`, `qlio`, `dosen`).
* **Validation Logic:** Mencegah input kosong dan membatasi *password* minimal 3 karakter serta maksimal 8 karakter.
* **Smart Lock Timer (UX Twist):** Jika salah memasukkan *password* 3 kali berturut-turut, tombol login akan terkunci selama 10 detik. Logika ini diimplementasikan secara *Clean* menggunakan `ValueNotifier` di Controller, menjaga View tetap bersih dari logika bisnis.
* **Show/Hide Password:** Visibilitas kata sandi yang responsif.

### Task 3: Persistent History Logger (Data Persistence)
* **Data Permanen:** Menggunakan `SharedPreferences` untuk menyimpan angka hitungan terakhir dan riwayat aktivitas. Data tidak akan hilang meskipun dilakukan *Hot Restart* atau aplikasi ditutup.
* **Dynamic Keys (Isolasi Database):** Setiap user memiliki kunci penyimpanan yang unik (`counter_$username`). Jika `admin` dan `qlio` login di perangkat yang sama, data mereka tidak akan saling tertimpa.
* **Limitasi Cerdas:** Angka memiliki batas maksimal hingga 300 dan tidak bisa di bawah 0 (Anti-Minus), dilengkapi dengan notifikasi `SnackBar`.

---

## 📁 Struktur Folder (Modular Architecture)
Proyek ini mengadopsi prinsip **Single Responsibility Principle (SRP)**. Semua logika bisnis diisolasi di Controller, sedangkan View murni untuk antarmuka.

```text
lib/
├── features/
│   ├── auth/
│   │   ├── login_controller.dart   # Logika Auth & Timer (ValueNotifier)
│   │   └── login_view.dart         # UI Login & Form Validation
│   ├── logbook/
│   │   ├── counter_controller.dart # Logika Hitungan & SharedPreferences
│   │   ├── counter_view.dart       # UI Utama & Dialog Konfirmasi
│   │   └── counter_widgets.dart    # Komponen Desain Modular (Presentational)
│   └── onboarding/
│       └── onboarding_view.dart    # Welcome Screen
└── main.dart