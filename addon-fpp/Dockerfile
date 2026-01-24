FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install build and runtime dependencies
RUN apt-get update && apt-get install -y \
    build-essential cmake git wget curl \
    libusb-1.0-0-dev libx11-dev libxext-dev \
    libavcodec-dev libavformat-dev libavutil-dev libswscale-dev \
    libssl-dev libsdl2-dev libsdl2-image-dev libsdl2-ttf-dev \
    python3 python3-pip rsync procps tzdata \
    && rm -rf /var/lib/apt/lists/*

# Create fpp user
RUN groupadd -r fpp && useradd -r -g fpp -d /home/fpp -s /bin/bash fpp

# Create directories
RUN mkdir -p /home/fpp /opt/fpp /config/fpp

# Symlink persistent media
RUN rm -rf /home/fpp/media && ln -s /config/fpp /home/fpp/media

WORKDIR /opt/fpp

# Clone full FPP repo (required to build)
RUN git clone --recurse-submodules https://github.com/FalconChristmas/fpp.git /opt/fpp \
    && git checkout master

# Copy Docker start script as FPP start
RUN mkdir -p scripts \
    && wget -O scripts/start_fpp.sh https://raw.githubusercontent.com/FalconChristmas/fpp/refs/heads/master/Docker/runDocker.sh \
    && chmod +x scripts/start_fpp.sh

# Build FPP from source
RUN mkdir -p build && cd build \
    && cmake ../src \
    && make -j$(nproc)

# Set ownership and permissions
RUN chown -R fpp:fpp /home/fpp /opt/fpp /config/fpp

# Switch to fpp user
USER fpp
WORKDIR /opt/fpp

# Start FPP
CMD ["bash", "/opt/fpp/scripts/start_fpp.sh"]
