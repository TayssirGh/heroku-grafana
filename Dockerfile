FROM grafana/grafana

USER root

RUN apt-get update && apt-get install -y nginx && rm -rf /var/lib/apt/lists/*

COPY start-grafana.sh /start-grafana.sh
COPY geojson/ /usr/share/grafana/public/maps/
COPY nginx/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /start-grafana.sh

EXPOSE 80

ENTRYPOINT ["/start-grafana.sh"]
