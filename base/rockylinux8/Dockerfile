FROM rockylinux:8
LABEL maintainer="Posit Docker <docker@posit.co>"

RUN dnf -y update && \
    dnf -y install \
    # Some R packages rely on the find command in their configuration scripts
    findutils \
    fontconfig \
    glibc-langpack-en \
    perl-Digest-MD5 \
    perl-Getopt-Long \
    sudo \
    vim \
    wget \
    # xz is required to extract TinyTeX .tar.xz binaries
    xz && \
    dnf clean all

# Install TinyTeX
# Use TeX Live 2025 from historic CTAN to avoid glibc 2.29 requirement in newer binaries.
# Retry the install to mitigate transient connection failures to the pinned mirror.
# NOTE: this is a single pinned mirror, so a sustained outage still fails after 3 tries.
RUN export CTAN_REPO=https://ftp.math.utah.edu/pub/tex/historic/systems/texlive/2025/tlnet-final/ && \
    for i in 1 2 3; do \
        wget -qO- "https://tinytex.yihui.org/install-unx.sh" | sh && break; \
        echo "TinyTeX install failed (attempt $i of 3), retrying in 5s..."; \
        [ "$i" = 3 ] && exit 1; \
        sleep 5; \
    done && \
    /root/.TinyTeX/bin/*/tlmgr path remove && \
    mv /root/.TinyTeX/ /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin && \
    /opt/TinyTeX/bin/*/tlmgr path add

# Install Pandoc
ARG PANDOC_VERSION=2.19.2
RUN ARCH=$([ "$(arch)" = "aarch64" ] && echo "arm64" || echo "amd64") && \
    wget "https://github.com/jgm/pandoc/releases/download/${PANDOC_VERSION}/pandoc-${PANDOC_VERSION}-linux-${ARCH}.tar.gz" -O pandoc.tar.gz && \
    tar -xvf pandoc.tar.gz && \
    mv "pandoc-${PANDOC_VERSION}" /opt/pandoc && \
    ln -s /opt/pandoc/bin/pandoc /usr/local/bin/pandoc && \
    rm pandoc.tar.gz

# Set default locale
ENV LANG=en_US.UTF-8

# Set default timezone
ENV TZ=UTC
