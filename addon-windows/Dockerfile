FROM ghcr.io/dockur/windows:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# Copy your configs
COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf

# Fix permissions
RUN chmod +x /run.sh

ENTRYPOINT ["/run.sh"]
