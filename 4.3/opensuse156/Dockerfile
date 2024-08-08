#
# NOTE: THIS DOCKERFILE IS GENERATED VIA "update.sh"
#
# PLEASE DO NOT EDIT IT DIRECTLY.
#

ARG BASE_IMAGE=rstudio/r-base
FROM ${BASE_IMAGE}:opensuse156

ARG R_VERSION=4.3.3
ARG OS_IDENTIFIER=opensuse-156

# Install R
RUN wget https://cdn.posit.co/r/${OS_IDENTIFIER}/pkgs/R-${R_VERSION}-1-1.x86_64.rpm && \
    zypper --non-interactive --no-gpg-checks install ./R-${R_VERSION}-1-1.x86_64.rpm && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}-1-1.x86_64.rpm && \
    zypper clean --all

CMD ["R"]
