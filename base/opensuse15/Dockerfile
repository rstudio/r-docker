FROM opensuse/leap:15.0

RUN zypper --non-interactive update
RUN zypper --non-interactive --gpg-auto-import-keys -n install \
    atlascpp-devel \
    blas-devel \
    fontconfig \
    gcc \
    gcc-c++ \
    gcc-fortran \
    glibc-locale \
    gzip \
    lapack-devel \
    libbz2-devel \
    libcairo2 \
    libcurl-devel \
    libfreetype6 \
    libgomp1 \
    libicu-devel \
    libjpeg62 \
    libreadline6 \
    libtiff5 \
    make \
    pango-tools \
    pcre-devel \
    sudo \
    tar \
    tcl \
    tk \
    vim \
    wget \
    xdg-utils \
    xorg-x11 \
    xorg-x11-fonts-100dpi \
    xorg-x11-fonts-75dpi \
    xz-devel \
    zlib-devel \
    && zypper clean

# Install TinyTeX
RUN wget -qO- "https://yihui.name/gh/tinytex/tools/install-unx.sh" | sh -s - --admin --no-path && \
    mv ~/.TinyTeX /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr path add

# Install pandoc
RUN mkdir -p /opt/pandoc && \
    wget -O /opt/pandoc/pandoc.gz https://files.r-hub.io/pandoc/linux-64/pandoc.gz && \
    gzip -d /opt/pandoc/pandoc.gz && \
    chmod +x /opt/pandoc/pandoc && \
    ln -s /opt/pandoc/pandoc /usr/bin/pandoc && \
    wget -O /opt/pandoc/pandoc-citeproc.gz https://files.r-hub.io/pandoc/linux-64/pandoc-citeproc.gz && \
    gzip -d /opt/pandoc/pandoc-citeproc.gz && \
    chmod +x /opt/pandoc/pandoc-citeproc && \
    ln -s /opt/pandoc/pandoc-citeproc /usr/bin/pandoc-citeproc
