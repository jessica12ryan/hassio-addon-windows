#
# HA addon Dockerfile for FPP (persistent)
# Runs entirely as the 'fpp' user, no sudo required
#

FROM debian:trixie

ARG PHPVER="8.4"

# Install required packages
RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get -yq upgrade && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq \
    git wget curl build-essential cmake python3-setuptools \
    php${PHPVER} php${PHPVER}-cli php${PHPVER}-fpm php${PHPVER}-common php${PHPVER}-curl \
    php${PHPVER}-bcmath php${PHPVER}-sqlite3 php${PHPVER}-zip php${PHPVER}-xml \
    apache2 locales nano net-tools unzip bzip2 && \
    apt-get clean

# Create FPP user
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# Persistent volume folder
RUN mkdir -p /home/fpp /config/fpp && \
    rm -rf /home/fpp/media && \
    ln -s /config/fpp /home/fpp/media && \
    chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

# Set working directory and switch to fpp user
WORKDIR /opt/fpp
USER fpp

# Clone FPP source
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp && \
    git checkout master

# Copy HA-friendly runDocker.sh
COPY Docker/runDocker.sh /opt/fpp/Docker/runDocker.sh
RUN chmod +x /opt/fpp/Docker/runDocker.sh

# Initialize FPP directories (runs as fpp user)
RUN /opt/fpp/src/fppinit start

# Expose FPP ports
VOLUME /config/fpp
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# Start FPP (Apache + PHP + fppinit)
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
