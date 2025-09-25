#!/bin/sh

LOG_TAG="AutoLoginWiFi-Logic"
CONFIG_FILE="autologin"

log() {
    logger -t "$LOG_TAG" "$1"
}

uci_get_value() {
    uci get "$CONFIG_FILE.$1" 2>/dev/null
}

log "Skrip logika dimulai."

while true; do
    ENABLED=$(uci_get_value 'settings.enabled')
    if [ "$ENABLED" != "1" ]; then
        log "Layanan dinonaktifkan. Skrip akan tidur."
        sleep 60
        continue
    fi

    URL_LOGIN_PORTAL=$(uci_get_value 'settings.url')
    NAMA_FIELD_EMAIL=$(uci_get_value 'settings.email_field')
    PING_HOST="8.8.8.8"
    JEDA_DETIK=15
    
    if ! ping -c 1 -W 5 $PING_HOST > /dev/null 2>&1; then
        log "Koneksi terputus. Mencoba login ke $URL_LOGIN_PORTAL..."
        EMAIL_ACAK=$(head /dev/urandom | tr -dc A-Za-z0-9 | head -c 12)@mail.com
        log "Menggunakan email: $EMAIL_ACAK"
        curl -s -X POST --data "$NAMA_FIELD_EMAIL=$EMAIL_ACAK" "$URL_LOGIN_PORTAL"
        log "Permintaan login telah dikirim."
        sleep 10
    fi
    sleep $JEDA_DETIK
done