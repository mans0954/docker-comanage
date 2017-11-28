FROM   centos:7
MAINTAINER Christopher Hoskin "christopher.hoskin@gmail.com"
# Based on https://github.com/Internet2/tier-idp/
# Original Copyright and License unknown
# Modifications Copyright Christopher Hoskin
# Original Maintainer Mark McCahill "mark.mccahill@duke.edu"

USER root

RUN yum -y update &&  \
    yum -y install \
             wget \
             unzip; \
    yum clean all

RUN cd /opt

################## start OpenJDK ###################### 
#
RUN yum -y update &&  \
    yum -y install \ 
             java-1.8.0-openjdk.x86_64  \
             java-1.8.0-openjdk-devel.x86_64 ;  \
    mkdir /usr/java ; \
    ln -s /etc/alternatives/java_sdk_1.8.0_openjdk /usr/java/jdk1.8.0_77 ; \
    ln -s /usr/java/jdk1.8.0_77 /usr/java/latest ; \
    yum clean all
#
################## end OpenJDK ################## 

#
# tomcat
#
RUN yum -y update &&  \
    yum -y install \
             tomcat ; \
    yum clean all

#
# Shibboleth IDP
#
RUN set -e ; \
    mkdir /usr/local/dist ; \
    cd /usr/local/dist ; \
    wget http://shibboleth.net/downloads/identity-provider/3.3.1/shibboleth-identity-provider-3.3.1.tar.gz ; \
    wget http://shibboleth.net/downloads/identity-provider/3.3.1/shibboleth-identity-provider-3.3.1.tar.gz.asc ; \
    wget http://shibboleth.net/downloads/identity-provider/3.3.1/shibboleth-identity-provider-3.3.1.tar.gz.sha256 ; \
    wget https://shibboleth.net/downloads/PGP_KEYS ; \
    gpg --import PGP_KEYS ; \
    sha256sum --check shibboleth-identity-provider-3.3.1.tar.gz.sha256 ; \
    gpg shibboleth-identity-provider-3.3.1.tar.gz.asc ; \
    tar -xvzf shibboleth-identity-provider-3.3.1.tar.gz

RUN yum -y update &&  \
    yum -y install \
             openssl ; \
    yum clean all

ADD ./configs /build-configs

#
# Install shibboleth IDP
#
RUN export JAVA_HOME=/usr/java/latest ; \
    export KEYPASS=changeit ; \
    export SEALPASS=changeit ; \
    export SCOPE=bar.ac.uk ; \
    export HOST=bar-idp.$SCOPE ; \
    export ENTITYID=http://$HOST:8080/idp/shibboleth ;  \
    cd /usr/local/dist ;  \
    export DIST=/usr/local/dist/shibboleth-identity-provider-3.3.1 ; \
    export IDP_HOME=/opt/shibboleth-idp ; \
    echo \# Properties controlling the installation of the Shibboleth IdP>$DIST/idp.install.properties ; \
    export SFILE=$DIST/idp.merge.properties ; \
    echo idp.scope=$SCOPE>>$SFILE ; \
    echo idp.entityID=$ENTITYID>>$SFILE ; \
    echo idp.sealer.storePassword=$SEALPASS>>$SFILE ; \
    echo idp.sealer.keyPassword=$SEALPASS>>$SFILE ; \
    echo idp.session.trackSPSessions=true>>$SFILE ; \
    echo idp.session.secondaryServiceIndex=true>>$SFILE ; \
    echo idp.storage.htmlLocalStorage=true>>$SFILE ; \
    echo idp.logout.authenticated = false>>$SFILE ; \
    $DIST/bin/install.sh \
       -Didp.property.file=idp.install.properties \
       -Didp.merge.properties=idp.merge.properties \
       -Didp.src.dir=$DIST \
       -Didp.target.dir=$IDP_HOME \
       -Didp.scope=$SCOPE \
       -Didp.host.name=$HOST \
       -Didp.keystore.password=$KEYPASS \
       -Didp.sealer.password=$SEALPASS \
       -Didp.noprompt=true 

RUN IDP_HOME=/opt/shibboleth-idp ; \
    chgrp -R tomcat $IDP_HOME ; \
    chmod -R g+r $IDP_HOME ; \
    chmod g+w $IDP_HOME/logs ; \
    chmod g+s $IDP_HOME/logs

#
# Install Java Server Tag Library
#
RUN wget https://build.shibboleth.net/nexus/service/local/repositories/thirdparty/content/javax/servlet/jstl/1.2/jstl-1.2.jar \
          -P /usr/share/tomcat/lib/

#
# Deploy to Tomcat
#
RUN cp /build-configs/idp.xml /etc/tomcat/Catalina/localhost/

#
# things we need assuming we end up running systemd
#
ENV container docker
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*;\
rm -f /etc/systemd/system/*.wants/*;\
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*;\
rm -f /lib/systemd/system/anaconda.target.wants/*;
VOLUME [ "/sys/fs/cgroup" ]

RUN systemctl enable tomcat.service

RUN sed -i 's/https:\/\/bar-idp.bar.ac.uk\//http:\/\/bar-idp.docker:8080\//' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/<!--/ {N;s/\s<SingleLogoutService/--><SingleLogoutService/}' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/\s<SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https:\/\/bar-idp.bar.ac.uk:8443\/idp\/profile\/SAML2\/SOAP\/SLO"\/>/ {N;s/-->//}' /opt/shibboleth-idp/metadata/idp-metadata.xml

COPY relying-party.xml /opt/shibboleth-idp/conf/relying-party.xml
COPY password-authn-config.xml /opt/shibboleth-idp/conf/authn/password-authn-config.xml
COPY krb5.conf /etc/krb5.conf
COPY attribute-filter.xml /opt/shibboleth-idp/conf/attribute-filter.xml

RUN echo idp.title="University of Barsetshire Web Login Service">>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.logo=/images/Barsetshire.png>>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.logo.alt-text="University of Barsetshire">>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.footer="Gardez Gresham">>/opt/shibboleth-idp/messages/messages.properties

COPY Barsetshire.png /opt/shibboleth-idp/webapp/images/Barsetshire.png
RUN chown root:tomcat /opt/shibboleth-idp/webapp/images/Barsetshire.png

EXPOSE 8080
CMD ["/usr/sbin/init"]
