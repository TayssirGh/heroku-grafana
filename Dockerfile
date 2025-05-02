FROM grafana/grafana

USER root

COPY start-grafana.sh /start-grafana.sh
COPY geojson/polygon.geojson /usr/share/grafana/public/maps/polygon.geojson
COPY geojson/polygon-centroids.geojson /usr/share/grafana/public/maps/polygon-centroids.geojson
COPY geojson/france-departments.geojson /usr/share/grafana/public/maps/france-departments.geojson

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
