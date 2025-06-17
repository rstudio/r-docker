#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=posit/r-base
FROM ${BASE_IMAGE}:centos7

ARG R_VERSION=4.2.3
ARG OS_IDENTIFIER=centos-7

# Install R
RUN wget "https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/R-${R_VERSION}-1-1.$(arch).rpm" && \
    yum -y install epel-release && \
    yum -y install "./R-${R_VERSION}-1-1.$(arch).rpm" && \
    ln -s "/opt/R/${R_VERSION}/bin/R" /usr/bin/R && \
    ln -s "/opt/R/${R_VERSION}/bin/Rscript" /usr/bin/Rscript && \
    ln -s "/opt/R/${R_VERSION}/lib/R" /usr/lib/R && \
    rm "R-${R_VERSION}-1-1.$(arch).rpm" && \
    yum -y remove epel-release && \
    yum clean all

CMD ["R"]
