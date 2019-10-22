FROM php:7.2.14-apache

MAINTAINER Zaytzev.Kirill@yandex.ru

ENV TIMEZONE "Europe/Moscow"


# Packages

RUN apt-get update \
    && apt-get install -y \
    build-essential \
    ca-certificates \
    cpp \
    cron \
    curl \
    gconf-service \
    gearman-tools \
    git \
    gnupg \
    fontconfig \
    fonts-liberation \
    libappindicator1 \
    libasound2 \
    libatk1.0-0 \
    libcairo2 \
    libcups2 \
    libcurl3-dev \
    libc6 \
    libdbus-1-3 \
    libexpat1 \
    libfontconfig1 \
    libfreetype6-dev \
    libgcc1 \
    libgconf-2-4 \
    libgdk-pixbuf2.0-0 \
    libgearman-dev \
    libglib2.0-dev \
    libgtk-3-0 \
    libicu-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libnspr4 \
    libnss3 \
    libmcrypt-dev \
    libpango-1.0-0 \
    libpangocairo-1.0-0 \
    libpng-dev \
    libssl-dev \
    libstdc++6 \
    libxcb1 \
    libxcomposite1 \
    libxcursor1 \
    libxdamage1 \
    libxext6 \
    libxfixes3 \
    libxi6 \
    libxml2-dev \
    libxrandr2 \
    libxrender1 \
    libxss1 \
    libxtst6 \
    libx11-xcb1 \
    libx11-6 \
    locales \
    lsb-release \
    openssl \
    patchelf \
    python \
    unzip \
    vim \
    wget \
    xdg-utils \
    zlib1g-dev

# V8JS

ENV V8_VERSION=7.4.288.21
RUN cd /tmp \
    && git clone https://chromium.googlesource.com/chromium/tools/depot_tools.git --progress --verbose \
    && export PATH="$PATH:/tmp/depot_tools" \
    && fetch v8 \
    && cd v8 \
    && git checkout $V8_VERSION \
    && gclient sync \
    && tools/dev/v8gen.py -vv x64.release -- \
    binutils_path=\"/usr/bin\" \
    target_os=\"linux\" \
    target_cpu=\"x64\" \
    v8_target_cpu=\"x64\" \
    v8_use_external_startup_data=false \
    is_official_build=true \
    is_component_build=true \
    is_cfi=false \
    is_clang=false \
    use_custom_libcxx=false \
    use_sysroot=false \
    use_gold=false \
    use_allocator_shim=false \
    treat_warnings_as_errors=false \
    symbol_level=0 \
    && ninja -C out.gn/x64.release/ \
    && mkdir -p /opt/libv8-7.4/lib \
    && mkdir /opt/libv8-7.4/include \
    && cp out.gn/x64.release/lib*.so out.gn/x64.release/icudtl.dat \
    /opt/libv8-7.4/lib/ \
    && cp -R include/* /opt/libv8-7.4/include/ \
    && for A in /opt/libv8-7.4/lib/*.so; do patchelf --set-rpath '$ORIGIN' $A;done

RUN git clone https://github.com/phpv8/v8js.git /tmp/v8js \
    && cd /tmp/v8js \
    && git checkout php7 && phpize \
    && ./configure LDFLAGS="-lstdc++" --with-v8js=/opt/libv8-7.4 \
    && make all test install

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/freetype2 --with-jpeg-dir=/usr/include/ --with-png-dir=/usr/include/ \
    && docker-php-ext-configure intl \
    && docker-php-ext-install pdo pdo_mysql gd mbstring zip intl bcmath xml curl \
    && docker-php-ext-enable v8js \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
    && echo "xdebug.remote_enable=on" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && echo "xdebug.remote_autostart=off" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini \
    && pecl install mongodb-1.3.4 \
    && docker-php-ext-enable mongodb \
    && curl -LO https://github.com/wcgallego/pecl-gearman/archive/gearman-2.0.5.tar.gz \
    && tar xf gearman-2.0.5.tar.gz \
    && cd pecl-gearman-gearman-2.0.5/ \
    && phpize && ./configure \
    && make && make install \
    && docker-php-ext-enable gearman \
    && cd ../ && rm -r pecl-gearman-gearman-2.0.5/


# Clean apt-get cache

RUN apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Timezone

RUN echo "${TIMEZONE}" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata


# Configuration

COPY config/apache/sites-available /etc/apache2/sites-available/
COPY config/apache /etc/apache2/
COPY config/php /usr/local/etc/php/

EXPOSE 8080

RUN a2dissite 000-default \
    && a2ensite web \
    && a2enmod rewrite \
    && a2enmod headers \
    && a2enmod ssl \
    && a2enmod deflate

RUN sed -i -e 's/# ru_RU.UTF-8 UTF-8/ru_RU.UTF-8 UTF-8/' /etc/locale.gen && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=ru_RU.UTF-8

ENV LANG ru_RU.UTF-8 

