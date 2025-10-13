ARG PHP_VERSION
FROM unit:1.34.2-php8.3

ARG UID=1000
ARG GID=1000
ARG UNAME=benotes
ARG GNAME=benotes

ENV UID=${UID} \
    GID=${GID} \
    UNAME=${UNAME} \
    GNAME=${GNAME}

WORKDIR /var/www/benotes

# COMPOSER
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

# FOR INSTALL XDEBUG, SWOOLE...
COPY --from=mlocati/php-extension-installer /usr/bin/install-php-extensions /usr/local/bin/

# СОЗДАНИЕ ПОЛЬЗОВАТЕЛЯ И ГРУППЫ
RUN addgroup --system --gid ${GID} ${GNAME} && \
    adduser --system --uid ${UID} --ingroup ${GNAME} \
    --shell /bin/bash --home /home/${UNAME} ${UNAME}
    #mkdir -p /var/lib/unit/certs /var/lib/unit/scripts && \
    #chown -R ${UID}:${GID} /var/lib/unit /var/www /home/${UNAME}

# УСТАНОВКА ПАКЕТОВ И РАСШИРЕНИЙ
RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
        libxml2-dev \
        libonig-dev \
        libicu-dev \
        libzip-dev \
        libssl-dev \
        libpq-dev && \
    docker-php-ext-install -j$(nproc) pdo pdo_mysql pdo_pgsql pgsql opcache exif zip intl pcntl sockets && \
    pecl install redis && \
    docker-php-ext-enable redis && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# ПРАВА ДОСТУПА
RUN mkdir -p /docker-entrypoint.d && \
    chmod 755 /var/lib/unit && \
    chown -R ${UID}:${GID} /docker-entrypoint.d

# КОНФИГУРАЦИИ
COPY ./opcache.ini /usr/local/etc/php/conf.d/opcache.ini
COPY ./app.json /docker-entrypoint.d/app.json
COPY benotes.ru.pem /docker-entrypoint.d/benotes.ru.pem

# Unit должен запускаться от имени root пользователя!!!
# USER ${UID}:${GID}

CMD ["unitd", "--no-daemon", "--control", "unix:/var/run/control.unit.sock"]