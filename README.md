# Linux Administration Toolkit

A hands-on, beginner-friendly Linux administration portfolio built on Ubuntu. Each day is a self-contained mini project with its own scripts, documentation, and terminal screenshots as evidence.

## Projects at a Glance

| Day | Project | Focus | Details |
|---|---|---|---|
| 1 | Linux Workspace Setup | Files, logs, searching, tools | [Day1-Linux-Workspace](Day1-Linux-Workspace/README_Day1.md) |
| 2 | Shared Application Directory | Users, groups, permissions, ACLs, automation | [Day2-Shared-App](Day2-Shared-App/README_DAY2.md) |
| 3 | Shared Application Directory | Bash Scripting, systemd, Process Management, Log Monitoring, Service Troubleshooting | [Day3- Troubleshooting with systemd](https://github.com/Qaniya/Linux-Adminstration-Toolkit/tree/b9224b9557ad9fcf64190f6be6d6bbb159d818b8/Day3-%20Troubleshooting%20with%20systemd)

---

## Day 1: Linux Workspace Setup

Built a structured application workspace at `/opt/myapp` and practiced everyday sysadmin tasks.

**What I did**
- Created the `bin`, `config`, `logs`, and `data` directories
- Wrote a sample `app.conf` and a placeholder `start.sh` script
- Generated timestamped `INFO`, `WARN`, and `ERROR` log entries
- Filtered and counted errors with `grep`, saving them to `errors.txt`
- Located config, log, and recently modified files with `find`
- Installed `tree` and `htop` and saved a workspace structure report

**Skills practiced:** `mkdir`, `chown`, `chmod`, `grep`, `find`, output redirection (`>` and `>>`), `apt` package installation

**Evidence:** [Day1-Linux-Workspace/Screenshot](Day1-Linux-Workspace/Screenshot)

---

## Day 2: Shared Application Directory

Automated a shared directory, `/opt/shared-app`, using a repeatable Bash script (`setup.sh`).

**What I did**
- Created the `devs` group and the users `alice`, `bob`, and `viewer`
- Added `alice` and `bob` to `devs`; kept `viewer` outside the group
- Set the directory to `root:devs` with mode `2775` (setgid) so new files inherit the group
- Configured access and default ACLs with `setfacl`
- Tested access: developers can create and edit files, while `viewer` can only read
- Added `/opt/shared-app/bin` to `PATH` and created a `sharedapp` alias
- Made the script idempotent, so it can run repeatedly without errors

**Skills practiced:** `useradd`, `usermod -aG`, `groupadd`, `chown`, `chmod`, setgid, POSIX ACLs (`setfacl`/`getfacl`), `.bashrc`, aliases, `set -euo pipefail`

**Evidence:** [Day2-Shared-App/Screenshot](Day2-Shared-App/Screenshot)

---
## Day 3 – Linux Service Management & Troubleshooting

**Objective:** Learn how to create, manage, monitor, and troubleshoot background services using `systemd` on Ubuntu Linux.

### What I Practised
- Created a Bash worker script to generate timestamped heartbeat logs.
- Configured a custom `systemd` service using a service unit file.
- Started, stopped, restarted, and enabled services.
- Monitored running processes and identified Process IDs (PIDs).
- Checked application logs using `tail` and service logs using `journalctl`.
- Simulated a service failure by using an incorrect `ExecStart` path.
- Diagnosed and fixed the `203/EXEC` error.
- Tested automatic service recovery using `Restart=on-failure`.
- Practised graceful and forced process termination.

### Key Linux Commands
```bash
systemctl status demo-worker
systemctl start demo-worker
systemctl stop demo-worker
systemctl restart demo-worker
systemctl enable demo-worker
systemctl daemon-reload
journalctl -u demo-worker -n 20 --no-pager
tail -f /var/log/worker.log
pgrep -af worker.sh
```

### Skills & Technologies
`Ubuntu Linux` · `Bash Scripting` · `systemd` · `Process Management` · `Log Monitoring` · `Service Troubleshooting` · `Linux Commands`

### Learning Outcome
Gained practical experience managing Linux background services, monitoring application activity, diagnosing service failures, and understanding automatic service recovery.

📁 **Evidence:** [Day3- Troubleshooting with systemd/Screenshot](https://github.com/Qaniya/Linux-Adminstration-Toolkit/tree/b9224b9557ad9fcf64190f6be6d6bbb159d818b8/Day3-%20Troubleshooting%20with%20systemd/Screenshot)
## Repository Structure

```text
Linux-Adminstration-Toolkit/
├── README.md
├── Day1-Linux-Workspace/
│   ├── README_Day1.md
│   ├── bin/start.sh
│   ├── config/app.conf
│   ├── logs/
│   └── Screenshot/
└── Day2-Shared-App/
|    ├── README_DAY2.md
|    ├── setup.sh
|   └── Screenshot/
day-03-service-troubleshooting/
|    ├── worker.sh
|    ├──demo-worker.service
|    ├── README.md
|   └── screenshots
```

## Key Takeaways

- Organizing a Linux file system for an application
- Reading and filtering logs to find problems quickly
- Controlling access with users, groups, permissions, and ACLs
- Writing repeatable Bash scripts to automate administration
- Verifying work by testing as different users

## Roadmap

- Log-summary script (count INFO, WARN, ERROR)
- Monitoring and service management
- Backup and cron automation
- Networking and SSH basics

---

*This is a learning project preparing for entry-level Cloud Support / Cloud Administrator roles.*
