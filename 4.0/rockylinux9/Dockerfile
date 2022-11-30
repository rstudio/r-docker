#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=rstudio/r-base
FROM ${BASE_IMAGE}:rockylinux9

ARG R_VERSION=4.0.5
ARG OS_IDENTIFIER=rhel-9

# Install R
RUN wget https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/R-${R_VERSION}-1-1.x86_64.rpm && \
    dnf -y install dnf-plugins-core && \
    dnf config-manager --set-enabled crb && \
    dnf -y install epel-release && \
    dnf -y install ./R-${R_VERSION}-1-1.x86_64.rpm && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}-1-1.x86_64.rpm && \
    dnf -y remove epel-release && \
    dnf config-manager --set-disabled crb && \
    dnf clean all

CMD ["R"]
