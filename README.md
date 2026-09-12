# IT Infrastructure & DevOps Trainee Assignment

## Overview

This  project demonstrates basic Linux administration, Docker containerization,
reverse proxy setup, Bash scriptings, database backup, and monitoring.

## Project Structure

```text
infra-devops-assignment/
    app/
    nginx/
    monitoring/
    scripts/
    screenshots/
    docker-compose.yml
    README.md

##1. Linux Setup
User

A trainee user was created with sudo access.

SSh

Direct root SSH login is disabled.
SSH uses key-based authentication.
SSH runs on port 2222 instead of the default port 22.
Password authentication is disabled.


Firewall

UFW is configured to allow:

SSH - 2222/tcp
HTTP - 80/tcp
HTTPS - 443/tcp

Check firewall status:

	sudo ufw status verbose



##2. Docker Setup

The application is running using Docker Compose.
Services:

Nginx
Flask application
PostgreSQL
Prometheus
Node Exporter

Nginx

Nginx listens on port 80 and forwards requests to the Flask application.

Nginx configuration:

nginx/nginx.conf

The reverse proxy uses the Docker container name:

flask_app:5000

Test the Nginx configuration:

docker exec nginx nginx -t

Test the application through Nginx:

curl http://localhost

The application can also be accessed from the host machine through the VirtualBox port forwarding:

http://127.0.0.1:8000

## 3. Health Check Script

The health check script is located at:

/opt/scripts/infra_health_check.sh

It checks:

CPU usage
RAM usage
Root disk usage
Docker status
Flask application container status

A warning is written when disk usage goes above 85% or the application
container is stopped.

Logs are stored in:

/var/log/infra_health.log

Sat Sep 12 03:30:01 AM UTC 2026
CPU: 25%
RAM: 51.4%
Disk: 85%
Docker: Running
App: Running

Sat Sep 12 03:45:01 AM UTC 2026
CPU: 4.2%
RAM: 51.6%
Disk: 85%
Docker: Running
App: Running

Sat Sep 12 04:00:02 AM UTC 2026
CPU: 7.7%
RAM: 51.4%
Disk: 85%
Docker: Running
App: Running


Run manually:

sudo /opt/scripts/infra_health_check.sh

View the log:

sudo cat /var/log/infra_health.log


Cron

The health check runs every 15 minutes.

Check the cron job:

sudo crontab -l

Cron entry:

*/15 * * * * /opt/scripts/infra_health_check.sh


##  4. Database Backup

The database backup script is located at:

/opt/scripts/db_backup.sh

The script uses pg_dump from the PostgreSQL Docker container.

Backups are stored in:

/var/backups/db/

Run the backup manually:

sudo /opt/scripts/db_backup.sh

Check the backup:

sudo ls -lh /var/backups/db/

Backup filename format:

db_backup_YYYYMMDD.sql


Restore

To restore a backup:

sudo cat /var/backups/db/db_backup_YYYYMMDD.sql | docker exec -i postgres psql -U appuser appdb


## 5. Monitoring

Prometheus and Node Exporter are used for basic system monitoring.

Node Exporter collects system metrics such as CPU, memory and filesystem
information.

Prometheus collects these metrics from Node Exporter.

Prometheus configuration:

```text
monitoring/prometheus.yml

docker ps

CONTAINER ID   IMAGE                         COMMAND                  CREATED          STATUS             PORTS                                             NAMES
f49438fef11c   nginx:alpine                  "/docker-entrypoint.…"   46 minutes ago   Up 46 minutes      0.0.0.0:80->80/tcp, [::]:80->80/tcp               nginx
dcdfe596682a   infra-devops-assignment-app   "python app.py"          46 minutes ago   Up 46 minutes      5000/tcp                                          flask_app
e40881c8eefe   prom/prometheus:latest        "/bin/prometheus --c…"   46 minutes ago   Up 46 minutes      0.0.0.0:9090->9090/tcp, [::]:9090->9090/tcp       prometheus
0fbe808bc7d6   postgres:16-alpine            "docker-entrypoint.s…"   46 minutes ago   Up 46 minutes      5432/tcp                                          postgres
797b20baf115   prom/node-exporter:latest     "/bin/node_exporter"     46 minutes ago   Up 46 minutes      9100/tcp                                          node-exporter

curl http://localhost:9100/metrics

# HELP promhttp_metric_handler_requests_total Total number of scrapes by HTTP status code.
# TYPE promhttp_metric_handler_requests_total counter
promhttp_metric_handler_requests_total{code="200"} 242
promhttp_metric_handler_requests_total{code="500"} 0
promhttp_metric_handler_requests_total{code="503"} 0

Prometheus can be accessed through:

http://127.0.0.1:9090
