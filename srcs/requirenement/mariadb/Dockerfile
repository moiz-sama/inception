FROM  debian:12

RUN apt update \
    && apt install mariadb-server -y 

COPY ./tools/db_init.sh /etc

RUN chmod +x /etc/db_init.sh

RUN sed -i 's/^bind-address\s*=.*/bind-address = 0.0.0.0/' /etc/mysql/mariadb.conf.d/50-server.cnf

EXPOSE 3306

ENTRYPOINT [ "/etc/db_init.sh" ]
