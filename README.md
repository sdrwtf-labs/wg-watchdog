# WireGuard Watchdog

This repository contains a simple, lightweight bash script designed to monitor a WireGuard tunnel and automatically restart the service if the connection drops.

## Why is this needed?
WireGuard is stateless and resolves the endpoint domain (e.g., dynamic DNS) only once when the interface is brought up. If the remote endpoint changes its public IP address, the local WireGuard interface will not automatically re-resolve the domain. It will continue sending packets to the old, dead IP address. 

This watchdog script mitigates the issue by periodically pinging a reliable target inside the tunnel (e.g., the remote VPN gateway). If the ping fails, the script restarts the local WireGuard systemd service, forcing it to fetch the new IP address.

## Files
- `wg-watchdog.sh`: The main bash script.

## Installation & Configuration

1. Clone this repository or copy the script to a logical location on your server (e.g., `/usr/local/bin/`).
```bash
sudo curl -o /usr/local/bin/wg-watchdog.sh https://raw.githubusercontent.com/sdrwtf-labs/wg-watchdog/main/wg-watchdog.sh
```

2. Make the script executable:

```bash
sudo chmod +x /usr/local/bin/wg-watchdog.sh
```

3. Open the script and adjust the configuration variables to match your environment:

```bash
sudo nano /usr/local/bin/wg-watchdog.sh
```

Adjust the following values:

- `TARGET="10.0.0.1"` (The IP address of the remote router/gateway inside the tunnel)
- `INTERFACE="wg-infra"` (The name of your local WireGuard interface)

4. Create a cron job to run the script automatically (e.g., every 5 minutes):

```bash
sudo crontab -e
```

Add the following line at the end of the file:

```text
*/5 * * * * /usr/local/bin/wg-watchdog.sh
```

## Logging

If a downtime is detected and the service is restarted, an entry will be written to `/var/log/wg-watchdog.log` so you can track connection drops over time.

