FROM chuyskywalker/centos7-dumbinit-supervisor

RUN yum install -y epel-release \
 && yum install -y python-pip gcc make gcc-c++ glibc-static git wget \
\
 && pip install Pygments \
\
 && wget https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz \
 && tar xvf hugo_0.15_linux_amd64.tar.gz \
 && mv hugo_0.15_linux_amd64/hugo_0.15_linux_amd64 /usr/bin/hugo \
 && rm -rf hugo_0.15_linux_amd64.tar.gz hugo_0.15_linux_amd64 \
\
 && git clone --depth=1 https://github.com/c9/core.git /cloud9 \
 && cd /cloud9 \
 && scripts/install-sdk.sh \
\
 && yum -y history undo last \
 && yum -y remove epel-release \
 && rm -rf /var/cache/yum

COPY apps.ini /config/supervisor/apps.ini
