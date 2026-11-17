# Day 04 — SSH, Networking & Firewall Troubleshooting

**A hands-on Linux infrastructure lab covering secure remote access, network diagnostics, service management, and host-to-VM connectivity.**

## Overview

This project demonstrates practical Linux administration using an Ubuntu virtual machine hosted in Oracle VirtualBox and managed from a Windows environment.

The objective was to establish secure SSH access, inspect Linux networking, manage and verify web services, configure NAT port forwarding, and investigate firewall status.

**Project environment:** Ubuntu 26.04 | Windows PowerShell 7 | Oracle VirtualBox

## Infrastructure Architecture

```text
                 WINDOWS HOST
             PowerShell / Browser
                       |
              127.0.0.1 (Host)
                       |
             +---------+---------+
             |                   |
          SSH :2222           HTTP :8080
             |                   |
             +---------+---------+
                       |
                VIRTUALBOX NAT
                       |
                  UBUNTU VM
                  10.0.2.15
                       |
             +---------+---------+
             |                   |
          SSH :22             HTTP :80
           sshd               Apache2
```

### NAT Port Forwarding

| Service | Host IP | Host Port | Guest Port |
|---|---|---:|---:|
| SSH | 127.0.0.1 | 2222 | 22 |
| HTTP | 127.0.0.1 | 8080 | 80 |

## Technology Stack

| Technology | Purpose |
|---|---|
| Ubuntu Linux | Linux administration environment |
| Windows PowerShell | Host-side administration and testing |
| OpenSSH | Secure remote access |
| Ed25519 | SSH public-key authentication |
| Oracle VirtualBox | Virtual machine and NAT networking |
| Apache2 | Web server |
| UFW | Firewall status inspection |
| `ip`, `ss`, `curl` | Network and connectivity diagnostics |
| `systemctl` | Linux service management |

## Implementation

### 1. SSH Key-Based Authentication

Generated an Ed25519 SSH key pair and configured public-key authentication between Windows and Ubuntu.

Configured an SSH client alias to simplify remote access.

```powershell
ssh web
```

**Validation:** Successfully authenticated and accessed the Ubuntu shell remotely.

### 2. Hostname Resolution

Added a hostname entry to the Windows hosts file:

```text
127.0.0.1 webserver
```

Tested name resolution:

```powershell
ping webserver
```

**Validation:** Windows successfully resolved `webserver` to its loopback address.

*Technical note: This confirms Windows-side hostname resolution. It does not establish direct hostname-based connectivity to the Ubuntu guest.*

### 3. Linux Network Diagnostics

Inspected network interfaces and routing information:

```bash
ip -br addr
ip route
```

Identified listening ports and associated services:

```bash
sudo ss -tulpn
```

Checked the Apache listening socket:

```bash
sudo ss -tlnp | grep ':80'
```

**Validation:** Inspected network interfaces, routing information, and active listening services, including SSH and Apache.

### 4. Apache2 Service Management

Checked the Apache service:

```bash
sudo systemctl status apache2
```

Tested the local HTTP endpoint:

```bash
curl -I http://localhost
```

**Validation:** Apache2 was active and returned a successful HTTP response.

### 5. VirtualBox NAT Port Forwarding

Configured TCP port forwarding to access Ubuntu services through the Windows host.

Tested TCP connectivity:

```powershell
Test-NetConnection 127.0.0.1 -Port 8080
```

Tested the HTTP response:

```powershell
curl.exe -I http://127.0.0.1:8080
```

**Validation:**
- TCP connectivity succeeded.
- Apache HTTP response was received from Windows.
- Host port `8080` successfully forwarded to Ubuntu port `80`.

### 6. UFW Firewall Inspection

Inspected the Ubuntu firewall:

```bash
sudo ufw status verbose
```

Observed status:

```text
Status: inactive
```

**Validation:** Confirmed that UFW was inactive during the lab. No firewall rules were changed, and firewall-blocking scenarios are reserved for future testing.

## Validation Summary

| Test | Result |
|---|---|
| SSH remote login | Successful |
| Windows hostname resolution | Successful |
| Network interface inspection | Completed |
| Routing inspection | Completed |
| Listening-port inspection | Completed |
| Apache2 service verification | Active |
| Local HTTP request | Successful |
| VirtualBox NAT forwarding | Successful |
| Windows-to-Ubuntu HTTP test | Successful |
| UFW status inspection | Inactive |

## Evidence & Screenshots

All project evidence is stored in the [`screenshots/`](./screenshots/) directory.

| File | Description |
|---|---|
| `01-vm-network-information.png` | Ubuntu network interfaces and IP |
| `02-ssh-key-generation.png` | Ed25519 public-key fingerprint |
| `03-ssh-config.png` | SSH client configuration |
| `04-ssh-login-success.png` | Successful remote SSH session |
| `05-hostname-resolution.png` | Windows hostname resolution |
| `06-listening-ports.png` | Linux listening services |
| `07-apache-service-status.png` | Apache2 service status |
| `08-apache-localhost-test.png` | Local HTTP response |
| `09-http-port-forwarding.png` | VirtualBox NAT rules |
| `10-windows-http-test.png` | Windows HTTP connectivity test |
| `11-ufw-status.png` | UFW firewall status |

## Key Technical Skills

- Linux command-line administration
- SSH configuration and authentication
- Network interface and routing inspection
- TCP port and service diagnostics
- Apache2 service management
- VirtualBox NAT networking
- Host-to-guest connectivity testing
- Firewall status investigation
- Windows PowerShell and Ubuntu administration

## Future Improvements

- Configure and test UFW firewall rules.
- Perform controlled network-blocking experiments.
- Investigate SSH connection failures.
- Compare service failures with network connectivity failures.
- Automate recurring Linux health checks.



