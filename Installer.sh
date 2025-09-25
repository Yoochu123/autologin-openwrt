#!/bin/sh

# --- KONFIGURASI ---
GITHUB_USER="Yoochu123"
GITHUB_REPO="autologin-openwrt"
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
wget -q -O /tmp/autologin.lua "$BASE_URL/autologin.lua"
wget -q -O /tmp/manager.htm "$BASE_URL/manager.htm"


if [ ! -f /tmp/autologin_wifi.sh ] || [ ! -f /tmp/autologin ] || [ ! -f /tmp/autologin_manager ]; then
    log "Gagal mengunduh skrip inti. Cek kembali nama file di repo atau koneksi internet."
    exit 1
fi

# 3. Pindahkan file ke lokasi yang benar
log "Menempatkan file ke direktori sistem..."
mv /tmp/autologin_wifi.sh /usr/bin/
mv /tmp/autologin /etc/init.d/
mv /tmp/autologin_manager /www/cgi-bin/

mkdir -p /usr/lib/lua/luci/controller/
mv /tmp/autologin.lua /usr/lib/lua/luci/controller/

mkdir -p /usr/lib/lua/luci/view/autologin/
mv /tmp/manager.htm /usr/lib/lua/luci/view/autologin/

# 4. Atur izin eksekusi
log "Mengatur izin file..."
chmod +x /usr/bin/autologin_wifi.sh
chmod +x /etc/init.d/autologin
chmod +x /www/cgi-bin/autologin_manager

# 5. Buat konfigurasi awal secara langsung
log "Membuat konfigurasi awal..."
cat <<EOF > /etc/config/autologin
config settings 'settings'
    option url 'http://ganti-dengan-url.portal/login'
    option email_field 'email'
    option enabled '1'
EOF

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