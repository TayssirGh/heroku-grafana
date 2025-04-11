#!/bin/bash

# === Configuration ===
APP_NAME="grafana-dashboard"

echo "Paste the Heroku PostgreSQL DATABASE_URL:"
read -r DATABASE_URL

# Parse DATABASE_URL to configure the environment for grafana
regex="^postgres://([^:]+):([^@]+)@([^:]+):([0-9]+)/(.+)$"
if [[ $DATABASE_URL =~ $regex ]]; then
  DB_USER="${BASH_REMATCH[1]}"
  DB_PASS="${BASH_REMATCH[2]}"
  DB_HOST="${BASH_REMATCH[3]}"
  DB_PORT="${BASH_REMATCH[4]}"
  DB_NAME="${BASH_REMATCH[5]}"
else
  echo "❌ Invalid DATABASE_URL format."
  exit 1
fi

echo "🛠️ Setting up Heroku app..."
heroku apps:info -a "$APP_NAME" >/dev/null 2>&1 || heroku create "$APP_NAME"
heroku stack:set container -a "$APP_NAME"

#this is to set postgresql as backend storage , we should see these tables in the database: *  public.alert
#                                                                                           *  public.dashboard
#                                                                                           *  public.user
echo "🔑 Setting environment variables on Heroku..."
heroku config:set \
  GRAFANA_DB_HOST="$DB_HOST" \
  GRAFANA_DB_PORT="$DB_PORT" \
  GRAFANA_DB_NAME="$DB_NAME" \
  GRAFANA_DB_USER="$DB_USER" \
  GRAFANA_DB_PASSWORD="$DB_PASS" \
  GF_DATABASE_TYPE=postgres \
  GF_DATABASE_HOST="$DB_HOST:$DB_PORT" \
  GF_DATABASE_NAME="$DB_NAME" \
  GF_DATABASE_USER="$DB_USER" \
  GF_DATABASE_PASSWORD="$DB_PASS" \
  GF_SECURITY_ADMIN_USER=admin \
  GF_SECURITY_ADMIN_PASSWORD=admin \
  GF_DATABASE_SSL_MODE=require  \
  -a "$APP_NAME"

echo "🐳 Logging in to Heroku Container Registry..."
heroku container:login

echo "📦 Building and pushing Grafana Docker image..."
heroku container:push web -a "$APP_NAME"

echo "🚀 Releasing image to Heroku..."
heroku container:release web -a "$APP_NAME"

echo "🌐 Opening Grafana in browser..."
heroku open -a "$APP_NAME"

echo "✅ Done! Grafana deployed to Heroku with PostgreSQL."