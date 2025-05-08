#!/bin/bash
cd /var/www/seminar || exit 1

echo "---- Pull latest code ----"
git pull origin main

echo "---- Install Composer dependencies ----"
composer install --no-interaction --prefer-dist --optimize-autoloader

echo "---- Run Laravel migration ----"
php artisan migrate --force

echo "---- Cache config, route, view ----"
php artisan config:cache
php artisan route:cache
php artisan view:cache

echo "---- Set file permissions ----"
chown -R www-data:www-data .
chmod -R 755 storage
chmod -R 755 bootstrap/cache

echo "---- Reload PHP-FPM ----"
systemctl reload php8.3-fpm

echo "✅ Deploy complete"
