FROM fedora
RUN curl http://download.opensuse.org/repositories/home:/rhyssmith:/raptor/Fedora_25/home:rhyssmith:raptor.repo -o /etc/yum.repos.d/raptor.repo
RUN yum install -y raptor-web

RUN sed -i 's/https:\/\/localhost:8111\/MUA\/MultiUnitAggregator/https:\/\/raptor-mua:8111\/MUA\/MultiUnitAggregator/' /opt/raptor/web/conf/mua-endpoints.xml

EXPOSE 8111

ADD start.sh start.sh
RUN chmod a+x /start.sh

CMD /start.sh
