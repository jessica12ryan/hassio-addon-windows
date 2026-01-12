FROM ghcr.io/dockur/windows:latest

# Set shell to bash for better error handling
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# Combine commands and clean up cache in one layer to keep the image size down
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nginx \
    python3 \
    python3-pip \
    python3-websockify \
    && git clone --depth 1 https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone --depth 1 https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
