FROM php:8.1.6-apache

WORKDIR /app

COPY index.php /var/www/html

EXPOSE 80