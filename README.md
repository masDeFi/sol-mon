# Solana Validator Monitoring System

This repository contains Ansible playbooks and configurations for setting up a complete monitoring system for Solana validators. The system consists of two main components:

1. **Validator Node Exporter** (`validator-server/`)
   - Installs and configures Node Exporter on Solana validator machines
   - Collects hardware and OS metrics (CPU, memory, disk, network)
   - Exposes metrics on port 9100

2. **Monitoring Server** (`monitor-server/`)
   - Deploys Prometheus and Grafana using Docker
   - Provides pre-configured dashboards for Solana validator monitoring
   - Implements security best practices
   - Exposes Prometheus on port 9090 and Grafana on port 3000

## Architecture

```
[Solana Validator] ──> [Node Exporter (9100)] ──> [Prometheus (9090)] ──> [Grafana (3000)]
```

## Prerequisites

- Ansible installed on the control machine
- Target servers running Ubuntu/Debian
- SSH access to target servers
- Required variables defined in inventory or group vars:
  - `monitoring_user`
  - `monitoring_user_password`
  - `path_to_ssh_key`
  - `node_exporter_version`
  - `node_exporter_listen_addr`

## Quick Start

1. Configure your inventory file with target servers
2. Set required variables in inventory or group vars
3. Deploy the validator node exporter:
   ```bash
   ansible-playbook -i inventory validator-server/playbook.yml
   ```
4. Deploy the monitoring server:
   ```bash
   ansible-playbook -i inventory monitor-server/playbook.yml
   ```

## Security Features

- Dedicated system users for services
- UFW firewall configuration
- fail2ban protection
- Disabled root SSH access
- Docker-based service isolation

## Maintenance

- Node Exporter service: `systemctl status node_exporter`
- Monitoring stack: `systemctl status monitoring-docker-compose`
- Health check script: `/home/<monitoring_user>/check_monitoring.sh`

## Components

### Node Exporter
- Collects system metrics from validator nodes
- Runs as a systemd service
- Configurable listen address and port

### Prometheus
- Version: v2.51.1
- Scrapes metrics from Node Exporters
- Stores time-series data
- Web interface: http://<server-ip>:9090

### Grafana
- Version: 10.2.3
- Pre-configured Solana validator dashboards
- Web interface: http://<server-ip>:3000

## Documentation

- `validator-server/README.md`: Detailed documentation for the validator node exporter setup
- `monitor-server/README.md`: Detailed documentation for the monitoring server setup
