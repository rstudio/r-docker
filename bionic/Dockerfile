FROM ubuntu:bionic

ENV OS_IDENTIFIER ubuntu-1804

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    git \
    libatlas3-base \
    libcurl4-openssl-dev \
    libicu-dev \
    libxml2-dev \
    locales \
    software-properties-common \
    sudo \
    wget

ARG R_VERSION

# install R
RUN wget -O R-${R_VERSION}.tar.gz https://cdn.rstudio.com/r/${OS_IDENTIFIER}/R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    mkdir -p /opt/R && \
    tar zx -C /opt/R -f ./R-${R_VERSION}.tar.gz && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}.tar.gz

# set default locale
RUN update-locale --reset LANG=C.UTF-8

# set default LANG via Renviron.site
RUN echo "LANG=C.UTF-8" >> /usr/lib/R/etc/Renviron.site
