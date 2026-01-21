FROM falconchristmas/fpp

RUN apt-get update && \
    apt-get install -y nginx && \
    rm -rf /var/lib/apt/lists/*

COPY nginx.conf /etc/nginx/nginx.conf
COPY ingress.conf /etc/nginx/conf.d/ingress.conf

# s6 service for nginx
RUN mkdir -p /etc/services.d/nginx

COPY nginx-run /etc/services.d/nginx/run
RUN chmod +x /etc/services.d/nginx/run
