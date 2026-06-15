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
    wget \
    # xz is required to extract TinyTeX .tar.xz binaries
    xz && \
    yum clean all

# Install TinyTeX
# Retry the install: the TinyTeX installer pulls TeX Live packages from a CTAN
# mirror, so a transient mirror/network failure would otherwise fail the build.
RUN for i in 1 2 3; do \
        wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && break; \
        echo "TinyTeX install failed (attempt $i of 3), retrying in 5s..."; \
        [ "$i" = 3 ] && exit 1; \
        sleep 5; \
    done && \
    /root/.TinyTeX/bin/*/tlmgr path remove && \
    mv /root/.TinyTeX/ /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin && \
    /opt/TinyTeX/bin/*/tlmgr path add

# Install Pandoc
ARG PANDOC_VERSION=2.19.2
RUN ARCH=$([ "$(arch)" = "aarch64" ] && echo "arm64" || echo "amd64") && \
    wget "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-${ARCH}.tar.gz" -O pandoc.tar.gz && \
    tar -xvf pandoc.tar.gz && \
    mv "pandoc-${PANDOC_VERSION}" /opt/pandoc && \
    ln -s /opt/pandoc/bin/pandoc /usr/local/bin/pandoc && \
    rm pandoc.tar.gz

# Set default locale
ENV LANG=en_US.UTF-8

# Set default timezone
ENV TZ=UTC
