FROM ghcr.io/dockur/windows:latest

# Switch to root to ensure permissions are correct for HA
USER root

# Clean up any potential lock files from the base image
RUN rm -f /var/lib/dpkg/lock-frontend /var/lib/apt/lists/lock

# Install only the essentials
RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    python3-websockify \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your files
COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /run.sh

# Use ENTRYPOINT instead of CMD for HA stability
ENTRYPOINT ["/run.sh"]
