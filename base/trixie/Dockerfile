FROM debian:trixie

LABEL maintainer="Posit Docker <docker@posit.co>"

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    curl \
    fontconfig \
    libcurl4-openssl-dev \
    locales \
    perl \
    sudo \
    tzdata \
    wget && \
    rm -rf /var/lib/apt/lists/*

# Install TinyTeX
# Set TMPDIR to / to avoid issues with the default /tmp directory on Ubuntu/Debian.
# The TinyTeX installer downloads a tarball with files owned by 1001:1001. When extracted
# as the root user, these files keep the original ownership with default tar options
# (--no-same-owner to disable that behavior). Ubuntu/Debian have fs.protected_regular
# enabled by default, disallowing root from writing files owned by other users in /tmp,
# which the TinyTeX installer needs to do. Setting TMPDIR to / works around this issue.
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | TMPDIR=/ sh && \
    /root/.TinyTeX/bin/*/tlmgr path remove && \
    mv /root/.TinyTeX/ /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin && \
    /opt/TinyTeX/bin/*/tlmgr path add

# Install Pandoc
ARG PANDOC_VERSION=2.19.2
RUN wget "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-$(dpkg --print-architecture).tar.gz" -O pandoc.tar.gz && \
    tar -xvf pandoc.tar.gz && \
    mv "pandoc-${PANDOC_VERSION}" /opt/pandoc && \
    ln -s /opt/pandoc/bin/pandoc /usr/local/bin/pandoc && \
    rm pandoc.tar.gz

# Set default locale
ENV LANG C.UTF-8

# Set default timezone
ENV TZ UTC
