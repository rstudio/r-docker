FROM ubuntu:bionic

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    libatlas3-base \
    libcurl4-openssl-dev \
    libicu-dev \
    locales \
    sudo \
    wget

# Install TinyTeX
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh -s - --admin --no-path && \
    mv ~/.TinyTeX /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr path add