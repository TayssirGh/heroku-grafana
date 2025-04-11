FROM grafana/grafana

USER root
COPY start-grafana.sh /start-grafana.sh

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
