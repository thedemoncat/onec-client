ARG ONEC_VERSION

FROM ghcr.io/thedemoncat/onec/full:full-${ONEC_VERSION}

# xvfb и xserver используются для разных задач
# "Правильный" образ не должен содержать и то и другое
RUN set -xe \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        wget net-tools ca-certificates \
        xvfb \
        xserver-xorg-video-dummy \
        dbus-x11 \
        git \
        x11vnc \
        python python-numpy \
        at-spi2-core \
    && rm -rf /var/lib/apt/lists/*

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
    && chmod 4755 /scripts/* \
    &&  ln -s /opt/1C/v8.3/x86_64/1cestart /usr/local/bin/1cestart \
    &&  ln -s /opt/1C/v8.3/x86_64/1cv8 /usr/local/bin/1cv8

ENTRYPOINT [ "/entrypoint.sh" ]

