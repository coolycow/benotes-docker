#!/bin/sh

# Автоматическое определение типа сервиса
if [ "$1" = "supervisord" ]; then
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf
elif [ -f "/var/www/benotes/artisan" ] && [ "$1" = "artisan" ]; then
    exec php artisan "$@"
elif [ "$1" = "composer" ]; then
    exec composer "$@"
else
    exec php-fpm -y /usr/local/etc/php-fpm.conf -R
fi