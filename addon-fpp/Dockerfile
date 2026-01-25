# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ----------- Dockerfile ------------
# -----------------------------------

FROM debian:trixie

# -----------------------------
# Environment and dependencies
# -----------------------------
ARG PHPVER="8.4"

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade

# Base packages
RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    git wget curl build-essential cmake python3-setuptools g++ \
    php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl \
    php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
    apache2 locales nano net-tools unzip bzip2 \
    alsa-utils arping avahi-daemon avahi-utils locales nano net-tools \
    apache2 apache2-bin apache2-data apache2-utils \
    libavahi-client-dev bc bash-completion btrfs-progs exfatprogs lsof ethtool curl zip unzip bzip2 \
    wireless-tools dos2unix fbi fbset file flite ca-certificates lshw gettext wget iproute2 \
    build-essential ffmpeg gcc g++ gdb vim vim-common bison flex device-tree-compiler dh-autoreconf \
    git hdparm i2c-tools jq less sysstat tcpdump time usbutils usb-modeswitch \
    samba rsync sudo shellinabox dnsmasq hostapd vsftpd ntpsec sqlite3 at haveged samba samba-common-bin \
    mp3info exim4 mailutils dhcp-helper parprouted bridge-utils libiio-utils \
    libavcodec-dev libavformat-dev libswresample-dev libswscale-dev libavdevice-dev libavfilter-dev libtag1-dev \
    vorbis-tools libgraphicsmagick++-dev graphicsmagick-libmagick-dev-compat libmicrohttpd-dev \
    gettext x265 libtheora-dev libvorbis-dev libx265-dev iputils-ping mp3gain \
    libmosquitto-dev mosquitto-clients mosquitto libzstd-dev xz-utils zstd gpiod libgpiod-dev libjsoncpp-dev libcurl4-openssl-dev \
    fonts-freefont-ttf pkg-config libasound2-dev mesa-common-dev qrencode libusb-1.0-0-dev \
    python3-setuptools libssl-dev libtool bsdextrautils iw rsyslog tzdata ccache libsystemd-dev \
    && apt-get clean

# -----------------------------
# User setup
# -----------------------------
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# Persistent volume setup
RUN mkdir -p /home/fpp /config/fpp && \
    rm -rf /home/fpp/media && \
    ln -s /config/fpp /home/fpp/media && \
    chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

WORKDIR /opt/fpp

# -----------------------------
# Get FPP source
# -----------------------------
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp && \
    git checkout master

# Copy the HA-friendly runDocker.sh
COPY runDocker.sh /opt/fpp/Docker/runDocker.sh
RUN chmod +x /opt/fpp/Docker/runDocker.sh

# Copy the FPP install script
COPY SD/FPP_Install.sh /opt/fpp/SD/FPP_Install.sh
RUN chmod +x /opt/fpp/SD/FPP_Install.sh

# -----------------------------
# Build FPP
# -----------------------------
USER root

# Install FPP non-interactively, bypassing cp/chown errors
RUN yes | bash /opt/fpp/SD/FPP_Install.sh --skip-apt-install --skip-vlc --branch master || true

# Fix ownership after build
RUN chown -R fpp:fpp /opt/fpp /home/fpp /config/fpp

# -----------------------------
# Runtime
# -----------------------------
USER fpp

VOLUME /home/fpp/media

# Ports
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
