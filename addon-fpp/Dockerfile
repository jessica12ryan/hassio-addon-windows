# Use the official Falcon Player image as base
FROM falconchristmas/fpp:9.5.1

# Make sure bash is available
RUN apk add --no-cache bash

# Copy our custom entrypoint
COPY run.sh /run.sh
RUN chmod +x /run.sh

# Install FPP binary if missing
RUN cd /home/fpp && \
    chmod +x FPP_Install.sh && \
    ./FPP_Install.sh

# Default working directory
WORKDIR /home/fpp

# Entrypoint
ENTRYPOINT ["/run.sh"]
