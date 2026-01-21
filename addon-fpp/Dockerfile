FROM falconchristmas/fpp:9.5

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY ingress.conf /etc/nginx/conf.d/ingress.conf

EXPOSE 8099

CMD service nginx start && /usr/bin/fppd
