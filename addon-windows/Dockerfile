FROM ghcr.io/dockur/windows:latest

RUN apt-get update && apt-get install -y --no-install-recommends \
    nginx \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /run.sh

# We use the standard entrypoint so the image stays "happy"
ENTRYPOINT ["/run.sh"]
