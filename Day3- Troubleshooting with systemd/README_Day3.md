# Day 3 — Linux Service Troubleshooting with systemd

Part of the **Linux Administration Toolkit** hands-on learning series.

## Project overview

This lab demonstrates how to create and manage a simple background worker on Ubuntu using `systemd`. The worker writes a timestamped heartbeat to `/var/log/worker.log` every five seconds. The lab also covers service status checks, process identification, log monitoring, deliberate failure simulation, recovery, restart behaviour, and normal shutdown.

> **Learning project:** Run these steps in a Linux environment that uses systemd. Do not describe a test as successful in your portfolio until you have captured the corresponding terminal evidence.

## Objectives

- Create a Bash worker script.
- Create a `systemd` unit file.
- Start, stop, enable, and inspect a service.
- Identify a process using `pgrep`, `ps`, and `MainPID`.
- Monitor application logs and the systemd journal.
- Simulate an invalid `ExecStart` path and investigate `203/EXEC`.
- Restore the service and test `Restart=on-failure`.
- Explain the difference between graceful termination and forced termination.

## Technology and tools

- Ubuntu Linux
- Bash
- systemd / `systemctl`
- `journalctl`
- Linux process tools: `pgrep`, `ps`
- `nano`, `chmod`, `tail`

## Project structure

```text
day-03-service-troubleshooting/
├── README.md
├── worker.sh
├── demo-worker.service
├── project-report.md
└── screenshots/
    ├── 01-worker-script.png
    ├── 02-service-unit.png
    ├── 03-service-running.png
    ├── 04-process-pid.png
    ├── 05-heartbeat-logs.png
    ├── 06-journal-monitoring.png
    ├── 07-service-failure-203.png
    ├── 08-service-recovery.png
    ├── 09-automatic-restart.png
    └── 10-normal-stop.png
```

Only include screenshots you have actually captured. Adjust filenames if your evidence differs.

## 1. Create the worker script

Create `/opt/demo/worker.sh`:

```bash
#!/usr/bin/env bash

while true
do
    echo "$(date '+%F %T') worker heartbeat" >> /var/log/worker.log
    sleep 5
done
```

Set execute permission:

```bash
sudo chmod +x /opt/demo/worker.sh
```

The script loops continuously, appends a timestamped heartbeat to the log, and waits five seconds before writing the next line.

## 2. Create the systemd unit

Create `/etc/systemd/system/demo-worker.service`:

```ini
[Unit]
Description=Demo Worker Service
After=network.target

[Service]
Type=simple
ExecStart=/opt/demo/worker.sh
Restart=on-failure
RestartSec=3

[Install]
WantedBy=multi-user.target
```

Reload systemd and start the service:

```bash
sudo systemctl daemon-reload
sudo systemctl enable --now demo-worker
sudo systemctl status demo-worker
```

`enable` configures the service to start at boot; `--now` also starts it immediately.

## 3. Verify the process

```bash
pgrep -af worker.sh
ps aux | grep '[w]orker.sh'
systemctl show demo-worker --property=MainPID
```

`MainPID` should show the main process ID when the service is running.

## 4. Monitor logs

Application log:

```bash
sudo tail -n 10 /var/log/worker.log
sudo tail -f /var/log/worker.log
```

Service journal:

```bash
sudo journalctl -u demo-worker -n 30 --no-pager
sudo journalctl -u demo-worker -f
```

Press `Ctrl+C` to exit a live log-following command. This stops the monitoring command, not the service itself.

## 5. Simulate and diagnose a failure

For the lab exercise, temporarily change the `ExecStart` path to a nonexistent file, for example:

```ini
ExecStart=/opt/demo/workerr.sh
```

Then run:

```bash
sudo systemctl daemon-reload
sudo systemctl restart demo-worker
sudo systemctl status demo-worker
sudo journalctl -u demo-worker -n 30 --no-pager
```

A missing or non-executable program can produce `status=203/EXEC`. Check the exact journal message: this error indicates systemd could not execute the configured program. Common causes include an incorrect path, missing execute permission, or an invalid interpreter.

## 6. Restore the service

Restore the correct path:

```ini
ExecStart=/opt/demo/worker.sh
```

Then:

```bash
sudo systemctl daemon-reload
sudo systemctl reset-failed demo-worker
sudo systemctl restart demo-worker
sudo systemctl enable demo-worker
systemctl is-active demo-worker
systemctl is-enabled demo-worker
```

Expected checks after a successful recovery are `active` and `enabled`.

## 7. Test restart behaviour and normal stop

Find the main PID:

```bash
systemctl show demo-worker --property=MainPID
```

For the controlled lab test, send `SIGKILL` to the actual worker PID (replace `PID` with the number returned above):

```bash
sudo kill -9 PID
sleep 5
systemctl show demo-worker --property=MainPID
sudo systemctl status demo-worker
```

With `Restart=on-failure`, systemd should restart the worker after an unexpected `SIGKILL`. Verify that the new `MainPID` is different and the service returns to `active (running)`.

Stop the service normally:

```bash
sudo systemctl stop demo-worker
systemctl is-active demo-worker
```

Expected state: `inactive`. A deliberate `systemctl stop` does not trigger `Restart=on-failure`. The service remains enabled for the next boot unless disabled.

## Troubleshooting notes

| Symptom | What to check |
|---|---|
| `Unit ... not found` | Confirm the unit filename and path: `/etc/systemd/system/demo-worker.service` |
| `203/EXEC` | Check `ExecStart`, file existence, execute permission, and script interpreter |
| Service is masked | Inspect the unit and masking symlink; only unmask if you intend to manage the service |
| `Unknown key 'wantedBy'` | Use the exact case-sensitive key `WantedBy` under `[Install]` |
| No heartbeat output | Check service status, script contents, permissions, and `/var/log/worker.log` |
| No room to type | Press `Ctrl+C` to exit `tail -f` or `journalctl -f`, then enter the next command |

## Key learning outcomes

- A `systemd` unit describes how a service is started and managed.
- `daemon-reload` makes systemd reread changed unit files.
- `systemctl status` and `journalctl` help investigate service failures.
- `pgrep`, `ps`, and `MainPID` help identify running processes.
- `Restart=on-failure` supports recovery from unexpected failures.
- `systemctl stop` is the appropriate way to request a normal service stop.

## Completion evidence

Before marking the lab complete, capture evidence for each item:

- [ ] Worker script and executable permission
- [ ] Correct unit file
- [ ] Service active and enabled
- [ ] PID shown by process commands
- [ ] Heartbeat lines appearing about every five seconds
- [ ] Live journal monitoring
- [ ] Deliberate failure and exact error output
- [ ] Successful recovery
- [ ] New PID after the `SIGKILL` restart test
- [ ] `inactive` state after normal stop

## Root cause and fix — report summary

**Root cause:** During the failure simulation, an incorrect `ExecStart` path prevented systemd from executing the worker and could result in `203/EXEC`.

**Fix:** Restore the correct `/opt/demo/worker.sh` path, verify executable permission, run `systemctl daemon-reload`, and restart the service. Record the successful result in screenshots before claiming the recovery test is complete.

## Author

Qaniya Naz  
Linux Administration Toolkit — Day 3 hands-on practice
