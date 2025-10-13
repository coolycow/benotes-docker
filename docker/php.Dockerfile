ARG PHP_VERSION=8.3
ARG INSTALL_SUPERVISOR=false

FROM php:${PHP_VERSION}-fpm-alpine AS base

# Общие аргументы
ARG UID=1000
ARG GID=1000
ARG UNAME=benotes
ARG GNAME=benotes
ENV UID=${UID} \
    GID=${GID} \
    UNAME=${UNAME} \
    GNAME=${GNAME} \
    APP_ENV=production

# COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# Установка пользователя
RUN addgroup -g ${GID} --system ${GNAME} && \
    adduser -G ${GNAME} --system -D -s /bin/sh -u ${UID} ${UNAME} && \
    sed -i "s/user = www-data/user = ${UNAME}/g" /usr/local/etc/php-fpm.d/www.conf && \
    sed -i "s/group = www-data/group = ${GNAME}/g" /usr/local/etc/php-fpm.d/www.conf

# Базовые пакеты
RUN apk --update add wget \
    curl \
    git \
    build-base \
    libmcrypt-dev \
    libxml2-dev \
    pcre-dev \
    zlib-dev \
    autoconf \
    cyrus-sasl-dev \
    libgsasl-dev \
    oniguruma-dev \
    supervisor \
    procps \
    icu-dev \
    zip libzip-dev \
    postgresql-dev \
    linux-headers \
    && docker-php-ext-install pdo pdo_mysql pdo_pgsql pgsql opcache exif sockets \
    && docker-php-ext-configure zip && docker-php-ext-install zip \
    && docker-php-ext-configure intl && docker-php-ext-install intl \
    && docker-php-ext-configure pcntl && docker-php-ext-install pcntl

# Установка Redis
RUN mkdir -p /usr/src/php/ext/redis && \
    curl -L https://github.com/phpredis/phpredis/archive/5.3.4.tar.gz | tar xvz -C /usr/src/php/ext/redis --strip 1 && \
    docker-php-ext-install redis

# Супервизор (условная установка)
RUN if [ "$INSTALL_SUPERVISOR" = "true" ]; then \
    apk add --no-cache supervisor && \
    mkdir -p /etc/supervisord.d; \
fi

# Общие конфигурации
COPY php/opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY php/supervisord.conf /etc/supervisord.conf
COPY php/entrypoint.sh /usr/local/bin/entrypoint.sh

WORKDIR /var/www/benotes
USER ${UNAME}

# Динамическая точка входа
ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]