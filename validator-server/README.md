# Sol-Mon: Validator Node Exporter

This directory contains an Ansible playbook to install and configure Node Exporter on a Solana validator.

Node Exporter is a Prometheus exporter for hardware and OS metrics, written in Go with pluggable metric collectors. It allows you to measure various machine resources: CPU, memory, disk, network, etc.

## Playbook Details

The `playbook.yml` automates the following:

*   Installs necessary packages (`wget`, `tar`).
*   Creates a dedicated system user for Node Exporter (`node_exporter`).
*   Downloads and extracts the specified version of Node Exporter.
*   Installs the Node Exporter binary to `/opt/node_exporter`.
*   Sets up a systemd service for Node Exporter to ensure it runs on boot and can be managed by systemd.
*   Enables and starts the `node_exporter` service.
*   Verifies that Node Exporter is running and accessible.
*   Configures UFW rules to secure access

## Variables

The playbook uses variables to allow for customization, including:

*   `node_exporter_version`: The version of Node Exporter to install.
*   `node_exporter_listen_addr`: The address and port Node Exporter will listen on.

Refer to the `vars` section in `playbook.yml` for a full list of configurable options.

## Usage

To run this playbook, you will need Ansible installed on your control machine. You will also need an inventory file defining the target Solana validator host(s).  

### Setup Inventory file
```bash
cp inventory.ini.example inventory.ini
```
Update to your server configuration


### Run the playbook:
```bash
ansible-playbook -i <your_inventory_file> playbook.yml --limit <server/group>
```

### Next
1. Add new prometheus entry
2. Restart prometheus
3. Create dashboard for server

### Troubleshooting
Test metrics are sharing
```sh
curl http://localhost:9100/metrics | grep "cpu"
```

Confirm ufw rules allow and order
[ 1] <monitor-port>/tcp      ALLOW IN    <monitoring-server-ip>            
[ 2] <monitor-port>/tcp      DENY IN     Anywhere 