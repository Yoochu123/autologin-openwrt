# OpenWrt Auto-Login for Public WiFi

Sebuah paket skrip lengkap untuk router OpenWrt yang secara otomatis melakukan login ke *captive portal* WiFi publik yang hanya memerlukan email. Dilengkapi dengan antarmuka web yang terintegrasi ke menu LuCI untuk kemudahan konfigurasi dan monitoring.

![Contoh Tampilan](https://storage.googleapis.com/gemini-prod/images/5f79aa48-028f-410a-b28e-5b23d9a5b33d)
*(**Catatan**: Ganti gambar di atas dengan screenshot antarmuka web Anda sendiri. Unggah gambar ke repositori GitHub Anda dan ganti link-nya.)*

---

## Fitur Utama

-   **Login Otomatis**: Secara berkala memeriksa koneksi internet. Jika terputus, skrip akan membuat email acak dan mencoba login kembali.
-   **Antarmuka Web**: Halaman web yang mudah digunakan untuk mengubah URL portal, nama field email, dan mengaktifkan/menonaktifkan layanan.
-   **Monitoring Log**: Menampilkan 20 baris log terakhir langsung di antarmuka web untuk kemudahan *troubleshooting*.
-   **Integrasi Menu LuCI**: Entri menu "AutoLogin WiFi" ditambahkan secara otomatis di bawah menu "Services" pada antarmuka web LuCI.
-   **Instalasi Satu Baris**: Seluruh paket dapat dipasang hanya dengan satu perintah.
-   **Uninstaller Lengkap**: Skrip untuk menghapus semua file dan konfigurasi dengan bersih.

## Persyaratan

-   Router yang menjalankan OpenWrt.
-   Akses SSH ke router.
-   Koneksi internet awal untuk mengunduh skrip installer.

## Instalasi

Buka terminal SSH ke router OpenWrt Anda dan jalankan perintah tunggal berikut. Skrip ini akan mengunduh semua file yang diperlukan, menempatkannya di direktori yang benar, mengatur izin, membuat konfigurasi awal, dan memulai layanan secara otomatis.

**PENTING**: Ganti `NAMA_PENGGUNA_GITHUB` dan `NAMA_REPO_ANDA` dengan nama pengguna dan repositori GitHub Anda.

```sh
wget -O - [https://raw.githubusercontent.com/NAMA_PENGGUNA_GITHUB/NAMA_REPO_ANDA/main/install.sh](https://raw.githubusercontent.com/NAMA_PENGGUNA_GITHUB/NAMA_REPO_ANDA/main/install.sh) | sh
```

Setelah instalasi selesai, segarkan (refresh) halaman LuCI Anda. Entri menu baru bernama **"AutoLogin WiFi"** akan muncul di bawah **"Services"**. Klik menu tersebut untuk melakukan konfigurasi.

## Uninstall

Untuk menghapus semua file, konfigurasi, dan layanan yang terkait dengan paket ini, jalankan perintah tunggal berikut di terminal SSH.

**PENTING**: Ganti `NAMA_PENGGUNA_GITHUB` dan `NAMA_REPO_ANDA` dengan nama pengguna dan repositori GitHub Anda.

```sh
wget -O - [https://raw.githubusercontent.com/NAMA_PENGGUNA_GITHUB/NAMA_REPO_ANDA/main/uninstall.sh](https://raw.githubusercontent.com/NAMA_PENGGUNA_GITHUB/NAMA_REPO_ANDA/main/uninstall.sh) | sh
```

Proses ini akan menghentikan layanan, menghapus semua file terkait, dan membersihkan entri menu dari LuCI.
