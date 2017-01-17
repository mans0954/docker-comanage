FROM debian
MAINTAINER christopher.hoskin@gmail.com

RUN apt-get update && apt-get install -y php5 apache2 wget unzip php5-pgsql
#RUN wget https://github.com/Internet2/comanage-registry/archive/develop.zip && \
# unzip develop.zip && \
# mv comanage-registry-develop /var/www/html/registry && \
# rm develop.zip
RUN wget https://github.com/Internet2/comanage-registry/archive/1.0.5.tar.gz && \
 tar xzf 1.0.5.tar.gz && \
 mv comanage-registry-1.0.5 /srv/comanage && \
 rm 1.0.5.tar.gz
RUN ln -s /srv/comanage/app/webroot /var/www/html/registry
ADD comanage.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite comanage
RUN a2enmod rewrite

#
RUN cp -r /srv/comanage/app/tmp.dist /var/cache/registry
RUN chown -R www-data /var/cache/registry
RUN chmod 700 /var/cache/registry
RUN ln -s /var/cache/registry /srv/comanage/local/tmp

ADD database.php /srv/comanage/local/Config/database.php

ADD start.sh /
RUN chmod a+x /start.sh

EXPOSE 80
EXPOSE 443
#USER www-data
CMD /start.sh

