FROM grafana/grafana

USER root


COPY start-grafana.sh /start-grafana.sh
COPY geojson/ /usr/share/grafana/public/maps/

ENV GF_PANELS_ENABLE_ALPHA=true

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
