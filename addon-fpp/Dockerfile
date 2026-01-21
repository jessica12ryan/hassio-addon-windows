FROM falconchristmas/fpp:9.5.1

# Home Assistant persistent storage
RUN rm -rf /home/fpp/media && \
    ln -s /data /home/fpp/media

# Make sure permissions are sane
RUN mkdir -p /data && chmod -R 777 /data
