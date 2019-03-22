FROM centos:centos6

RUN yum -y update && \
    yum -y install epel-release && \
    yum clean all

RUN yum -y update && \
    yum -y groupinstall "Development tools" && \
    yum -y install \
    gcc \
    libcurl-devel \
    libicu \
    make \
    pcre2 \
    perl-Digest-MD5 \
    sudo \
    tcl \
    texlive \
    tk \
    vim \
    wget && \
    yum clean all

# Install pandoc
RUN mkdir -p /opt/pandoc && \
    wget -O /opt/pandoc/pandoc.gz https://files.r-hub.io/pandoc/linux-64/pandoc.gz && \
    gzip -d /opt/pandoc/pandoc.gz && \
    chmod +x /opt/pandoc/pandoc && \
    ln -s /opt/pandoc/pandoc /usr/bin/pandoc && \
    wget -O /opt/pandoc/pandoc-citeproc.gz https://files.r-hub.io/pandoc/linux-64/pandoc-citeproc.gz && \
    gzip -d /opt/pandoc/pandoc-citeproc.gz && \
    chmod +x /opt/pandoc/pandoc-citeproc && \
    ln -s /opt/pandoc/pandoc-citeproc /usr/bin/pandoc-citeproc
