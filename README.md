# Ngopss

Ngopss adalah aplikasi pemesanan kopi dan makanan ringan (pastry) berbasis multi-platform. Aplikasi ini dibangun dengan mengimplementasikan prinsip *Clean Architecture* dan *State Management* yang terstruktur untuk memberikan pengalaman pengguna yang mulus dari proses autentikasi hingga *checkout*. 

Proyek ini dikembangkan untuk memenuhi tugas Ujian Tengah Semester (UTS) matakuliah mobile apps.

## Fitur Utama

* **Autentikasi Aman:** Mendukung Login/Register menggunakan Email & Password serta integrasi **Google Sign-In** via Firebase Authentication.
* **Proteksi Navigasi (Route Guard):** Akses halaman Dashboard dan Keranjang dilindungi secara ketat hanya untuk pengguna yang telah terautentikasi dan terverifikasi.
* **Katalog Interaktif:** Menampilkan daftar "Kopi" dan "Teman Ngopi" secara dinamis dari database terpusat dengan *handling error* dan *loading state* yang rapi.
* **Manajemen Keranjang (Cart):** Pengguna dapat menambahkan, melihat, dan menghitung total harga pesanan secara *real-time*.
* **Simulasi Checkout:** Proses penyelesaian pesanan dengan *feedback* visual yang interaktif (reset keranjang otomatis setelah sukses).

## Teknologi yang Digunakan

**Frontend:**
* Framework: Flutter
* State Management: Provider (`ChangeNotifier`)
* Routing: Named Routes (`app_router`)
* HTTP Client: HTTP / Dio

**Backend & Database:**
* Language/Framework: Golang (Gin Framework)
* Database: MySQL (via XAMPP)
* Authentication: Firebase Auth

## Dibangun Dengan 

### Frontend (Client Application)
* **[Flutter](https://flutter.dev/):** Framework utama untuk membangun antarmuka pengguna yang responsif.
* **[Dart](https://dart.dev/):** Bahasa pemrograman utama untuk logika Frontend.
* **Provider:** Digunakan untuk *State Management* (mengatur *state* keranjang belanja dan status autentikasi).
* **Dio / HTTP:** Digunakan sebagai HTTP *client* untuk berkomunikasi dengan REST API.

### Backend (REST API)
* **[Golang (Go)](https://go.dev/):** Bahasa pemrograman utama untuk membangun *server-side logic* yang cepat dan efisien.
* **[Gin Gonic](https://gin-gonic.com/):** Web framework HTTP untuk Golang yang digunakan untuk menangani *routing* dan *middleware* (termasuk CORS).
* **Firebase Admin SDK:** Digunakan di sisi *server* untuk memverifikasi dan mendekode token dari Google Sign-In secara aman.

### Database & Infrastruktur
* **MySQL (via XAMPP):** Sistem manajemen basis data relasional untuk menyimpan data produk, pengguna, dan transaksi.
* **Firebase Authentication:** Layanan pihak ketiga yang menangani proses masuk pengguna (Google Sign-In).

### Tools Pendukung
* **Postman:** Digunakan untuk pengujian (*testing*) dan dokumentasi *endpoint* REST API selama masa pengembangan.
* **Git & GitHub:** Sistem kontrol versi untuk kolaborasi dan manajemen kode *source*.

## 📁 Struktur Proyek (Clean Architecture)

```text
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors
│   │   └── api_constants
│   ├── network/
│   │   └── api_service
│   └── routes/
│       ├── app_router
│       └── auth_guard
├── features/
│   ├── auth/
│   │   └── presentation/
│   │       ├── pages/
│   │       │   ├── login_page
│   │       │   └── verify_email_page
│   │       └── providers/
│   │           └── auth_provider
│   ├── catalog/
│   │   ├── data/
│   │   │   ├── models/
│   │   │   │   └── product_model
│   │   │   └── repositories/
│   │   │       ├── product_repository
│   │   │       └── product_repository_impl
│   │   └── presentation/
│   │       ├── pages/
│   │       │   └── dashboard_page
│   │       └── providers/
│   │           └── catalog_provider
│   └── cart/
│       └── presentation/
│           ├── pages/
│           │   └── cart_page
│           └── providers/
│               └── cart_provider
└── main
```

## Alur Aplikasi

1. **Inisialisasi Sesi (Auth Guard)**
   * Saat aplikasi dijalankan, sistem (*Route Guard*) akan mengecek status autentikasi pengguna secara lokal dan via Firebase.
   * Jika pengguna belum login, akses ke halaman utama diblokir dan pengguna diarahkan ke halaman **Login**.

2. **Proses Login (Google Sign-In)**
   * Pengguna menekan tombol "Lanjutkan dengan Google".
   * Aplikasi meminta kredensial dari Google/Firebase.
   * Setelah sukses, Frontend mengirim laporan (berupa token) ke Backend Golang (`/v1/auth/verify-token`) untuk validasi silang.
   * Jika Backend memberikan respons sukses, pintu masuk ke aplikasi sepenuhnya terbuka.

3. **Memuat Data Katalog (Dashboard)**
   * Pengguna mendarat di halaman **Dashboard**.
   * Di balik layar, Frontend memanggil API Backend (`GET /v1/products`).
   * Backend mengambil data "Kopi" dan "Teman Ngopi" yang berstatus aktif dari database MySQL, lalu mengirimkannya kembali ke Frontend dalam format JSON.
   * Aplikasi menyusun data tersebut ke dalam UI *Grid* yang responsif.

4. **Manajemen Pesanan (Add to Cart)**
   * Pengguna melihat produk dan menekan tombol **Tambah**.
   * *State Management* (Provider) mencatat produk tersebut. Jika pengguna menambahkan produk yang sama (divalidasi berdasarkan ID unik, bukan nama), sistem secara cerdas hanya akan menjumlahkan kuantitasnya (*quantity*), tidak membuat baris pesanan baru.
   * Notifikasi *SnackBar* muncul memberikan *feedback* visual bahwa barang berhasil masuk keranjang.

5. **Penyelesaian Transaksi (Checkout)**
   * Pengguna menekan ikon keranjang dan masuk ke halaman **Cart**.
   * Aplikasi menampilkan rincian barang, jumlah, dan kalkulasi total harga secara dinamis.
   * Saat pengguna menekan tombol **Checkout**, sistem menyelesaikan transaksi dan mengosongkan *state* keranjang secara otomatis.

## Cara Menjalankan
Pastikan Anda telah menginstal Flutter SDK, Go, dan XAMPP sebelum menjalankan proyek ini.

1. **Konfigurasi Database (Backend)**

Buka XAMPP dan jalankan modul MySQL.<br>
Buat database baru di phpMyAdmin sesuai dengan konfigurasi di file .env Golang Anda.<br>
Buka terminal di direktori backend Golang dan jalankan seeder untuk mengisi data awal

```
Bash
go run seed/seed.go
```

2. **Jalankan server backend:**

```
Bash
go run main.go
```

3. **Jalankan Aplikasi Frontend**

Buka terminal baru di direktori proyek flutter
Unduh semua dependencies

```
Bash
flutter pub get
```

4. **Jalankan Aplikasi**

```
Bash
flutter run
```

## Demo Video

**[Tonto Demo di Youtube](https://youtu.be/jSJIDYv9oJk)**

---

1123150070<br>
Satria Herlambang