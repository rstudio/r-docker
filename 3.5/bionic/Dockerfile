FROM rstudio/r-base:bionic

ARG R_VERSION=3.5.2
ARG OS_IDENTIFIER=ubuntu-1804

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

CMD ["R"]