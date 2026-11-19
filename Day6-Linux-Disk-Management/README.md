# Day 06 – Linux Disk Management & Storage Administration

> Hands-on Linux system administration practice focused on virtual storage, EXT4 filesystem management, persistent mounting, and disk-space troubleshooting.

## Overview

This project demonstrates practical Linux storage administration using Ubuntu 26.04 LTS running inside Oracle VirtualBox.

I created a file-backed virtual disk, attached it through a Linux loop device, formatted it with EXT4, and configured persistent mounting through `/etc/fstab`. I also practised monitoring disk usage and investigating deleted-but-open files.

**The objective:** Understand how Linux handles storage devices, filesystems, mounts, and disk-space troubleshooting.

## Environment & Tools

| Component | Details |
|---|---|
| Operating System | Ubuntu 26.04 LTS |
| Virtualization | Oracle VirtualBox |
| Shell | Bash |
| Storage | 1 GB file-backed virtual disk |
| Device | Linux loop device |
| Filesystem | EXT4 |
| Mount Point | `/data` |
| Configuration | `/etc/fstab` |

## Key Skills Practised

- Linux storage and filesystem administration
- File allocation with `fallocate`
- Loop device management with `losetup`
- EXT4 filesystem creation
- Mounting and unmounting filesystems
- Persistent storage configuration
- Disk-space monitoring and troubleshooting
- Deleted-but-open file investigation
- Reboot and mount verification

## Implementation

### 01. Virtual Disk Creation

Created a 1 GB disk image using `fallocate` and attached it through a Linux loop device.

### 02. Filesystem Management

Formatted the loop device with EXT4 and mounted the filesystem at `/data`.

### 03. Persistent Mount Configuration

Configured `/etc/fstab` to mount the disk image automatically.

```bash
/disk.img /data ext4 loop,nofail 0 2
```

### 04. Disk Usage Monitoring

Used Linux storage utilities to inspect filesystem capacity, used space, and directory usage.

### 05. Disk-Space Troubleshooting

Practised investigating deleted-but-open files using `lsof +L1` and examining disk usage before and after releasing the file handle.

### 06. Reboot Verification

Restarted the Ubuntu VM and checked that the `/data` filesystem was mounted automatically.

## Screenshots & Evidence

The following screenshots document the implementation and verification process.

| Screenshot | Evidence |
|---|---|
| [01 – Disk Image Created](screenshots/01-disk-image-created.PNG) | Created the 1 GB disk image |
| [02 – Loop Device Attached](screenshots/02-loop-device-attached.PNG) | Attached the image to a loop device |
| [03 – EXT4 Filesystem](screenshots/03-ext4-filesystem-created.PNG) | Formatted the device with EXT4 |
| [04 – Disk Mounted](screenshots/04-disk-mounted.PNG) | Mounted the filesystem at `/data` |
| [05 – FSTAB Configuration](screenshots/05-fstab-configuration.PNG) | Configured persistent mounting |
| [06 – Disk Usage Before](screenshots/06-disk-usage-before.png) | Inspected filesystem usage |
| [07 – Large File Created](screenshots/07-large-file-created.PNG) | Created a 700 MB test file |
| [08 – Deleted Open File](screenshots/08-deleted-open-file-lsof.PNG) | Investigated deleted-but-open files |
| [09 – Disk Space Recovered](screenshots/09-disk-space-recovered.PNG) | Captured disk-space recovery evidence |
| [10 – Automatic Mount After Reboot](screenshots/10-automatic-mount-after-reboot.PNG) | Verified persistent mounting after reboot |

## Commands & Utilities

| Command | Purpose |
|---|---|
| `fallocate` | Allocate space for a disk image or test file |
| `losetup` | Manage loop devices |
| `mkfs.ext4` | Create an EXT4 filesystem |
| `lsblk` | Inspect block devices |
| `blkid` | Identify filesystem information |
| `mount` / `umount` | Mount and unmount filesystems |
| `findmnt` | Inspect mounted filesystems |
| `df -h` | Monitor filesystem capacity |
| `du -sh` | Check directory disk usage |
| `lsof +L1` | Investigate open files that have been deleted |
| `systemctl` | Manage and restart system services |

## Key Learnings

- A filesystem must be created before it can be used for normal file storage.
- A loop device allows a regular file to be used as a block-device-backed filesystem.
- `/etc/fstab` supports persistent filesystem mounting.
- Deleting a file does not necessarily release its storage immediately if a running process still holds it open.
- Reboot testing is important for validating persistent system configuration.

## Future Improvements

- Practise adding and managing additional virtual disks.
- Explore disk partitioning and filesystem resizing.
- Configure storage monitoring and alerting.
- Automate storage setup with Bash scripts.
- Practise recovery and troubleshooting scenarios.

---

**Project:** Linux Administration Toolkit – Day 06  
**Focus:** Linux Storage & Disk Management  
**Author:** Qaniya Naz

*Learning by building, testing, troubleshooting, and documenting real Linux administration tasks.*