FROM centos:centos7
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

RUN yum -y update && \
    yum -y groupinstall "Development tools" && \
    yum -y install \
    atlas-devel \
    blas-devel \
    bzip2-devel \
    gcc \
    gcc-gfortran \
    lapack-devel \
    libcurl-devel \
    libicu-devel \
    libSM \
    libtiff \
    libXmu \
    libXt \
    make \
    pango \
    pcre-devel \
    pcre2-devel \
    perl-Digest-MD5 \
    sudo \
    tcl \
    tk \
    tre \
    vim \
    wget \
    xz-devel \
    zlib-devel && \
    yum clean all

# Install TinyTeX
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh -s - --admin --no-path && \
    mv ~/.TinyTeX /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr path add

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

# Set default locale
ENV LANG en_US.UTF-8
