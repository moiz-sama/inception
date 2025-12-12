FROM debian:12

RUN apt update && apt install nginx -y \
    && apt install openssl -y \
    && mkdir /etc/nginx/ssl \
    && mkdir -p wordpress

COPY conf/default /etc/nginx/sites-available/default

RUN openssl req -x509 -newkey rsa:4096 -keyout /etc/nginx/ssl/key.pem \
    -out /etc/nginx/ssl/cert.pem -days 365 -nodes \
    -subj "/C=MA/MK=/L=BG/O=1337/CN=saderdou.com"

EXPOSE 443

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]