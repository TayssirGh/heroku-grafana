heroku container:login
heroku container:push web -a grafana-dashboard
heroku container:release web -a grafana-dashboard