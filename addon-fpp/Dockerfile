FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    ca-certificates \
    sudo \
    python3 \
    python3-pip \
    rsync \
    procps \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

# Create fpp user/group
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# Create base directories
RUN mkdir -p /home/fpp \
    /opt/fpp \
    /config/fpp

# Install FPP
WORKDIR /opt
RUN wget -O fpp.tar.gz https://github.com/FalconChristmas/fpp/releases/download/v9.5.1/FPP-v9.5.1.tar.gz \
    && tar xzf fpp.tar.gz \
    && mv FPP-* fpp \
    && rm fpp.tar.gz

# 🔑 CRITICAL PART — persistent media directory
RUN rm -rf /home/fpp/media \
    && ln -s /config/fpp /home/fpp/media

# Permissions (VERY IMPORTANT)
RUN chown -R fpp:fpp /home/fpp /config/fpp /opt/fpp

# Expose FPP web UI
EXPOSE 80

# Switch user
USER fpp

WORKDIR /opt/fpp

# Start FPP
CMD ["bash", "/opt/fpp/scripts/start_fpp.sh"]
