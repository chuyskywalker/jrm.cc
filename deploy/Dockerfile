FROM chuyskywalker/centos7-dumbinit-supervisor

COPY nginx.repo /etc/yum.repos.d/

RUN yum install -y nginx \
 && yum clean all && rm -rf /var/cache/yum

COPY nginx.ini   /config/supervisor/nginx.ini
COPY consul.json /config/consul/service.json
COPY nginx.conf  /etc/nginx/nginx.conf

# oooooohhh
COPY output/ /var/www/
