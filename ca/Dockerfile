FROM php:7.4.28-apache

RUN apt update -y \
    && apt install -y \
        libzip4 libzip-dev libcurl4 libcurl4-openssl-dev libxml2 libxml2-dev libonig-dev \
        graphicsmagick libgraphicsmagick-dev libmagickwand-6.q16-dev \
        ghostscript \
        libreoffice \
        dcraw \
        mediainfo \
        python3-pdfminer pdfminer-data \
        wkhtmltopdf \
        ffmpeg \
    && pecl install imagick gmagick-beta \
    && docker-php-ext-install mysqli pdo pdo_mysql zip curl xml mbstring iconv exif json posix gd \
    && docker-php-ext-enable pdo_mysql zip curl xml mbstring iconv exif json posix gd \
    && docker-php-ext-enable imagick gmagick \
    && apt clean autoclean \
    && apt autoremove --yes \
    && rm -rf /var/lib/{apt,dpkg,cache,log}/

RUN cp "${PHP_INI_DIR}/php.ini-production" "${PHP_INI_DIR}/php.ini"

RUN cd /usr/bin && ln -s pdf2txt pdf2txt.py && ln -s dumppdf dumppdf.py

COPY providence-1.7.14.tar.gz /tmp/

WORKDIR /var/www/html
RUN tar -xf /tmp/providence-1.7.14.tar.gz --strip-components 1 \
    && chown -R 33:33 .

# Patch fix to support newer pdfminer
RUN sed -i \
    -e '386s~100~2~' \
    app/helpers/mediaPluginHelpers.php

RUN sed -i -E \
    -e 's~^(wkhtmltopdf_app)\s*=.*$~\1 = /usr/bin/wkhtmltopdf~' \
    -e 's~^(pdfminer_app)\s*=.*$~\1 = /usr/bin/pdf2txt~' \
    app/conf/external_applications.conf
RUN sed -i -E \
    -e 's~^(accept_all_files_as_media)\s*=.*$~\1 = 1~' \
    app/conf/app.conf

RUN rm -rf /tmp/*

COPY entrypoint.sh /
ENTRYPOINT ["/bin/bash", "/entrypoint.sh"]
