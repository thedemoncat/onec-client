FROM demoncat/onec-base:latest as base
LABEL maintainer="Ruslan Zhdanov <nl.ruslan@yandex.ru> (@TheDemonCat)"

ARG TYPE=platform83

ARG ONEC_USERNAME
ARG ONEC_PASSWORD
ARG ONEC_VERSION
ARG TYPE=platform83

ARG ONEGET_VER=v0.5.2
WORKDIR /tmp

RUN set -xe; \
  apt update; \
  apt install --no-install-recommends -y \ 
    curl \
    bash \
    gzip \
    gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad \
    geoclue-2.0 \
    wget \
    net-tools \
    ca-certificates \
    xvfb \
    xserver-xorg-video-dummy \
    dbus-x11 \
    git \
    x11vnc \
    python \
    python-numpy \
    at-spi2-core \
    xfce4; \
  rm -rf /var/lib/apt/lists/*

RUN set -xe; \
  mkdir /tmp/onec; \
  cd /tmp/onec; \ 
  curl -sL http://git.io/oneget.sh > oneget; \
  chmod +x oneget; \ 
  ./oneget --debug get  --extract --rename platform:linux.full.x64@$ONEC_VERSION; \
  ls -la; \
  cd ./downloads/$TYPE/$ONEC_VERSION/server64.$ONEC_VERSION.tar.gz.extract; \ 
  ./setup-full-$ONEC_VERSION-x86_64.run --mode unattended  --enable-components client_thin_fib,server_admin  --installer-language en; \
  cd /tmp; \
  rm -rf /tmp/onec

RUN set -xe \
    && wget https://github.com/novnc/noVNC/archive/v1.0.0.tar.gz --no-check-certificate -O novnc.tar.gz \
    && tar xzf novnc.tar.gz -C /opt \
    && rm novnc.tar.gz

RUN set -xe \
    && git clone https://github.com/novnc/websockify /opt/websockify \
    && cd /opt/websockify \
    && git reset --hard v0.8.0 \
    && ln -s /opt/websockify/run /usr/local/bin/websockify

ENV DISPLAY :100
ENV LANG ru_RU.utf8

COPY config/xorg.conf /usr/share/X11/xorg.conf.d/10-dummy.conf
COPY config/conf.cfg /opt/1C/v8.3/x86_64/conf/
COPY config/nethasp.ini /opt/1C/v8.3/x86_64/conf/
COPY scripts/ /scripts/
COPY entrypoint.sh /entrypoint.sh

RUN  chmod 4755 /entrypoint.sh \
    && chmod 4755 /scripts/* 

ENTRYPOINT [ "/entrypoint.sh" ]

