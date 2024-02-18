FROM node:18-slim

ARG ADD_TO_INSTALL=true
ARG VERSION=2.0.0-alpha.26
LABEL org.opencontainers.image.source=https://github.com/ulixee/platform
LABEL org.opencontainers.image.description="The open data platform. This image packages Ulixee Cloud, Hero and the last 2 Chrome versions."
LABEL org.opencontainers.image.licenses=MIT

# fonts
# RUN gpg --keyserver keyserver.ubuntu.com --recv 0E98404D386FA1D9
# RUN gpg --keyserver keyserver.ubuntu.com --recv 6ED0E7B82643E131
# RUN gpg --keyserver keyserver.ubuntu.com --recv F8D2585B8783D481
# RUN gpg --keyserver keyserver.ubuntu.com --recv 54404762BBB6E853
# RUN gpg --keyserver keyserver.ubuntu.com --recv BDE6D2B9216EC7A8

# RUN echo "deb http://deb.debian.org/debian/ buster main contrib non-free" >> /etc/apt/sources.list \
#    && echo "ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true" | debconf-set-selections \
RUN  apt-get update \
    && apt-get install -y \
        fonts-arphic-ukai \
        fonts-arphic-uming \
        fonts-ipafont-mincho \
        fonts-thai-tlwg \
        fonts-kacst \
        fonts-ipafont-gothic \
        fonts-unfonts-core \
        ttf-wqy-zenhei \
        ttf-mscorefonts-installer \
        fonts-freefont-ttf \
        xvfb \
        git \
        curl \
    && apt-get clean \
    && apt-get autoremove -y \
    && rm -rf /var/lib/apt/lists/*

## Uncomment to install ALL google fonts (>2GB extracted)
# RUN mkdir -p /tmp/goog-fonts \
#  && git clone https://github.com/google/fonts.git /tmp/goog-fonts \
#  && find /tmp/goog-fonts/ -type f -name "*.ttf" -exec cp {} "/usr/local/share/fonts/" \; \
#  && rm -rf /tmp/goog-fonts

RUN mkdir -p /opt/bin && chmod +x /dev/shm && mkdir -p /ulixee/browsers

WORKDIR /app/ulixee
ENV BROWSERS_DIR /ulixee/browsers

RUN cd /app/ulixee && yarn init -yp \
    && yarn add @ulixee/cloud@$VERSION \
    && yarn add @ulixee/chrome-121-0 \
    && yarn add @ulixee/chrome-120-0 \
    && yarn add @ulixee/chrome-119-0 \
    && yarn add @ulixee/chrome-118-0 \
    && yarn add @ulixee/chrome-117-0 \
    && yarn add @ulixee/chrome-116-0 \
    && yarn add @ulixee/chrome-115-0 \
    && yarn add @ulixee/chrome-114-0 \
    && yarn add @ulixee/chrome-113-0 \
    && yarn add @ulixee/chrome-112-0 \
    && yarn add @ulixee/chrome-111-0 \
    && yarn add @ulixee/chrome-110-0 \
    && yarn add @ulixee/chrome-109-0 \
    && yarn add @ulixee/chrome-108-0 \
    && yarn add @ulixee/chrome-107-0 \
    && yarn add @ulixee/chrome-106-0 \
    && yarn add @ulixee/chrome-105-0 \
    && $(npx install-browser-deps) \
    && groupadd -r ulixee && useradd -r -g ulixee -G audio,video ulixee \
    && mkdir -p /home/ulixee/Downloads \
    && mkdir -p /home/ulixee/.cache/ulixee \
    && chown -R ulixee:ulixee /home/ulixee \
    && chown -R ulixee:ulixee /ulixee \
    && chown -R ulixee:ulixee /app/ulixee \
    && chmod 777 /tmp \
    && chmod 777 /ulixee/browsers \
    && chmod -R 777 /home/ulixee/.cache/ulixee

# Add below to run as unprivileged user. It's not included by default, but you can use docker run `--user ulixee`.
# USER ulixee

CMD npx @ulixee/cloud start
# To run this docker, please see ./run.sh
