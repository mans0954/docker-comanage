FROM debian
MAINTAINER christopher.hoskin@gmail.com
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y apt-utils
RUN echo krb5-admin-server krb5-admin-server/newrealm note CM.AC.UK | debconf-set-selections 
RUN apt-get install -y krb5-admin-server

RUN mkdir /var/log/kerberos

#COPY kadm5.acl /etc/krb5kdc/kadm5.acl
COPY krb5.conf /etc/krb5.conf
RUN kdb5_util -P password -r CM.AC.UK create -s

RUN kadmin.local -q "add_principal -pw tamesis admin@CM.AC.UK"
RUN kadmin.local -q "add_principal -pw password1 user1@CM.AC.UK"

EXPOSE 88

CMD /usr/sbin/krb5kdc -n
