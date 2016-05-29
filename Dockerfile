FROM centos:7

RUN yum install -y epel-release
RUN yum install -y python-pip wget nano git
RUN pip install Pygments
RUN wget https://github.com/spf13/hugo/releases/download/v0.15/hugo_0.15_linux_amd64.tar.gz
RUN tar xvf hugo_0.15_linux_amd64.tar.gz
RUN mv hugo_0.15_linux_amd64/hugo_0.15_linux_amd64 /usr/bin/hugo

RUN yum groupinstall -y development && yum install -y glibc-static
RUN git clone https://github.com/c9/core.git /cloud9
RUN cd /cloud9 && scripts/install-sdk.sh

CMD [ "bash" ]
