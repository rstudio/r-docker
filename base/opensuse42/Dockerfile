FROM opensuse/leap:42.3

RUN zypper --non-interactive update
RUN zypper --non-interactive --gpg-auto-import-keys -n install \
    fontconfig \
    gcc \
    glibc-locale \
    libatlascpp-0_6-1 \
    libblas3 \
    libcairo2 \
    libfreetype6 \
    libgomp1 \
    libicu52_1 \
    libjpeg62 \
    liblapack3 \
    libtiff5 \
    make \
    pango-tools \
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
