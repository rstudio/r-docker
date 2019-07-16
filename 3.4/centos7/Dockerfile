#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=rstudio/r-base
FROM ${BASE_IMAGE}:centos7

ARG R_VERSION=3.4.4
ARG OS_IDENTIFIER=centos-7

# Install R
RUN wget -O R-${R_VERSION}.tar.gz https://cdn.rstudio.com/r/${OS_IDENTIFIER}/R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    mkdir -p /opt/R && \
    tar zx -C /opt/R -f ./R-${R_VERSION}.tar.gz && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}.tar.gz

# Configure R to use OpenBLAS
RUN mv /opt/R/${R_VERSION}/lib/R/lib/libRblas.so /opt/R/${R_VERSION}/lib/R/lib/libRblas.so.keep && \
    ln -s /usr/lib64/libopenblasp.so /opt/R/${R_VERSION}/lib/R/lib/libRblas.so

CMD ["R"]
