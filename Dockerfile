# Используем базовый образ nginx
FROM nginx:alpine

RUN apk add --no-cache openssl

# Удаляем стандартную конфигурацию nginx
RUN rm /etc/nginx/conf.d/default.conf

# Устанавливаем bash и envsubst (часть gettext)
RUN apk add --no-cache bash gettext

# Копируем шаблон конфигурации и entrypoint-скрипт
COPY nginx.conf.template /etc/nginx/templates/nginx.conf.template
COPY docker-entrypoint.sh /docker-entrypoint.sh

# Делаем скрипт исполняемым
RUN chmod +x /docker-entrypoint.sh

# Устанавливаем entrypoint
ENTRYPOINT ["/docker-entrypoint.sh"]

# Открываем нужные порты
EXPOSE 80 443
