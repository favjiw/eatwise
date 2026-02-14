# EatFit Mobile Repository Documentation

---

## 📃 Table of Contents
- [⚙️ Technology Stack](#-technology-stack)
- [🧩 Core Features](#-core-features)
- [🚀 Functional Requirements Document](#-functional-requirements-document)
- [🏗️ Architecture Pattern](#-architecture-pattern)
- [📈 Design Pattern](#-design-pattern)
- [🧑‍💻 Clean Code](#-clean-code)
- [🔒 Security](#-security)
- [⚡ DevOps & Deployment Plan](#-devops--deployment-plan)
- [🧰 Getting Started Locally](#-getting-started-locally)
- [👥 Owner](#-owner)

---

## ⚙️ Technology Stack

<div align="center">
<kbd><img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/flutter.png" height="60" /></kbd>
<kbd><img src="https://raw.githubusercontent.com/marwin1991/profile-technology-icons/refs/heads/main/icons/dart.png" height="60" /></kbd>
<kbd><img width="60" height="60" alt="GetX" src="https://raw.githubusercontent.com/jonataslaw/getx-community/master/get.png" /></kbd>
<kbd><img width="60" height="60" alt="Dio" src="https://github.com/cfug/dio/raw/main/dio.png" /></kbd>
</div>

<div align="center">
<h4>Flutter | Dart | GetX | Dio | Mobile Scanner | ScreenUtil</h4>
</div>

- **Framework:** Flutter SDK ^3.11.0.
- **State Management:** GetX ^4.7.3.
- **Networking:** Dio ^5.9.1.
- **Scanner:** Mobile Scanner ^7.1.4.
- **Local Storage:** GetStorage ^2.1.1.

---

## 🧩 Core Features

### 🔐 Authentication & Onboarding
- **Secure Login:** Autentikasi pengguna melalui modul login.
- **User Registration:** Fitur pembuatan akun baru bagi pengguna.
- **Personalized Onboarding:** Inisialisasi data fisik pengguna untuk perhitungan nutrisi yang akurat.

### 🥗 Nutritional Tracking
- **Scanner Barcode:** Pencatatan makanan secara cepat menggunakan teknologi pemindaian.
- **Food Search:** Database pencarian makanan untuk melihat detail nutrisi.
- **Daily Progress:** Dashboard untuk memantau asupan kalori dan makronutrisi harian.

### 📊 Community & Insights
- **Diet History:** Log harian konsumsi makanan berdasarkan kalender.
- **Community Feed:** Berbagi progres dan berinteraksi dengan pengguna lain.

---

## 🚀 Functional Requirements Document

### User Stories
1. **Pendaftaran:** Sebagai pengguna, saya ingin mendaftar akun agar riwayat makan saya tersimpan secara aman.
2. **Input Data:** Sebagai pengguna baru, saya ingin memasukkan data tubuh saya agar aplikasi memberikan rekomendasi kalori yang tepat.
3. **Pencatatan Cepat:** Sebagai pengguna yang sibuk, saya ingin memindai produk makanan agar pencatatan nutrisi menjadi lebih praktis.
4. **Pemantauan:** Sebagai pengguna, saya ingin melihat grafik nutrisi harian agar saya tahu sisa kuota kalori saya.

---

## 🏗️ Architecture Pattern

Aplikasi ini mengadopsi **GetX Pattern** untuk memastikan pemisahan logika yang bersih dan kemudahan pengembangan.

### Repository Structure
- **app/data/:** Berisi model data, penyedia API (Dio), dan layanan inti aplikasi.
- **app/modules/:** Struktur per modul yang mencakup Binding, Controller, dan View.
- **app/routes/:** Definisi rute aplikasi dan navigasi antar layar.
- **shared/:** Konstanta warna, gaya teks, dan widget yang dapat digunakan kembali.

---

## 📈 Design Pattern

### 1. State Management (Reactive)
Implementasi GetX memungkinkan pembaruan UI secara reaktif hanya pada komponen yang berubah menggunakan `Obx` atau `GetBuilder`.

### 2. Singleton & Service Pattern
Layanan utama seperti `AuthService` atau `UserService` diinisialisasi sebagai singleton untuk akses global yang konsisten di seluruh siklus hidup aplikasi.

---

## 🧑‍💻 Clean Code

### 1. Reusable Widgets
UI modular dipisahkan ke dalam folder `shared/widgets/` untuk menghindari duplikasi kode, seperti `CustomButton` atau `CustomTextField`.

### 2. Dependency Injection
Setiap modul fitur memiliki file `Binding` yang mengatur inisialisasi Controller tepat saat view dibuka, guna mengoptimalkan penggunaan memori.

---

## 🔒 Security

### 1. Environment Variables
Penggunaan file `.env` untuk menyimpan URL API backend sensitif agar tidak terpapar dalam kode sumber.

### 2. Git Protection
Pengaturan file `.gitignore` memastikan data rahasia seperti `key.properties`, file `.jks` (Keystore), dan `.env` tidak terunggah ke repositori publik.

---

## ⚡ DevOps & Deployment Plan

### Release Configuration
Aplikasi dikonfigurasi menggunakan Kotlin DSL di tingkat Gradle untuk proses build yang teroptimasi:
- **Minification:** Mengaktifkan `isMinifyEnabled = true` untuk mengecilkan ukuran APK.
- **Resource Shrinking:** Mengaktifkan `isShrinkResources = true` untuk menghapus aset yang tidak digunakan.
- **Signing Config:** Integrasi otomatis dengan keystore rilis melalui file `key.properties`.

---

## 🧰 Getting Started Locally

1. **Persiapan:** Pastikan Flutter SDK terbaru sudah terinstal.
2. **Instalasi:**
   ```bash
   git clone [https://github.com/favjiw/eatwise.git](https://github.com/favjiw/eatwise.git)
   flutter pub get
   ```
3. **Konfigurasi:** Buat file .env sesuai template untuk endpoint API.
4. **Jalankan:**
   ```bash
   flutter run
   ```
