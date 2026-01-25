# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ----------- Dockerfile ------------
# -----------------------------------

FROM debian:trixie

ARG PHPVER="8.4"

# -----------------------------
# Base packages
# -----------------------------
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        git wget curl build-essential cmake python3-setuptools \
        php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl \
        php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
        apache2 locales nano net-tools unzip bzip2 sudo && \
    apt-get clean

# -----------------------------
# Create fpp user and persistent directories
# -----------------------------
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp
RUN mkdir -p /home/fpp /config/fpp && \
    rm -rf /home/fpp/media && \
    ln -s /config/fpp /home/fpp/media

# -----------------------------
# Clone FPP repo
# -----------------------------
WORKDIR /opt/fpp
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp && \
    git checkout master

# -----------------------------
# Copy HA-friendly scripts
# -----------------------------
COPY Docker/runDocker.sh /opt/fpp/Docker/runDocker.sh
RUN chmod +x /opt/fpp/Docker/runDocker.sh

COPY SD/FPP_Install.sh /root/FPP_Install.sh

# -----------------------------
# Build FPP from source
# -----------------------------
RUN chmod +x /root/FPP_Install.sh && \
    bash /root/FPP_Install.sh --skip-apt-install --skip-vlc

# Optional: fallback build in case fppinit is missing
RUN mkdir -p /opt/fpp/build && \
    cd /opt/fpp/build && \
    cmake .. && make -j$(nproc)

# -----------------------------
# Fix ownership
# -----------------------------
RUN chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

# -----------------------------
# Persistent volume
# -----------------------------
VOLUME /config/fpp

# -----------------------------
# Ports
# -----------------------------
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# -----------------------------
# Entry point
# -----------------------------
USER fpp
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
