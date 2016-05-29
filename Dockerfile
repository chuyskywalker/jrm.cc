FROM centos:7

RUN yum install -y epel-release \
 && yum install -y python-pip wget nano git supervisor \
 && pip install Pygments \
 && wget https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz \
 && tar xvf hugo_0.15_linux_amd64.tar.gz \
 && mv hugo_0.15_linux_amd64/hugo_0.15_linux_amd64 /usr/bin/hugo \
 && rm -rf hugo_0.15_linux_amd64.tar.gz hugo_0.15_linux_amd64 \
 && yum groupinstall -y development \
 && yum install -y glibc-static \
 && git clone https://github.com/c9/core.git /cloud9 \
 && cd /cloud9 && scripts/install-sdk.sh

CMD [ "/usr/bin/supervisord", "-c", "/app/supervisord.conf" ]
