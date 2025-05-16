#!/usr/bin/env bash

# This script performs a series of checks to ensure that the monitoring stack
# (including Prometheus and Grafana) is correctly configured and running.
# It checks the syntax of the docker-compose file, validates the Prometheus
# configuration, checks the status of the containers, and verifies the health
# of the Grafana service. If any checks fail, it provides commands to view
# the logs for further investigation.

set -eo pipefail

BASE_DIR="/opt/monitoring"
COMPOSE_FILE="./docker-compose.yml"
PROM_CONFIG_CONTAINER_PATH="./prometheus/prometheus.yml"

echo
echo "🛠 1. Checking docker-compose syntax..."
docker-compose -f "$COMPOSE_FILE" config >/dev/null
echo "   ✅ docker-compose file syntax OK"

echo
echo "🛠 2. Checking Prometheus config (via promtool)..."
docker-compose -f "$COMPOSE_FILE" run --rm \
  --entrypoint promtool \
  prometheus \
  check config "$PROM_CONFIG_CONTAINER_PATH"
echo "   ✅ Prometheus config syntax OK"


echo
echo "🛠 3. Container status:"
docker-compose -f "$COMPOSE_FILE" ps

echo
echo "🛠 2. Checking Prometheus config (via promtool)..."
docker-compose -f "$COMPOSE_FILE" run --rm \
  --entrypoint promtool \
  prometheus \
  check config "$PROM_CONFIG_CONTAINER_PATH"
echo "   ✅ Prometheus config syntax OK"

echo
echo "🛠 5. Checking Grafana health endpoint..."
GRAF_HEALTH=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3000/api/health || echo "000")
if [[ "$GRAF_HEALTH" == "200" ]]; then
  echo "   ✅ Grafana is healthy (HTTP 200)"
else
  echo "   ❌ Grafana health check failed (HTTP $GRAF_HEALTH)"
fi

echo
echo "🛠 7. If any checks failed, view logs:"
echo "   • Prometheus:   docker-compose -f $COMPOSE_FILE logs prometheus"
echo "   • Grafana:      docker-compose -f $COMPOSE_FILE logs grafana"
echo
