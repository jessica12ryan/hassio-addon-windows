# -----------------------------------
# -- FPP Add-on for Home Assistant --
# -----------------------------------
# ----------- Dockerfile ------------
# -----------------------------------

FROM debian:trixie

ARG PHPVER="8.4"

# Install base packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
        git wget curl build-essential python3-setuptools \
        php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl \
        php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
        apache2 locales nano net-tools unzip bzip2 && \
    apt-get clean

# Create FPP user and persistent folders
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp
RUN mkdir -p /home/fpp /config/fpp && \
    rm -rf /home/fpp/media && \
    ln -s /config/fpp /home/fpp/media && \
    chown -R fpp:fpp /home/fpp /config/fpp

# Set working directory
WORKDIR /opt/fpp

# Clone FPP repository
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp && \
    git checkout master

# Copy HA-friendly run script
COPY runDocker.sh /opt/fpp/runDocker.sh
RUN chmod +x /opt/fpp/runDocker.sh

# Copy SD folder with scripts
COPY SD/ /opt/fpp/SD/
RUN chmod +x /opt/fpp/SD/*.sh

# Install FPP (non-interactive)
RUN yes | bash /opt/fpp/SD/FPP_Install.sh --skip-apt-install --skip-vlc --branch master

# Fix ownership again after install
RUN chown -R fpp:fpp /opt/fpp /home/fpp /config/fpp

# Persistent media folder
VOLUME /config/fpp

# Ports
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# Run container as FPP user
USER fpp

# Entry point
ENTRYPOINT ["/opt/fpp/runDocker.sh"]
