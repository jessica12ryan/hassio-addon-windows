FROM ghcr.io/dockur/windows:latest

RUN apk add --no-cache git nginx python3 py3-websockify \
  && git clone https://github.com/novnc/noVNC.git /opt/novnc \
  && git clone https://github.com/novnc/websockify /opt/novnc/utils/websockify \
  && chmod +x /opt/novnc/utils/novnc_proxy

COPY run.sh /run.sh
COPY nginx.conf /etc/nginx/nginx.conf
RUN chmod +x /run.sh

CMD [ "/run.sh" ]
