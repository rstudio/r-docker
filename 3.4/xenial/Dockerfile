FROM rstudio/r:xenial

ENV R_VERSION 3.4.4

# Install R
RUN wget -O R-${R_VERSION}.tar.gz https://cdn.rstudio.com/r/${OS_IDENTIFIER}/R-${R_VERSION}-${OS_IDENTIFIER}.tar.gz && \
    mkdir -p /opt/R && \
    tar zx -C /opt/R -f ./R-${R_VERSION}.tar.gz && \
    ln -s /opt/R/${R_VERSION}/bin/R /usr/bin/R && \
    ln -s /opt/R/${R_VERSION}/bin/Rscript /usr/bin/Rscript && \
    ln -s /opt/R/${R_VERSION}/lib/R /usr/lib/R && \
    rm R-${R_VERSION}.tar.gz

# Set default locale
RUN update-locale --reset LANG=C.UTF-8

# Set default LANG via Renviron.site
RUN echo "LANG=C.UTF-8" >> /usr/lib/R/etc/Renviron.site

CMD ["R"]