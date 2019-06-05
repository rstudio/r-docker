#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=rstudio/r-base
FROM ${BASE_IMAGE}:centos6
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

ARG R_VERSION=3.3.3
ARG OS_IDENTIFIER=centos-6

# Install R
RUN wget -O R-${R_VERSION}.tar.gz https://cdn.rstudio.com/r/${OS_IDENTIFIER}/R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    mkdir -p /opt/R && \
    tar zx -C /opt/R -f ./R-${R_VERSION}.tar.gz && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}.tar.gz

# Add support for installing packages with C++11
RUN echo $'CXX11 = g++\n\
CXX11FLAGS = -g -O2 $(LTO)\n\
CXX11PICFLAGS = -fpic\n\
CXX11STD = -std=gnu++11\n' >> $(R RHOME)/etc/Makevars.site

CMD ["R"]
