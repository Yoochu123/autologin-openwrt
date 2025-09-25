# OpenWrt Auto-Login for Captive portal

Sebuah paket skrip lengkap untuk router OpenWrt yang secara otomatis melakukan login ke *captive portal* WiFi publik yang hanya memerlukan email. Dilengkapi dengan antarmuka web yang terintegrasi ke menu LuCI untuk kemudahan konfigurasi dan monitoring.

---

## Fitur Utama

-   **Login Otomatis**: Secara berkala memeriksa koneksi internet. Jika terputus, skrip akan membuat email acak dan mencoba login kembali.
-   **Antarmuka Web**: Halaman web yang mudah digunakan untuk mengubah URL portal, nama field email, dan mengaktifkan/menonaktifkan layanan.
-   **Monitoring Log**: Menampilkan 20 baris log terakhir langsung di antarmuka web untuk kemudahan *troubleshooting*.
-   **Integrasi Menu LuCI**: Entri menu "AutoLogin WiFi" ditambahkan secara otomatis di bawah menu "Services" pada antarmuka web LuCI.
-   **Instalasi Satu Baris**: Seluruh paket dapat dipasang hanya dengan satu perintah.
-   **Uninstaller Lengkap**: Skrip untuk menghapus semua file dan konfigurasi dengan bersih.

## Persyaratan

-   Router yang menjalankan OpenWrt. (terinstall package Wget dukungan SSL)
-   Akses SSH ke router.
-   Koneksi internet awal untuk mengunduh skrip installer.

# Instalasi

Buka terminal SSH ke router OpenWrt Anda dan jalankan perintah tunggal berikut. Skrip ini akan mengunduh semua file yang diperlukan, menempatkannya di direktori yang benar, mengatur izin, membuat konfigurasi awal, dan memulai layanan secara otomatis.

1. Pertama, lakukan Opkg update :

```
opkg update
```

2. instal paket SSL yang diperlukan:
```
opkg install libustream-openssl ca-bundle ca-certificates
```


3. instal Script AutoLogin:

```
wget -O Installer.sh https://raw.githubusercontent.com/Yoochu123/autologin-openwrt/main/Installer.sh
```

4. Jalankan file yang sudah diunduh
```
sh Installer.sh
```
Setelah instalasi selesai, segarkan (refresh) halaman LuCI Anda. Entri menu baru bernama **"AutoLogin WiFi"** akan muncul di bawah **"Services"**. Klik menu tersebut untuk melakukan konfigurasi.

# Uninstall

Untuk menghapus semua file, konfigurasi, dan layanan yang terkait dengan paket ini, jalankan perintah tunggal berikut di terminal SSH.

```sh
wget -O - https://raw.githubusercontent.com/Yoochu123/autologin-openwrt/main/Uninstall.sh | sh
```

Proses ini akan menghentikan layanan, menghapus semua file terkait, dan membersihkan entri menu dari LuCI.


# Cara Menemukan Konfigurasi Portal

Untuk menggunakan skrip ini, Anda memerlukan dua informasi dari halaman login (captive portal) WiFi publik: **URL Aksi Login** dan **Nama Field Email**. Berikut cara menemukannya menggunakan browser di laptop atau PC.

1.  **Hubungkan ke WiFi**
    Sambungkan perangkat Anda ke jaringan WiFi publik. Halaman login akan muncul secara otomatis di browser Anda.

2.  **Buka Developer Tools**
    Di halaman login tersebut, klik kanan pada kolom tempat Anda biasa memasukkan alamat email, lalu pilih **"Inspect"** atau **"Inspect Element"**. Anda juga bisa menekan tombol `F12` atau `Ctrl+Shift+I` (`Cmd+Opt+I` di Mac).
    Sebuah panel baru akan muncul di samping atau di bawah halaman.

3.  **Cari Elemen `<form>`**
    Di dalam panel Developer Tools, Anda akan melihat kode HTML dari halaman tersebut. Klik pada ikon panah di pojok kiri atas panel (biasanya disebut "Select an element"), lalu klik kembali pada kolom input email di halaman. Ini akan menyorot baris kode `<input>` yang relevan.
    Lihat beberapa baris ke atas dari kode `<input>` yang disorot tersebut hingga Anda menemukan tag pembuka yang diawali dengan `<form ...>`.

4.  **Temukan URL Aksi Login**
    Di dalam tag `<form>` tersebut, cari atribut yang bernama `action`. Nilai dari `action` inilah yang Anda butuhkan untuk kolom **"URL Login Portal"**.

5.  **Temukan Nama Field Email**
    Sekarang, lihat kembali baris `<input>` yang tadi Anda sorot. Di dalam tag tersebut, cari atribut yang bernama `name`. Nilai dari `name` inilah yang Anda butuhkan untuk kolom **"Nama Field Email"**.

### Contoh

Jika Anda menemukan kode HTML seperti ini di Developer Tools:

``
<form method="post" action="[http://connect.wifiprovider.net/login_process](http://connect.wifiprovider.net/login_process)">
    <p>Masukkan email untuk terhubung:</p>
    <input type="text" name="user_email_address" placeholder="email@contoh.com">
    <button type="submit">Connect</button>
</form>
```

Maka konfigurasi yang perlu Anda masukkan ke antarmuka web adalah:
* **URL Login Portal**: `http://connect.wifiprovider.net/login_process`
* **Nama Field Email**: `user_email_address`
