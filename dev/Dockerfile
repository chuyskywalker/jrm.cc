FROM chuyskywalker/centos7-dumbinit-supervisor

# This docker file is HIGHLY non-optimal, but it's for DEV not publishing. The better layer caches make for easier, faster tweaking

RUN sed -i '/proxy/d' /etc/yum.conf
RUN yum install -y iproute nodejs npm python-pip
RUN pip install Pygments

RUN wget -q https://github.com/spf13/hugo/releases/download/v0.17/hugo_0.17_Linux-64bit.tar.gz
RUN tar xvf hugo_0.17_Linux-64bit.tar.gz
RUN mv hugo_0.17_linux_amd64/hugo_0.17_linux_amd64 /usr/bin/hugo

COPY apps.ini    /config/supervisor/apps.ini
COPY consul.json /config/consul/service.json

RUN yum install -y openssl