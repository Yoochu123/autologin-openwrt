#!/bin/sh

# --- FUNGSI ---
log() {
    echo "=> $1"
}

# --- PROSES UNINSTALL ---
log "Memulai proses uninstall AutoLogin WiFi Manager..."

# 1. Hentikan dan nonaktifkan layanan
if [ -f /etc/init.d/autologin ]; then
    log "Menghentikan dan menonaktifkan layanan..."
    /etc/init.d/autologin stop > /dev/null 2>&1
    /etc/init.d/autologin disable > /dev/null 2>&1
fi

# 2. Hapus file-file
log "Menghapus file skrip..."
rm -f /usr/bin/autologin_wifi.sh
rm -f /etc/init.d/autologin
rm -f /www/cgi-bin/autologin_manager
rm -f /usr/lib/lua/luci/controller/autologin.lua
rm -rf /usr/lib/lua/luci/view/autologin

# 3. Hapus konfigurasi UCI
log "Menghapus konfigurasi..."
rm -f /etc/config/autologin

# 4. Bersihkan cache LuCI
log "Membersihkan cache LuCI..."
rm -f /tmp/luci-indexcache

log "-----------------------------------------------------"
log "Uninstall Selesai!"
log "Semua file dan konfigurasi AutoLogin WiFi Manager telah dihapus."
log "-----------------------------------------------------"