#!/bin/sh

# Пути к сертификатам
CERT="/etc/letsencrypt/live/$DOMAIN/fullchain.pem"
KEY="/etc/letsencrypt/live/$DOMAIN/privkey.pem"

# Если сертификатов нет — создаём самоподписанные
if [ ! -f "$CERT" ] || [ ! -f "$KEY" ]; then
    echo "Certificates not found, creating self-signed fallback..."
    mkdir -p "$(dirname "$CERT")"
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout "$KEY" \
        -out "$CERT" \
        -subj "/CN=$DOMAIN"
fi

# Подставляем переменные в конфиг
envsubst '$DOMAIN' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf

# Запускаем Nginx
exec nginx -g "daemon off;"