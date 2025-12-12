FROM debian:12

RUN apt update \
    && apt install php8.2-fpm -y\
    && mkdir -p wordpress \
    && apt install mariadb-client -y \
    && apt install curl -y \
    && apt install -y php-mysqli 

RUN sed -i 's|^listen = .*|listen = 0.0.0.0:9000|' /etc/php/8.2/fpm/pool.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x wp-cli.phar \
    && mv wp-cli.phar /usr/local/bin/wp 

COPY tools/wp_init.sh wp_init.sh
RUN chmod +x wp_init.sh

EXPOSE 9000

ENTRYPOINT [ "./wp_init.sh" ]