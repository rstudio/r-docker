FROM ubuntu:xenial

ENV OS_IDENTIFIER ubuntu-1604

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y \
    apt-transport-https \
    build-essential \
    curl \
    git \
    libatlas3-base \
    libcurl4-openssl-dev \
    locales \
    software-properties-common \
    sudo \
    wget