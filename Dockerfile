FROM php:7.4.3-fpm-alpine3.11
RUN apk --no-cache --update add build-base bash tzdata libzip-dev \
    postgresql-dev postgresql-client libxml2-dev openssl-dev nginx \
    sqlite sqlite-dev busybox-extras shadow busybox-suid coreutils supervisor
RUN docker-php-ext-install zip pdo_pgsql xml
COPY config/nginx.conf /etc/nginx/nginx.conf
COPY config/supervisor.conf /etc/supervisor.conf
RUN rm /etc/nginx/conf.d/default.conf
RUN adduser -D -u 1001 laravel && usermod -aG 0 laravel
RUN chown -R 1001 /var/www/html && \
    chown -R 1001 /run && \
    chown -R 1001 /var/lib/nginx &&  \
    chown -R 1001 /var/log/nginx &&  \
    chgrp -R 0 /var/www/html && \
    chgrp -R 0 /run && \
    chgrp -R 0 /var/lib/nginx && \
    chgrp -R 0 /var/log/nginx && \
    chmod -R g=u /var/www/html && \
    chmod -R g=u /run && \
    chmod -R g=u /var/lib/nginx && \
    chmod -R g=u /var/log/nginx 
USER 1001
WORKDIR /var/www/html
COPY --chown=1001:1001 . .
CMD [ "supervisord", "-c", "/etc/supervisor.conf" ]
EXPOSE 8080

