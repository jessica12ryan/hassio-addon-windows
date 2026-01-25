# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ----------- Dockerfile ------------
# -----------------------------------

FROM debian:trixie

ARG PHPVER="8.4"

# -----------------------------
# System updates and packages
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        git wget curl build-essential cmake python3-setuptools \
        php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl \
        php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
        apache2 locales nano net-tools unzip bzip2 \
        graphicsmagick libgraphicsmagick++-dev libmicrohttpd-dev libzstd-dev \
        jq && \
    apt-get clean

# -----------------------------
# Create FPP user and persistent folders
# -----------------------------
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# Persistent HA volume
RUN mkdir -p /config/fpp && \
    mkdir -p /home/fpp && \
    rm -rf /home/fpp/media && \
    ln -s /config/fpp /home/fpp/media && \
    chown -R fpp:fpp /home/fpp /config/fpp

WORKDIR /opt/fpp

# -----------------------------
# Clone FPP repository
# -----------------------------
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp && \
    git checkout master && \
    chown -R fpp:fpp /opt/fpp

# -----------------------------
# Copy HA-friendly run script
# -----------------------------
COPY Docker/runDocker.sh /opt/fpp/Docker/runDocker.sh
RUN chmod +x /opt/fpp/Docker/runDocker.sh

# -----------------------------
# Copy SD installer script
# -----------------------------
COPY SD/FPP_Install.sh /opt/fpp/SD/FPP_Install.sh
RUN chmod +x /opt/fpp/SD/FPP_Install.sh

# -----------------------------
# Non-interactive FPP install
# -----------------------------
USER fpp
RUN yes | /opt/fpp/SD/FPP_Install.sh --skip-apt-install --skip-vlc --branch master

# -----------------------------
# Fix ownership (double-check)
# -----------------------------
USER root
RUN chown -R fpp:fpp /opt/fpp /home/fpp /config/fpp

# -----------------------------
# Persistent volume for HA
# -----------------------------
VOLUME /config/fpp

# -----------------------------
# Ports
# -----------------------------
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# -----------------------------
# Entrypoint
# -----------------------------
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
