FROM chuyskywalker/centos7-dumbinit-supervisor

# This docker file is HIGHLY non-optimal, but it's for DEV not publishing. The better layer caches make for easier, faster tweaking

RUN yum install -y epel-release
RUN yum install -y iproute nodejs npm python-pip wget unzip
RUN pip install Pygments

RUN wget https://github.com/spf13/hugo/releases/download/v0.16/hugo_0.16_linux-64bit.tgz
RUN tar xvf hugo_0.16_linux-64bit.tgz
RUN mv hugo /usr/bin/hugo

RUN wget https://releases.hashicorp.com/consul/0.6.4/consul_0.6.4_linux_amd64.zip
RUN unzip consul_0.6.4_linux_amd64.zip
RUN mv consul /usr/bin/consul

COPY apps.ini    /config/supervisor/apps.ini
COPY myip.sh     /config/init/myip.sh
COPY consul.json /config/consul.json
