#!/bin/sh

# --- KONFIGURASI ---
GITHUB_USER="NAMA_PENGGUNA_GITHUB"
GITHUB_REPO="NAMA_REPO_ANDA"
BRANCH="main"

BASE_URL="https://raw.githubusercontent.com/$GITHUB_USER/$GITHUB_REPO/$BRANCH"

# --- FUNGSI ---
log() {
    echo "=> $1"
}

# --- PROSES INSTALASI ---
log "Memulai instalasi AutoLogin WiFi Manager..."

# 1. Install dependensi
log "Menginstall dependensi (curl)..."
opkg update > /dev/null 2>&1
opkg install curl > /dev/null 2>&1

# 2. Unduh skrip inti dari GitHub
log "Mengunduh skrip dari GitHub..."
wget -q -O /tmp/autologin_wifi.sh "$BASE_URL/autologin_wifi.sh"
wget -q -O /tmp/autologin "$BASE_URL/autologin"
wget -q -O /tmp/autologin_manager "$BASE_URL/autologin_manager"

if [ ! -f /tmp/autologin_wifi.sh ] || [ ! -f /tmp/autologin ] || [ ! -f /tmp/autologin_manager ]; then
    log "Gagal mengunduh skrip. Cek kembali nama pengguna/repo atau koneksi internet."
    exit 1
fi

# 3. Pindahkan file ke lokasi yang benar
log "Menempatkan file ke direktori sistem..."
mv /tmp/autologin_wifi.sh /usr/bin/
mv /tmp/autologin /etc/init.d/
mv /tmp/autologin_manager /www/cgi-bin/

# 4. Atur izin eksekusi
log "Mengatur izin file..."
chmod +x /usr/bin/autologin_wifi.sh
chmod +x /etc/init.d/autologin
chmod +x /www/cgi-bin/autologin_manager

# 5. Buat konfigurasi awal di UCI
log "Membuat konfigurasi awal..."
uci set autologin.settings='settings'
uci set autologin.settings.url='http://ganti-dengan-url.portal/login'
uci set autologin.settings.email_field='email'
uci set autologin.settings.enabled='1'
uci commit autologin

# --- BAGIAN BARU: Membuat Entri Menu LuCI ---
log "Membuat entri menu LuCI..."
mkdir -p /usr/lib/lua/luci/controller/

# Membuat file controller Lua
cat <<EOF > /usr/lib/lua/luci/controller/autologin.lua
module("luci.controller.autologin", package.seeall)

function index()
    entry({"admin", "services", "autologin"},
          alias("admin", "services", "autologin", "manager"),
          "AutoLogin WiFi",
          10)

    entry({"admin", "services", "autologin", "manager"},
          call("redirect_to_cgi"))
end

function redirect_to_cgi()
    luci.http.redirect("/cgi-bin/autologin_manager")
end
EOF
# --- AKHIR BAGIAN BARU ---

# 6. Aktifkan layanan dan bersihkan cache
log "Mengaktifkan layanan..."
/etc/init.d/autologin enable
/etc/init.d/autologin start

log "Membersihkan cache LuCI..."
rm -f /tmp/luci-indexcache

log "-----------------------------------------------------"
log "Instalasi Selesai!"
log "Sebuah entri menu baru 'AutoLogin WiFi' telah ditambahkan di bawah 'Services'."
log "Silakan segarkan browser Anda dan akses dari sana."
log "-----------------------------------------------------"