FROM grafana/grafana

USER root

COPY start-grafana.sh /start-grafana.sh
COPY geojson/polygon.geojson /usr/share/grafana/public/maps/polygon.geojson

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
