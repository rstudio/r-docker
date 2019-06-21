FROM centos:centos6
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

RUN yum -y update && \
    yum -y groupinstall "Development tools" && \
    yum -y install \
    bzip2-devel \
    dejavu-sans-fonts \
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
    texlive \
    tk \
    vim \
    wget \
    xz-devel \
    zlib-devel && \
    yum clean all

# Install OpenBLAS
RUN yum -y install epel-release && \
    yum -y install openblas-devel && \
    yum -y remove epel-release && \
    yum clean all

# CentOS 6 ships with an older version of C++, which is too old for
# compiling many R packages. This installs an updated software collection
# that provides newer versions of C/C++.
#
# See these references:
# https://access.redhat.com/documentation/en-us/red_hat_software_collections/3/html/3.2_release_notes/chap-usage#sect-Usage-Use
# https://access.redhat.com/solutions/527703
#
# Redhat Software Collections for updated C++
RUN yum install -y centos-release-scl && \
    yum upgrade -y && \
    yum install -y devtoolset-8-gcc \
    devtoolset-8-gcc-c++ \
    devtoolset-8-gcc-gfortran && \
    yum clean all

# Permanently enable newer C/C++ for interactive and non-interactive use.
# Note that this works for RUN instructions using the shell form only.
# RUN instructions using the executable form can enable the newer C/C++ like:
# RUN ["/usr/bin/scl_enable.sh", "gcc", "--version"]
COPY scl_enable.sh /usr/bin/scl_enable.sh
SHELL ["/usr/bin/scl_enable.sh", "/bin/sh", "-c"]
ENTRYPOINT ["/usr/bin/scl_enable.sh"]
CMD ["/bin/bash"]

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
