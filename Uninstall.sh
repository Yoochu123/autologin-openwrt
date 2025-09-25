#!/bin/sh

# --- FUNGSI ---
log() {
    echo "=> $1"
}

# --- PROSES UNINSTALL ---
log "Memulai proses uninstall AutoLogin WiFi Manager..."

# 1. Hentikan dan nonaktifkan layanan
# Pengecekan 'if' dilakukan untuk menghindari error jika layanan sudah dihapus
if [ -f /etc/init.d/autologin ]; then
    log "Menghentikan dan menonaktifkan layanan..."
    /etc/init.d/autologin stop > /dev/null 2>&1
    /etc/init.d/autologin disable > /dev/null 2>&1
fi

# 2. Hapus file-file utama
log "Menghapus file skrip..."
rm -f /usr/bin/autologin_wifi.sh
rm -f /etc/init.d/autologin
rm -f /www/cgi-bin/autologin_manager

# 3. Hapus entri menu LuCI
log "Menghapus entri menu LuCI..."
rm -f /usr/lib/lua/luci/controller/autologin.lua

# 4. Hapus konfigurasi UCI
log "Menghapus konfigurasi..."
uci delete autologin > /dev/null 2>&1
uci commit autologin

# 5. Bersihkan cache LuCI agar menu hilang
log "Membersihkan cache LuCI..."
rm -f /tmp/luci-indexcache

log "-----------------------------------------------------"
log "Uninstall Selesai!"
log "Semua file dan konfigurasi AutoLogin WiFi Manager telah dihapus."
log "Silakan segarkan browser Anda."
log "-----------------------------------------------------"