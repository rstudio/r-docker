FROM rockylinux:9
LABEL maintainer="Posit Docker <docker@posit.co>"

RUN dnf -y update && \
    dnf -y install \
    fontconfig \
    glibc-langpack-en \
    perl-File-Find \
    sudo \
    vim \
    wget && \
    dnf clean all

# Install TinyTeX
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
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
ENV LANG en_US.UTF-8

# Set default timezone
ENV TZ UTC
