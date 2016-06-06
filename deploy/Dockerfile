FROM chuyskywalker/centos7-dumbinit-supervisor

RUN yum install -y epel-release \
 && yum install -y python-pip wget unzip \
\
 && pip install Pygments \
\
 && wget https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz \
 && tar xvf hugo_0.15_linux_amd64.tar.gz \
 && mv hugo_0.15_linux_amd64/hugo_0.15_linux_amd64 /usr/bin/hugo \
 && rm -rf hugo_0.15_linux_amd64.tar.gz hugo_0.15_linux_amd64 \
\
 && wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip \
 && unzip consul_0.6.4_linux_amd64.zip \
 && mv consul /usr/bin/consul \
 && rm -r consul_0.6.4_linux_amd64.zip \
\
 && yum -y history undo last \
 && yum -y remove epel-release \
 && rm -rf /var/cache/yum

COPY apps.ini /config/supervisor/apps.ini
