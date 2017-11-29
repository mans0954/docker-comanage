FROM debian
MAINTAINER christopher.hoskin@gmail.com

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y php7.0 php7.0-xsl php7.0-pgsql php7.0-ldap php7.0-gd apache2 wget unzip  postgresql-client libapache2-mod-shib2
#RUN wget https://github.com/Internet2/comanage-registry/archive/develop.zip && \
# unzip develop.zip && \
# mv comanage-registry-develop /srv/comanage && \
# rm develop.zip
RUN wget https://github.com/Internet2/comanage-registry/archive/master.zip && \
 unzip master.zip && \
 mv comanage-registry-master /srv/comanage && \
 rm master.zip
#RUN wget https://github.com/Internet2/comanage-registry/archive/3.0.0.tar.gz && \
# tar xf 3.0.0.tar.gz && \
# mv comanage-registry-3.0.0 /srv/comanage && \
# rm 3.0.0.tar.gz


#RUN wget https://github.com/Internet2/comanage-registry/archive/1.0.5.tar.gz && \
# tar xzf 1.0.5.tar.gz && \
# mv comanage-registry-1.0.5 /srv/comanage && \
# rm 1.0.5.tar.gz
RUN ln -s /srv/comanage/app/webroot /var/www/html/registry
ADD comanage.conf /etc/apache2/sites-available/
RUN a2dissite 000-default
RUN a2ensite comanage
RUN a2enmod rewrite
RUN a2enmod shib2

#
RUN cp -r /srv/comanage/app/tmp.dist /var/cache/registry
RUN chown -R www-data /var/cache/registry
RUN chmod 700 /var/cache/registry
RUN ln -s /var/cache/registry /srv/comanage/local/tmp

ADD database.php /srv/comanage/local/Config/database.php
ADD email.php /srv/comanage/local/Config/email.php

ADD start.sh /srv/comanage/local/
RUN chmod a+x /srv/comanage/local/start.sh

# Don't do this in production...
RUN htpasswd -b -c /srv/comanage/local/passwd admin@bar.ac.uk tamesis

RUN ln -s /srv/comanage/app/AvailablePlugin/FileSource /srv/comanage/local/Plugin/FileSource
RUN ln -s /srv/comanage/app/AvailablePlugin/LdapSource /srv/comanage/local/Plugin/LdapSource

COPY shibboleth2.xml /etc/shibboleth/shibboleth2.xml

#RUN wget https://shibboleth.net/downloads/embedded-discovery-service/latest/shibboleth-embedded-ds-1.2.0.tar.gz

#RUN tar xf shibboleth-embedded-ds-1.2.0.tar.gz
#RUN cp shibboleth-embedded-ds-1.2.0/idpselect_config.js /var/www/html/
#RUN cp shibboleth-embedded-ds-1.2.0/idpselect.js /var/www/html/
#RUN cp shibboleth-embedded-ds-1.2.0/idpselect.css /var/www/html/
#RUN cp shibboleth-embedded-ds-1.2.0/index.html /var/www/html/


EXPOSE 80
CMD /srv/comanage/local/start.sh

