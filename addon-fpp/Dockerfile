#
# FPP HA Add-on Dockerfile (persistent, build from source)
#
FROM debian:trixie

# Avoid interactive prompts during apt installs
ENV DEBIAN_FRONTEND=noninteractive

ARG PHPVER="8.4"

# Essential packages (desktop + dev tools for building FPP)
ARG PACKAGE_LIST="alsa-utils arping avahi-daemon avahi-utils locales nano net-tools \
    apache2 apache2-bin apache2-data apache2-utils libavahi-client-dev \
    bc bash-completion btrfs-progs exfatprogs lsof ethtool curl zip unzip bzip2 wireless-tools dos2unix \
    fbi fbset file flite ca-certificates lshw gettext wget iproute2 \
    build-essential ffmpeg gcc g++ gdb vim vim-common bison flex device-tree-compiler dh-autoreconf \
    git hdparm i2c-tools jq less sysstat tcpdump time usbutils usb-modeswitch \
    samba rsync sudo shellinabox dnsmasq hostapd vsftpd ntpsec sqlite3 at haveged samba samba-common-bin \
    mp3info exim4 mailutils dhcp-helper parprouted bridge-utils libiio-utils \
    php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl php-pear \
    php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
    libavcodec-dev libavformat-dev libswresample-dev libswscale-dev libavdevice-dev libavfilter-dev libtag1-dev \
    vorbis-tools libgraphicsmagick++-dev graphicsmagick-libmagick-dev-compat libmicrohttpd-dev \
    gettext x265 libtheora-dev libvorbis-dev libx265-dev iputils-ping mp3gain \
    libmosquitto-dev mosquitto-clients mosquitto libzstd-dev xz-utils zstd gpiod libgpiod-dev libjsoncpp-dev libcurl4-openssl-dev \
    fonts-freefont-ttf flex bison pkg-config libasound2-dev mesa-common-dev qrencode libusb-1.0-0-dev \
    python3-setuptools libssl-dev libtool bsdextrautils iw rsyslog tzdata ccache libsystemd-dev"

# Docker-specific packages
ARG PACKAGE_LIST_DOCKER="ssh"

# Speed up apt
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup \
    && echo 'Acquire::http {No-Cache=True;}; Acquire::https {No-Cache=True;}; Acquire::Retries "32"; Acquire::https::Timeout "240"; Acquire::http::Timeout "240"; APT::Get::Assume-Yes "true"; APT::Install-Recommends "false"; APT::Install-Suggests "false"; Debug::Acquire::https "true";' > /etc/apt/apt.conf.d/99custom

# Install all packages
RUN apt-get update && apt-get install -yq $PACKAGE_LIST $PACKAGE_LIST_DOCKER && apt-get clean

# Create FPP user and directories
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp \
    && mkdir -p /home/fpp /opt/fpp /config/fpp \
    && rm -rf /home/fpp/media \
    && ln -s /config/fpp /home/fpp/media \
    && chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

WORKDIR /opt/fpp

# Clone FPP source code (submodules included)
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp \
    && git checkout master \
    && chown -R fpp:fpp /opt/fpp

# Add the runtime script
RUN mkdir -p /opt/fpp/Docker \
    && wget -O /opt/fpp/Docker/runDocker.sh https://raw.githubusercontent.com/FalconChristmas/fpp/master/Docker/runDocker.sh \
    && chmod +x /opt/fpp/Docker/runDocker.sh

# Build FPP from source
USER fpp
RUN mkdir -p build && cd build \
    && cmake .. \
    && make -j$(nproc)

# Copy .asoundrc for audio
USER root
RUN cp /opt/fpp/etc/asoundrc.plain /root/.asoundrc

# Ensure persistence
VOLUME /home/fpp/media

# Expose FPP ports
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# Runtime entrypoint (starts FPP services at container start)
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
