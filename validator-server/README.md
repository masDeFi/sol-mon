# Solana Validator Node Exporter Configuration

This directory contains an Ansible playbook (`playbook.yml`) designed to install and configure Node Exporter on a Solana validator machine.

Node Exporter is a Prometheus exporter for hardware and OS metrics, written in Go with pluggable metric collectors. It allows you to measure various machine resources: CPU, memory, disk, network, etc.

## Playbook Details

The `playbook.yml` automates the following:

*   Installs necessary packages (`wget`, `tar`).
*   Creates a dedicated system user for Node Exporter (`node_exporter`).
*   Downloads and extracts the specified version of Node Exporter.
*   Installs the Node Exporter binary to `/opt/node_exporter`.
*   Sets up a systemd service for Node Exporter to ensure it runs on boot and can be managed by systemd.
*   Enables and starts the `node_exporter` service.
*   Verifies that Node Exporter is running and accessible on the configured address (default: `127.0.0.1:9100`).

## Variables

The playbook uses variables to allow for customization, including:

*   `node_exporter_version`: The version of Node Exporter to install.
*   `node_exporter_listen_addr`: The address and port Node Exporter will listen on.

Refer to the `vars` section in `playbook.yml` for a full list of configurable options.

## Usage

To run this playbook, you will need Ansible installed on your control machine. You will also need an inventory file defining the target Solana validator host(s).

Example command:

```bash
ansible-playbook -i <your_inventory_file> playbook.yml
```

## Handlers

The playbook includes a handler to reload the systemd daemon and restart the `node_exporter` service if the systemd service file template changes. 