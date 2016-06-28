FROM chuyskywalker/centos7-dumbinit-supervisor

COPY nginx.repo /etc/yum.repos.d/

RUN yum install -y nginx \
 && yum install -y wget unzip \
\
 && wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip \
 && unzip consul_0.6.4_linux_amd64.zip \
 && rm -r consul_0.6.4_linux_amd64.zip \
 && mv consul /usr/bin/consul \
\
 && yum -y history undo last \
 && rm -rf /var/cache/yum

COPY consul.ini  /config/supervisor/consul.ini
COPY nginx.ini   /config/supervisor/nginx.ini
COPY consul.json /config/consul.json
COPY nginx.conf  /etc/nginx/nginx.conf

# oooooohhh
COPY output/ /var/www/
