# Linux Administration Toolkit — Day 1: Linux Workspace Setup

A beginner-friendly hands-on Linux project using Ubuntu. This project creates a structured application workspace, generates sample logs, filters errors, searches for files, and saves a directory-tree report.

## Project Goals

- Create an application directory with `bin`, `config`, `logs`, and `data`.
- Create a sample key-value configuration file and a placeholder shell script.
- Generate timestamped `INFO`, `WARN`, and `ERROR` messages.
- Search and count errors with `grep`.
- Locate configuration/log files and recently modified files with `find`.
- Install `tree` and `htop`.
- Save a workspace structure report.

## Environment

- OS: Ubuntu Linux
- Virtualization: VirtualBox (if this matches your setup)
- Tools: Bash, `grep`, `find`, `tree`, `htop`

## Workspace Structure

```text
/opt/myapp/
├── bin/
│   └── start.sh
├── config/
│   └── app.conf
├── data/
└── logs/
    ├── app.log
    └── errors.txt
```

## Setup and Commands

### 1. Create directories

```bash
sudo mkdir -p /opt/myapp/{bin,config,logs,data}
sudo chown -R "$USER":"$USER" /opt/myapp
cd /opt/myapp
```

> This ownership change is used for this isolated practice workspace. Review ownership and permissions carefully on real servers.

### 2. Create configuration

```bash
cat > config/app.conf <<'EOF'
app_name=myapp
port=3000
environment=development
EOF
```

### 3. Create and test a placeholder script

```bash
cat > bin/start.sh <<'EOF'
#!/bin/bash
echo "Starting myapp..."
echo "Application configuration: /opt/myapp/config/app.conf"
EOF

chmod +x bin/start.sh
./bin/start.sh
```

This script prints messages only; it does not start a real application.

### 4. Generate sample logs

```bash
for i in $(seq 1 20); do
    case $((i % 5)) in
        0) level="ERROR" ;;
        1) level="WARN" ;;
        *) level="INFO" ;;
    esac

    echo "$(date '+%F %T') $level request $i" >> logs/app.log
done
```

If `logs/app.log` was empty before running the loop, it generates 20 entries and 4 `ERROR` lines. Running the loop again appends another 20 entries.

### 5. Filter and count errors

```bash
grep -c 'ERROR' logs/app.log
grep 'ERROR' logs/app.log > logs/errors.txt
cat logs/errors.txt
```

### 6. Find files

```bash
find /opt/myapp -type f \( -name "*.conf" -o -name "*.log" \)
find /opt/myapp -type f -mmin -60
```

### 7. Install tools and save reports

```bash
sudo apt update
sudo apt install -y tree htop

tree -L 2 /opt/myapp > ~/workspace-structure.txt
cp /opt/myapp/logs/errors.txt ~/errors.txt
```

## Key Concepts Learned

| Command / concept | What it does |
|---|---|
| `mkdir -p` | Creates directory paths |
| `chown` | Changes ownership |
| `chmod +x` | Makes a script executable |
| `grep` | Searches text |
| `grep -c` | Counts matching lines |
| `find` | Searches for files by conditions |
| `>` | Redirects output and overwrites a file |
| `>>` | Appends output to a file |
| `tree` | Displays directory structure |
| `htop` | Interactive process/resource monitor |

## Deliverables

- `config/app.conf`
- `bin/start.sh`
- `logs/app.log`
- `logs/errors.txt`
- `~/workspace-structure.txt`
- `~/errors.txt`

## Screenshots to Add

Create a `screenshots/` directory in this GitHub repository and add your own terminal screenshots:

1. `01-workspace-structure.png` — `tree -L 2 /opt/myapp`
2. `02-config-and-script.png` — contents of `app.conf` and `start.sh`
3. `03-log-generation.png` — `tail -n 5 /opt/myapp/logs/app.log`
4. `04-error-report.png` — `grep -c 'ERROR' /opt/myapp/logs/app.log` and `cat /opt/myapp/logs/errors.txt`
5. `05-find-results.png` — `find` results
6. `06-tools-installed.png` — `tree --version` and `htop --version`

Only add screenshots you actually captured. Do not upload sensitive information.

## Challenges / Troubleshooting

- **Permission denied:** Check the path and ownership. Use `sudo` only when required.
- **`tree: command not found`:** Install it with `sudo apt update && sudo apt install -y tree`.
- **Error count is higher than expected:** The loop appends to the log. Check whether you ran it more than once.
- **Report overwritten:** `>` replaces the report file; use `>>` only when you intend to append.

## What I Learned

I practiced Linux file-system organization, shell scripting, log generation, text searching, file discovery, package installation, and output redirection. This project is a foundation for Linux administration and cloud operations.

## Next Improvements

- Create a log-summary script that counts INFO, WARN, and ERROR entries.
- Practice Linux ownership and permissions in a follow-up project.
- Add monitoring and service-management tasks later.

---

**Project type:** Beginner Linux administration  

