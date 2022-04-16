FROM php:7.4.28-apache

RUN apt update -y \
    && apt install -y libzip4 libzip-dev libcurl4 libcurl4-openssl-dev libxml2 libxml2-dev libonig-dev \
    && docker-php-ext-install mysqli pdo pdo_mysql zip curl xml mbstring iconv exif json posix \
    && docker-php-ext-enable pdo_mysql zip curl xml mbstring iconv exif json posix \
    && apt clean autoclean \
    && apt autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

COPY providence-1.7.14.tar.gz /tmp/

WORKDIR /var/www/html
RUN mkdir -p providence \
    && tar -xf /tmp/providence-1.7.14.tar.gz --strip-components 1 -C providence \
    && chown -R 33:33 ./providence

RUN rm -rf /tmp/*

COPY entrypoint.sh /
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
