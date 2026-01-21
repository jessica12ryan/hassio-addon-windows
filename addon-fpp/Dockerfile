FROM falconchristmas/fpp

# Install jq for JSON editing
RUN apt-get update && apt-get install -y jq && rm -rf /var/lib/apt/lists/*

# Copy startup script
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Override the default entrypoint
CMD ["/run.sh"]
