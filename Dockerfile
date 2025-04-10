FROM grafana/grafana

USER root
COPY start-grafana.sh /start-grafana.sh
COPY provisioning/ /etc/grafana/provisioning/

RUN chmod +x /start-grafana.sh

ENTRYPOINT ["/start-grafana.sh"]
