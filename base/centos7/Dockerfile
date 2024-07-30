FROM centos:centos7
LABEL maintainer="Posit Docker <docker@posit.co>"

# Use vault.centos.org since CentOS 7 is EOL and the official mirrors are no longer available
RUN sed -i -e 's|#baseurl=http://mirror.centos.org|baseurl=http://vault.centos.org|g' /etc/yum.repos.d/*

RUN yum -y update && \
    yum -y install \
    fontconfig \
    perl-Digest-MD5 \
    sudo \
    vim \
    wget && \
    yum clean all

# Install TinyTeX
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
    /root/.TinyTeX/bin/*/tlmgr path remove && \
    mv /root/.TinyTeX/ /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin && \
    /opt/TinyTeX/bin/*/tlmgr path add

# Install Pandoc
ARG PANDOC_VERSION=2.19.2
RUN wget https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-amd64.tar.gz -O pandoc.tar.gz && \
    tar -xvf pandoc.tar.gz && \
    mv pandoc-${PANDOC_VERSION} /opt/pandoc && \
    ln -s /opt/pandoc/bin/pandoc /usr/local/bin/pandoc && \
    rm pandoc.tar.gz

# Set default locale
ENV LANG en_US.UTF-8

# Set default timezone
ENV TZ UTC
