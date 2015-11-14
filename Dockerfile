FROM cosmiqo/emonbase:latest

MAINTAINER jramer
RUN rm -rf /var/www/html
RUN git clone https://github.com/emoncms/emoncms.git /var/www/html
RUN git clone https://github.com/emoncms/event.git /var/www/html/Modules/event
RUN git clone https://github.com/emoncms/app.git /var/www/html/Modules/app
RUN git clone https://github.com/emoncms/usefulscripts.git /usr/local/bin/emoncms_usefulscripts

RUN apt-get -y update && apt-get install -y php5-mcrypt php5-curl

# Add db setup script
ADD run.sh /run.sh
ADD db.sh /db.sh
RUN chmod 755 /*.sh

# Add MySQL config
ADD my.cnf /etc/mysql/conf.d/my.cnf

# Add supervisord configuration file
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Create required data repositories for emoncms feed engine
RUN mkdir /var/lib/phpfiwa
RUN mkdir /var/lib/phpfina
RUN mkdir /var/lib/phptimeseries
RUN mkdir /var/lib/timestore

# Expose them as volumes for mounting by host
VOLUME ["/etc/mysql", "/var/lib/mysql", "/var/lib/phpfiwa", "/var/lib/phpfina", "/var/lib/phptimeseries"]

EXPOSE 80 3306

WORKDIR /var/www/emoncms
CMD ["/run.sh"]
