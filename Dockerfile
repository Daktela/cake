FROM daktela/php-fpm:8.1

# Install PHP and other packages

RUN apk update && \
    apk upgrade --no-cache && \
    apk add --no-cache nginx git curl nodejs npm yarn sudo nano vim ncdu

# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

COPY ./config/nginx/default.conf /etc/nginx/conf.d/default.conf
COPY ./config/nginx/nginx.conf /etc/nginx/nginx.conf
COPY ./config/php/php-ini-xdebug.ini /etc/php81/conf.d/50-xdebug.ini

RUN ln -sf /dev/stdout /var/log/nginx/access.log && ln -sf /dev/stderr /var/log/nginx/error.log

ENV PROJECT_ROOT="/var/www/html/"
ENV USER="www-data"

ENV XDEBUG_HOST=host.docker.internal
ENV XDEBUG_LOG_LEVEL=1
ENV XDEBUG_MODE="off"

RUN mkdir -p $PROJECT_ROOT && \
    mkdir -p /var/lib/nginx/ &&\
    mkdir -p /var/log/nginx/ &&\
    mkdir -p /run/nginx/ &&\
    mkdir -p /home/www/ &&\
    chown $USER:$USER -R ${PROJECT_ROOT} &&\
    chown $USER:$USER -R /var/log/nginx && \
    chown $USER:$USER -R /var/lib/nginx && \
    chown $USER:$USER -R /run/nginx/ && \
    chown $USER:$USER -R /var/log/php81/ && \
    chown $USER:$USER -R /home/www/ && \
    chown $USER:$USER -R /run/php-fpm/ && \
    adduser $USER nginx &&\
    addgroup -g 1000 user &&\
    adduser $USER user &&\
    echo "$USER ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/$USER

WORKDIR $PROJECT_ROOT

ENV PATH="/var/www/html/bin/:$PATH"

ADD ./config/cake/app_local.example.php /tmp

# Prepare entrypoint
ADD ./scripts/entrypoint.sh /usr/local/bin/
ADD ./scripts/daktelaEntrypoint.sh /usr/local/bin/
ADD ./scripts/wait-for-mysql.php /usr/local/bin/

RUN chmod +x /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/daktelaEntrypoint.sh
RUN chmod +x /usr/local/bin/wait-for-mysql.php

#### REMOVE IN FUTURE ###

RUN apk add -t buildtools g++ make autoconf php81-pear php81-dev zlib-dev libevent-dev icu-dev libidn2-dev libidn-dev zlib libevent icu libidn2 libidn curl-dev && \
    pecl install raphf && \
    echo extension=raphf > /etc/php81/conf.d/00_raphf.ini && \
    yes | yes | yes | yes | yes | yes | pecl install pecl_http && \
    echo extension=http.so > /etc/php81/conf.d/00_http.ini && \
    apk del buildtools

#### REMOVE IN FUTURE ###

RUN ln /usr/local/bin/entrypoint.sh /usr/local/bin/project

USER $USER

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]

EXPOSE 80

CMD ["serve"]
