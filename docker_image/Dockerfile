FROM alpine:latest AS builder

WORKDIR /app

RUN apk add --no-cache unzip

COPY dvwa.zip .

RUN unzip dvwa.zip && \
    mv DVWA-master/* . && \
    rm -rf DVWA-master dvwa.zip && \
    cp config/config.inc.php.dist config/config.inc.php

FROM php:7.4-apache

RUN docker-php-ext-install mysqli pdo_mysql && \
    docker-php-ext-enable mysqli

WORKDIR /var/www/html

COPY --from=builder /app .

RUN chown -R www-data:www-data /var/www/html