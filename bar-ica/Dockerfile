FROM   centos:7

RUN curl http://download.opensuse.org/repositories/home:/rhyssmith:/raptor/CentOS_CentOS-6/home:rhyssmith:raptor.repo -o /etc/yum.repos.d/raptor.repo
RUN yum install -y --skip-broken raptor-ica

RUN sed -i 's/YOUR_ORGANISATION/University of Barsetshire/' /opt/raptor/ica/conf/metadata.xml
RUN sed -i 's/CONTACT_EMAIL/it-support@bar.ac.uk/' /opt/raptor/ica/conf/metadata.xml
RUN sed -i 's/SERVICE_NAME/bar-idp/' /opt/raptor/ica/conf/metadata.xml
RUN sed -i 's/HOSTNAME/bar-idp.bar.ac.uk/' /opt/raptor/ica/conf/metadata.xml

RUN sed -i 's/<value>https:\/\/localhost:8111\/MUA\/MultiUnitAggregator<\/value>/<value>https:\/\/raptor-mua:8111\/MUA\/MultiUnitAggregator<\/value>/' /opt/raptor/ica/conf/event-release.xml

ADD start.sh start.sh
RUN chmod a+x /start.sh

CMD /etc/init.d/raptoricad console
