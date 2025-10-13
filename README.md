# Что это
Данная сборка нужна для запуска [Benotes](github.com/coolycow/benotes).

**ВНИМАНИЕ!** Вместо стандартной связки NGINX + PHP-FPM используется Unit.

## Запуск
```shell
docker compose build
```

```shell
docker compose up -d unit
```

## Основное
### Composer:
```shell
docker compose run --rm composer ...
```
Например:
```shell
docker compose run --rm composer update
```

### Artisan:
```shell
docker compose run --rm artisan ...
```
Например:
```shell
docker compose run --rm artisan cache:clear
```