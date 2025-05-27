#!/bin/bash
# Configure Grafana to use the Heroku-assigned port
export GF_SERVER_HTTP_PORT=$PORT

nginx

# Start Grafana
grafana server --homepath=/usr/share/grafana


