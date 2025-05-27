#!/bin/bash
# Configure Grafana to use the Heroku-assigned port
export GF_SERVER_HTTP_PORT=$PORT

# Start Grafana
grafana server --homepath=/usr/share/grafana


