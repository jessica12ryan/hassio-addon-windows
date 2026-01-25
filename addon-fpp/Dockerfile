#
# Home Assistant Friendly FPP Dockerfile
# Persistent /config/fpp mapped to /home/fpp/media
#

FROM debian:trixie

# -----------------------------
# Set noninteractive for apt
# -----------------------------
ENV DEBIAN_FRONTEND=noninteractive

# -----------------------------
# Install required packages
# -----------------------------
RUN apt-get update && apt-get -yq upgrade \
    && apt-get install -yq \
        git wget curl build-essential cmake python3-setuptools \
        php8.4 php8.4-cli php8.4-fpm php8.4-common php8.4-curl \
        php8.4-bcmath php8.4-sqlite3 php8.4-zip php8.4-xml \
        apache2 locales nano net-tools unzip bzip2 sudo \
    && apt-get clean

# -----------------------------
# Create FPP user/group
# -----------------------------
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# -----------------------------
# Persistent folders
# -----------------------------
RUN mkdir -p /home/fpp /config/fpp \
    && rm -rf /home/fpp/media \
    && ln -s /config/fpp /home/fpp/media

# -----------------------------
# Clone FPP repo
# -----------------------------
WORKDIR /opt/fpp
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp \
    && git checkout master

# -----------------------------
# Copy HA-friendly runDocker.sh
# -----------------------------
COPY runDocker.sh /opt/fpp/Docker/runDocker.sh
RUN chmod +x /opt/fpp/Docker/runDocker.sh

# -----------------------------
# Set ownership (after FPP exists)
# -----------------------------
RUN chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

# -----------------------------
# Optional: Initialize FPP directories and permissions
# -----------------------------
USER fpp
RUN /opt/fpp/src/fppinit start || true
USER root

# -----------------------------
# Expose ports
# -----------------------------
VOLUME /home/fpp/media
EXPOSE 80 4048/udp 5568/udp 32320/udp 32322 9000/udp 9000/tcp

# -----------------------------
# Entrypoint
# -----------------------------
ENTRYPOINT ["/opt/fpp/Docker/runDocker.sh"]
