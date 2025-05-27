FROM grafana/grafana

USER root


COPY start-grafana.sh /start-grafana.sh
COPY geojson/ /usr/share/grafana/public/maps/

ENV GF_FEATURE_TOGGLES_ENABLE=dynamic_geojson

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
