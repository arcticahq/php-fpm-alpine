FROM php:7.4-fpm-alpine

ENV PROJECT_DIR="/var/www/"

# Install Alpine Packages
RUN apk add --update --no-cache shadow postgresql-dev libzip-dev zip icu-libs \
  icu-dev autoconf g++ imagemagick imagemagick-dev libtool make pcre-dev

RUN apk add --update python3 python3-dev make cmake gcc g++ git pkgconf unzip wget py-pip build-base gsl libavc1394-dev libjpeg libjpeg-turbo-dev libpng-dev libdc1394-dev clang tiff-dev libwebp-dev linux-headers

# Install ImageMagick
RUN pecl install imagick && apk del autoconf g++ libtool make pcre-dev

# Install further packages for image optimizing
RUN apk add libwebp-tools optipng gifsicle jpegoptim npm \
  && npm install -g svgo

# Make iconv work with Alphine
RUN apk add --no-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/community/ --allow-untrusted gnu-libiconv
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

# Enable PHP Extensions
RUN docker-php-ext-install pdo_pgsql \
  && docker-php-ext-install zip \
  && docker-php-ext-install bcmath \
  && docker-php-ext-enable imagick \
  && docker-php-ext-install intl

# Set permissions with shadow apk
RUN usermod -u 1000 www-data && groupmod -g 1000 www-data
