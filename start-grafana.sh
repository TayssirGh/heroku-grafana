#!/bin/bash
# Configure Grafana to use the Heroku-assigned port
export GF_SERVER_HTTP_PORT=$PORT

# Start Grafana
exec grafana server --homepath=/usr/share/grafana
