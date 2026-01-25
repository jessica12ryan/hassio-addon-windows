#
# Official FPP Dockerfile, modified for HA Add-on persistence
#
FROM debian:trixie

# Set noninteractive frontend
ENV DEBIAN_FRONTEND=noninteractive

# Upgrade base system
RUN apt-get update && apt-get -yq upgrade

ARG PHPVER="8.4"

# Packages required for FPP
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

ARG PACKAGE_LIST_DOCKER=ssh

# Optimize apt
RUN echo "force-unsafe-io" > /etc/dpkg/dpkg.cfg.d/02apt-speedup
RUN echo '\
Acquire::http {No-Cache=True;};\
Acquire::https {No-Cache=True;};\
Acquire::Retries "32";\
Acquire::https::Timeout "240";\
Acquire::http::Timeout "240";\
APT::Get::Assume-Yes "true";\
APT::Install-Recommends "false";\
APT::Install-Suggests "false";\
Debug::Acquire::https "true";\
' > /etc/apt/apt.conf.d/99custom

# Install base packages
RUN apt-get update && apt-get install -yq $PACKAGE_LIST
RUN apt-get update && apt-get install -yq $PACKAGE_LIST_DOCKER
RUN apt-get clean

# Create FPP user & directories
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp
RUN mkdir -p /home/fpp /opt/fpp /config/fpp \
    && rm -rf /home/fpp/media \
    && ln -s /config/fpp /home/fpp/media \
    && chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

# Make /run/php writable for PHP-FPM
RUN mkdir -p /run/php && chown -R fpp:fpp /run/php
# Make PHP log writable
RUN mkdir -p /var/log && touch /var/log/php${PHPVER}-fpm.log && chown -R fpp:fpp /var/log

# Copy FPP source (make sure you include SD/ folder here)
COPY ./ /opt/fpp/
COPY SD/FPP_Install.sh /root/FPP_Install.sh
COPY SD/buildVLC.sh /root/buildVLC.sh

# Build VLC (optional, skip failures)
RUN chmod +x /root/buildVLC.sh && ( yes | /root/buildVLC.sh ) || true

# Install FPP (skip apt and VLC since we already installed)
ARG EXTRA_INSTALL_FLAG=
ARG FPPBRANCH=
RUN ( yes | bash /root/FPP_Install.sh $EXTRA_INSTALL_FLAG --branch ${FPPBRANCH:-master} --skip-apt-install --skip-vlc )

# Copy default asoundrc
RUN cp /opt/fpp/etc/asoundrc.plain /root/.asoundrc

# Initialize FPP (creates directories, sets permissions)
RUN /opt/fpp/src/fppinit start

# Expose volume for persistent media
VOLUME /home/fpp/media

# Expose ports
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# Use runDocker.sh as entrypoint (make sure it's executable)
RUN chmod +x /opt/fpp/Docker/runDocker.sh
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
