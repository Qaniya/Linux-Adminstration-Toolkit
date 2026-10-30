# Linux Administration Toolkit

A hands-on, beginner-friendly Linux administration portfolio built on Ubuntu. Each day is a self-contained mini project with its own scripts, documentation, and terminal screenshots as evidence.

**Author:** Qaniya Naz | BS Cloud Application Development and Operations
**GitHub:** https://github.com/Qaniya

---

## Projects at a Glance

| Day | Project | Focus | Details |
|---|---|---|---|
| 1 | Linux Workspace Setup | Files, logs, searching, tools | [Day1-Linux-Workspace](Day1-Linux-Workspace/README_Day1.md) |
| 2 | Shared Application Directory | Users, groups, permissions, ACLs, automation | [Day2-Shared-App](Day2-Shared-App/README_DAY2.md) |

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
    ├── README_DAY2.md
    ├── setup.sh
    └── Screenshot/
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
