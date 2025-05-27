#!/bin/bash
# Configure Grafana to use the Heroku-assigned port
export GF_SERVER_HTTP_PORT=$PORT

# Start Grafana
grafana server --homepath=/usr/share/grafana

sed -i "s/\${PORT}/${PORT}/g" /etc/nginx/nginx.conf

nginx -g 'daemon off;'
