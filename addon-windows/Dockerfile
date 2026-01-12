FROM ghcr.io/dockur/windows:latest

# Use apt-get instead of apk for Ubuntu-based images
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    nginx \
    python3 \
    python3-pip \
    python3-websockify \
    && git clone https://github.com/novnc/noVNC.git /opt/novnc \
    && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
    && chmod +x /opt/novnc/utils/novnc_proxy \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /run.sh

# Important: This overrides the original Windows container startup.
# Ensure your run.sh also starts the Windows VM, not just noVNC!
CMD [ "/run.sh" ]
