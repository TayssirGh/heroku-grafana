FROM grafana/grafana

USER root


COPY start-grafana.sh /start-grafana.sh
COPY geojson/ /usr/share/grafana/public/maps/

RUN chmod +x /start-grafana.sh

EXPOSE 80

ENTRYPOINT ["/start-grafana.sh"]
