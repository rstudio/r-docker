FROM opensuse/leap:42.3
LABEL maintainer="RStudio Docker <docker@rstudio.com>"

RUN zypper --non-interactive update
RUN zypper --non-interactive --gpg-auto-import-keys install \
    fontconfig \
    sudo \
    tar \
    vim \
    wget \
    && zypper clean --all

# Work around issue with expired Let's Encrypt root certificate and OpenSSL 1.0.2,
# which affects downloads from sourceforge.net (and possibly other sites).
# On SLES 12, the issue can be resolved by updating ca-certificates-mozilla, but
# openSUSE 42 (EOL) requires a manual removal of the expired DST Root CA X3 cerificate.
# https://www.openssl.org/blog/blog/2021/09/13/LetsEncryptRootCertExpire/
# https://www.suse.com/support/kb/doc/?id=000020401
RUN rm /usr/share/pki/trust/DST_Root_CA_X3.pem && \
    update-ca-certificates

# Install TinyTeX
RUN wget -qO- "https://yihui.org/tinytex/install-bin-unix.sh" | sh && \
    /root/.TinyTeX/bin/*/tlmgr path remove && \
    mv /root/.TinyTeX/ /opt/TinyTeX && \
    /opt/TinyTeX/bin/*/tlmgr option sys_bin /usr/local/bin && \
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

# Set default locale
ENV LANG C.UTF-8

# Set default timezone
ENV TZ UTC
