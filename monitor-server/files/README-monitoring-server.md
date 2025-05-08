Solana Validator Monitoring Server - Management Instructions
=========================================================

This server runs Prometheus and Grafana using Docker Compose, managed by systemd for easy control.

Service Management (as root or with sudo):
------------------------------------------

# Check status
sudo systemctl status monitoring-docker-compose

# Start the stack
sudo systemctl start monitoring-docker-compose

# Stop the stack
sudo systemctl stop monitoring-docker-compose

# Restart the stack
sudo systemctl restart monitoring-docker-compose

# View logs for all containers
cd ~
sudo docker-compose -f ~/docker-compose.yml logs

# View logs for a specific service (e.g., prometheus or grafana)
sudo docker-compose -f ~/docker-compose.yml logs prometheus
sudo docker-compose -f ~/docker-compose.yml logs grafana


Files and Directories:
----------------------
- ~/docker-compose.yml              : Docker Compose configuration
- /opt/monitoring/prometheus/       : Prometheus config and data
- /opt/monitoring/grafana/          : Grafana data and dashboards


If you update the docker-compose.yml or Prometheus/Grafana configs, restart the service:

sudo systemctl restart monitoring-docker-compose


For more details, see the Ansible playbook or contact your system administrator. 


Setting Up Grafana Dashboard
---------------------------

1. **Access Grafana:**
   - Open your web browser and go to your server's Grafana URL (e.g., `http://<server-ip>:3000`).
   - Log in with your Grafana credentials (default is usually `admin`/`admin` on first setup).

2. **Add Prometheus as a Data Source:**
   - In the left sidebar, click the gear icon (⚙️) for **Configuration** > **Data Sources**.
   - Click **Add data source**.
   - Select **Prometheus**.
   - In the **URL** field, enter: `http://localhost:9090`
   - Click **Save & Test** to verify the connection.

3. **Import Dashboard 1860:**
   - In the left sidebar, click the plus icon (+) > **Import**.
   - In the **Import via grafana.com** field, enter `1860` and click **Load**.
   - Select the Prometheus data source you just configured.
   - Click **Import** to add the dashboard.

You should now see the imported dashboard displaying metrics from your Prometheus instance. 

Configuring Your Server IP Address
-------------------------------

Before running the Ansible playbook, you must specify your server's IP address:

1. Open the file `validator-monitoring-setup/host_vars/monitor.yml`.
2. Replace `REPLACE_ME` with your server's IP address, for example:
   
   ```yaml
   ansible_host: 192.241.159.180
   ```
3. Save the file.

**Note:** The `host_vars/monitor.yml` file is excluded from version control to protect your sensitive information. Each user must create or edit this file with their own server's IP address. 