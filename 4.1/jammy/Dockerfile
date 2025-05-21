#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=posit/r-base
FROM ${BASE_IMAGE}:jammy

ARG R_VERSION=4.1.3
ARG OS_IDENTIFIER=ubuntu-2204

# Install R
RUN wget "https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/r-${R_VERSION}_1_$(dpkg --print-architecture).deb" && \
    apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -f -y "./r-${R_VERSION}_1_$(dpkg --print-architecture).deb" && \
    ln -s "/opt/R/${R_VERSION}/bin/R" /usr/bin/R && \
    ln -s "/opt/R/${R_VERSION}/bin/Rscript" /usr/bin/Rscript && \
    ln -s "/opt/R/${R_VERSION}/lib/R" /usr/lib/R && \
    rm "r-${R_VERSION}_1_$(dpkg --print-architecture).deb" && \
    rm -rf /var/lib/apt/lists/*

CMD ["R"]
