FROM ghcr.io/dockur/windows:latest

# Install jq if needed
RUN apt-get update && apt-get install -y jq

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Make sure container sees /data (HA config folder)
VOLUME /data

# Start the wrapper script
CMD ["/run.sh"]
