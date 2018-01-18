FROM   tomcat
MAINTAINER Christopher Hoskin "christopher.hoskin@gmail.com"
# Based on https://github.com/Internet2/tier-idp/
# Original Copyright and License unknown
# Modifications Copyright Christopher Hoskin
# Original Maintainer Mark McCahill "mark.mccahill@duke.edu"

USER root

ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y wget unzip

RUN cd /opt

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

ADD ./configs /build-configs

#
# Install shibboleth IDP
#
RUN export JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 ; \
    export KEYPASS=changeit ; \
    export SEALPASS=changeit ; \
    export SCOPE=cm.ac.uk ; \
    export HOST=cm-idp.$SCOPE ; \
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
    chgrp -R root $IDP_HOME ; \
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
RUN mkdir -p /usr/local/tomcat/conf/Catalina/localhost/
RUN cp /build-configs/idp.xml /usr/local/tomcat/conf/Catalina/localhost/


RUN sed -i 's/https:\/\/cm-idp.cm.ac.uk\//http:\/\/cm-idp.docker:8080\//' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/<!--/ {N;s/\s<SingleLogoutService/--><SingleLogoutService/}' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/\s<SingleLogoutService Binding="urn:oasis:names:tc:SAML:2.0:bindings:SOAP" Location="https:\/\/cm-idp.cm.ac.uk:8443\/idp\/profile\/SAML2\/SOAP\/SLO"\/>/ {N;s/-->//}' /opt/shibboleth-idp/metadata/idp-metadata.xml
# mdui
RUN sed -i 's/<mdui:DisplayName xml:lang="en">A Name for the IdP at cm-idp.cm.ac.uk<\/mdui:DisplayName>/<mdui:DisplayName xml:lang="en">University of Christminster<\/mdui:DisplayName>/' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i 's/<mdui:Description xml:lang="en">Enter a description of your IdP at cm-idp.cm.ac.uk<\/mdui:Description>/<mdui:Description xml:lang="en">Test IdP for the fictitious University of Christminster<\/mdui:Description>/' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i 's/<mdui:Logo height="80" width="80">http:\/\/cm-idp.docker:8080\/Path\/To\/Logo.png<\/mdui:Logo>/<mdui:Logo height="80" width="80">http:\/\/cm-idp.docker:8080\/root\/images\/Christminster.png<\/mdui:Logo>/' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/<!--/ {N;s/\sFill in the details for your IdP here/-->/}' /opt/shibboleth-idp/metadata/idp-metadata.xml
RUN sed -i '/\s<\/mdui:UIInfo>/ {N;s/-->//}' /opt/shibboleth-idp/metadata/idp-metadata.xml

COPY relying-party.xml /opt/shibboleth-idp/conf/relying-party.xml
COPY password-authn-config.xml /opt/shibboleth-idp/conf/authn/password-authn-config.xml
COPY krb5.conf /etc/krb5.conf
COPY attribute-filter.xml /opt/shibboleth-idp/conf/attribute-filter.xml

RUN echo idp.title="University of Christminster Web Login Service">>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.logo=/../root/images/Christminster.png>>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.logo.alt-text="University of Christminster">>/opt/shibboleth-idp/messages/messages.properties ; \
    echo idp.footer="Who knows?">>/opt/shibboleth-idp/messages/messages.properties

RUN mkdir -p /usr/local/tomcat/webapps/ROOT/root/images
COPY Christminster.png /usr/local/tomcat/webapps/ROOT/root/images/Christminster.png
#RUN chown -R tomcat:tomcat /var/lib/tomcat/webapps/root

EXPOSE 8080

