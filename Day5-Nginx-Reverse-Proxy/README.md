# Day 05: Deploying a Python Application Behind Nginx Reverse Proxy

![Linux](https://img.shields.io/badge/Linux-Ubuntu-orange?logo=ubuntu)
![Nginx](https://img.shields.io/badge/Web_Server-Nginx-009639?logo=nginx)
![Python](https://img.shields.io/badge/Backend-Python-3776AB?logo=python)
![Networking](https://img.shields.io/badge/Networking-Reverse_Proxy-blue)
![Status](https://img.shields.io/badge/Project-Completed-success)

A hands-on Linux administration project focused on deploying a Python application behind Nginx, configuring local hostname resolution, monitoring HTTP requests, and troubleshooting backend connectivity failures.

## Overview

In this project, I configured Nginx as a reverse proxy to forward incoming client requests to a Python HTTP server running locally on port `3000`.

The objective was to understand how a reverse proxy communicates with a backend application and how to diagnose common HTTP errors using Linux troubleshooting commands and Nginx logs.

## Architecture

```text
              Client / Browser
                     |
                     |
              myapp.local:80
                     |
                     v
             Local Host Resolution
                  /etc/hosts
                     |
                     v
                NGINX SERVER
                  Port 80
                     |
                     |
               Reverse Proxy
                     |
                     v
             Python HTTP Server
               127.0.0.1:3000
                     |
                     v
                HTML Response
```

## Technology Stack

| Technology | Purpose |
|---|---|
| Ubuntu Linux | Operating system |
| Nginx | Web server and reverse proxy |
| Python 3 | Backend HTTP server |
| HTTP | Client-server communication |
| curl | HTTP request testing |
| Linux networking | Port and connectivity inspection |
| Nginx logs | Monitoring and troubleshooting |

## Implementation

### 1. Deploy the Python Application

Started a simple Python HTTP server on localhost port `3000`.

```bash
cd ~/site

python3 -m http.server 3000 --bind 127.0.0.1
```

### 2. Install and Configure Nginx

```bash
sudo apt update
sudo apt install nginx -y

sudo systemctl start nginx
sudo systemctl enable nginx
```

Verified the service:

```bash
sudo systemctl status nginx
```

### 3. Configure Nginx Reverse Proxy

Created the configuration file:

`/etc/nginx/sites-available/myapp`

```nginx
server {
    listen 80;
    server_name myapp.local;

    location / {
        proxy_pass http://127.0.0.1:3000;

        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

Enabled the configuration and validated it:

```bash
sudo ln -s /etc/nginx/sites-available/myapp /etc/nginx/sites-enabled/

sudo rm /etc/nginx/sites-enabled/default

sudo nginx -t

sudo systemctl reload nginx
```

The configuration was also saved in this repository under `nginx/myapp.conf`.

### 4. Configure Local Hostname Resolution

Added the following entry to `/etc/hosts`:

```text
127.0.0.1 myapp.local
```

Verified hostname resolution:

```bash
getent hosts myapp.local
```

### 5. Test the Reverse Proxy

```bash
curl -i http://myapp.local
```

Verified the successful response:

```text
HTTP/1.1 200 OK
```

The Python application's HTML content was successfully returned through Nginx.

### 6. Monitor Nginx Logs

Access log:

```bash
sudo tail -n 10 /var/log/nginx/access.log
```

Error log:

```bash
sudo tail -n 20 /var/log/nginx/error.log
```

Used these logs to inspect successful requests and backend connectivity failures.

## Troubleshooting: Simulating a 502 Bad Gateway

One important part of this project was deliberately stopping the Python backend to simulate an application failure.

**Scenario:** Nginx was running, but the backend application on port `3000` was unavailable.

Tested the request:

```bash
curl -i http://myapp.local
```

Observed:

```text
HTTP/1.1 502 Bad Gateway
```

Checked whether the backend was listening:

```bash
sudo ss -tulpn | grep ':3000'
```

After identifying that the backend was stopped, restarted the Python server:

```bash
cd ~/site

python3 -m http.server 3000 --bind 127.0.0.1
```

Retested the reverse proxy and confirmed that the application returned:

```text
HTTP/1.1 200 OK
```

## HTTP Status Codes Observed

| Status Code | Scenario | Result |
|---|---|---|
| 200 OK | Backend application running | Successful response |
| 502 Bad Gateway | Backend application stopped | Upstream connection failure |

## Troubleshooting Commands Reference

| Command | Purpose |
|---|---|
| `sudo ss -tulpn` | Inspect listening ports |
| `curl -i http://myapp.local` | Test HTTP response and body |
| `curl -I http://myapp.local` | Inspect HTTP response headers |
| `getent hosts myapp.local` | Verify hostname resolution |
| `sudo nginx -t` | Validate Nginx configuration |
| `sudo systemctl status nginx` | Check Nginx service |
| `sudo tail -n 10 /var/log/nginx/access.log` | Inspect access logs |
| `sudo tail -n 20 /var/log/nginx/error.log` | Inspect error logs |

## Key Learnings

- Understanding Nginx reverse proxy architecture.
- Configuring Nginx server blocks.
- Deploying a Python HTTP backend.
- Understanding local hostname resolution.
- Testing HTTP requests using curl.
- Inspecting Nginx access and error logs.
- Diagnosing 502 Bad Gateway errors.
- Restoring backend connectivity and verifying service recovery.

## Future Improvements

- Configure the Python application as a systemd service.
- Implement HTTPS with SSL/TLS.
- Deploy the application on a cloud virtual machine.
- Add advanced monitoring and logging.
- Explore automated deployment.

