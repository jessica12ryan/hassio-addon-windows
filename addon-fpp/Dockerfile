FROM falconchristmas/fpp:master

USER root

RUN rm -rf /home/fpp/media \
 && ln -s /data /home/fpp/media \
 && chown -h fpp:fpp /home/fpp/media

USER fpp
