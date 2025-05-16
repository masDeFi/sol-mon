# Sol-Mon: Monitoring Server Ansible Playbook

This Ansible playbook sets up a monitoring server for Solana validators using Prometheus and Grafana. It automates the deployment of a complete monitoring stack with security best practices.

## Features

- Automated deployment of Prometheus and Grafana using Docker
- Security hardening:
  - Creates a dedicated monitoring user
  - Disables root SSH access
  - Configures UFW firewall
  - Installs and configures fail2ban
- Systemd service for automatic startup
- Pre-configured Grafana dashboards for Solana validator monitoring

## Prerequisites

- Ansible installed on the control machine
- Target server running Ubuntu/Debian
- SSH access to the target server
- The following variables defined in your inventory or group vars:
  - `monitoring_user`: Username for the monitoring service
  - `monitoring_user_password`: Password for the monitoring user
  - `path_to_ssh_key`: Path to the SSH public key for the monitoring user

## Required Files

The playbook expects the following files to be present in the project structure:
- `../files/prometheus.yml`: Prometheus configuration file
- `../files/monitoring-docker-compose.service.j2`: Systemd service template
- `../files/README-monitoring-server.md`: Additional documentation
- `../scripts/check_monitoring.sh`: Monitoring check script

## Ports Used

The following ports are opened in the firewall:
- 22: SSH
- 9090: Prometheus
- 3000: Grafana
- 9100: Node Exporter

## Components

### Prometheus
- Version: v2.51.1
- Configuration directory: `/home/<monitoring_user>/prometheus`
- Web interface: http://<server-ip>:9090

### Grafana
- Version: 10.2.3
- Data directory: `/home/<monitoring_user>/grafana`
- Web interface: http://<server-ip>:3000
- Default dashboard: Solana Validator

## Usage

1. Ensure all prerequisites are met
2. Define required variables in your inventory or group vars
3. Run the playbook:
   ```bash
   ansible-playbook -i inventory playbook.yml
   ```

## Post-Installation

After installation:
1. Access Grafana at http://<server-ip>:3000
2. Default login credentials will need to be set up
3. Import the Solana validator dashboard
4. Configure Prometheus as a data source in Grafana

## Security Notes

- Root SSH access is disabled
- UFW firewall is enabled with only necessary ports open
- fail2ban is installed for additional security
- All services run under a dedicated monitoring user

## Maintenance

The monitoring stack runs as a systemd service named `monitoring-docker-compose`. You can manage it using standard systemd commands:
```bash
sudo systemctl status monitoring-docker-compose
sudo systemctl restart monitoring-docker-compose
```

## Troubleshooting

A monitoring check script is installed at `/home/<monitoring_user>/check_monitoring.sh` which can be used to verify the health of the monitoring stack. 