FROM fedora
RUN curl http://download.opensuse.org/repositories/home:/rhyssmith:/raptor/Fedora_25/home:rhyssmith:raptor.repo -o /etc/yum.repos.d/raptor.repo
RUN yum install -y raptor-mua

EXPOSE 8111

ADD start.sh start.sh
RUN chmod a+x /start.sh

CMD /start.sh
