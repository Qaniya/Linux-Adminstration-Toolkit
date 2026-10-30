# Linux Administration Toolkit — Day 2: Shared Application Directory

A beginner-friendly Linux administration project that automates a shared application directory using Bash, Linux users and groups, permissions, setgid, and POSIX ACLs.

## Project objective

Configure `/opt/shared-app` so that:
- `alice` and `bob` are members of the `devs` group and can create and modify shared application files.
- `viewer` is not a member of `devs`; the viewer can read shared files but cannot modify them.
- The directory is owned by `root:devs` and has mode `2775`.
- `/opt/shared-app/bin` can be added to the user's `PATH`.
- A `sharedapp` Bash alias changes the current directory to `/opt/shared-app`.
- `setup.sh` can be run repeatedly without trying to recreate existing users or groups.

> **Project status:** The setup script has been run successfully and the screenshot evidence confirms the users/group membership, `root:devs` directory ownership, mode `2775`, and default ACL. Complete the Alice/Bob/Viewer file-access tests and PATH/alias checks before marking every acceptance test as passed.

## Repository structure

```text
Linux-Administration-Toolkit/
├── Day1-Linux-Workspace/
└── Day2-Shared-App/
    ├── setup.sh
    ├── README.md
    └── screenshots/
        ├── 01-setup-success.png
        ├── 02-user-and-directory-verification.png
        ├── 03-alice-creates-file.png
        ├── 04-bob-edits-file.png
        ├── 05-viewer-read-write-test.png
        └── 06-path-and-alias.png
```

Use your actual folder names if they differ. Add screenshots only after capturing your own terminal output. Do not include passwords, private keys, or other secrets.

## Technologies and Linux concepts

- Ubuntu Linux
- Bash scripting
- `groupadd`, `useradd`, `usermod`, `gpasswd`
- `chown`, `chgrp`, `chmod`
- setgid directory bit (`2`)
- POSIX Access Control Lists (ACLs): `setfacl`, `getfacl`
- `PATH`, `.bashrc`, and Bash aliases
- Idempotent scripting and `set -euo pipefail`

## How it works

### Users and group

The script creates the `devs` group if it does not exist. It creates `alice` and `bob` if needed and uses `usermod -aG devs` to append the developers group without replacing their existing supplementary groups. It creates `viewer` if missing and removes `viewer` from `devs` if that membership exists.

### Shared directory

The script creates `/opt/shared-app`, sets its owner and group to `root:devs`, and applies mode `2775`.

- `2`: setgid; new items inherit the directory's group.
- `7`: owner can read, write, and enter the directory.
- `7`: group can read, write, and enter the directory.
- `5`: others can read and enter the directory, but cannot create or remove directory entries.

### ACLs

The script installs the `acl` package if `setfacl` is unavailable. It applies group ownership and permissions to existing contents, then configures access and default ACL entries on the shared directory.

The default ACL helps newly created files and directories inherit the intended access policy. Actual file permissions can also be affected by the creating program's requested mode and the ACL mask, so verify the effective permissions on a test file with `getfacl`.

## Setup

Run these commands from the `Day2-Shared-App` folder:

```bash
chmod +x setup.sh
sudo ./setup.sh
```

Run it a second time to check repeatability:

```bash
sudo ./setup.sh
```

The script must be run with root privileges. On a fresh Ubuntu installation, it may need an internet connection to install the `acl` package.

## Verification and practical tests

### 1. Verify users, group membership, and directory

```bash
id alice
id bob
id viewer
ls -ld /opt/shared-app
getfacl /opt/shared-app
```

Expected:
- `alice` and `bob` include `devs` in their supplementary groups.
- `viewer` does not include `devs`.
- `/opt/shared-app` is owned by `root devs`.
- The directory mode is `drwxrwsr-x` (octal `2775`). A trailing `+` in `ls -l` indicates ACL entries.

### 2. Alice creates a file

```bash
sudo -u alice bash -c 'echo "Application created by Alice" > /opt/shared-app/app.txt'
```

### 3. Bob edits Alice's file

```bash
sudo -u bob bash -c 'echo "Updated by Bob" >> /opt/shared-app/app.txt'
cat /opt/shared-app/app.txt
```

Expected content:

```text
Application created by Alice
Updated by Bob
```

### 4. Viewer is denied write access

```bash
if sudo -u viewer sh -c 'echo "Unauthorized modification" >> /opt/shared-app/app.txt'; then
    echo "FAIL: viewer was able to modify the file"
else
    echo "PASS: viewer cannot modify the file"
fi
```

A `Permission denied` message is expected for the write attempt.

### 5. Viewer can read the file

```bash
sudo -u viewer cat /opt/shared-app/app.txt
```

### 6. Configure PATH and alias for the current login user

```bash
sudo mkdir -p /opt/shared-app/bin
sudo chown root:devs /opt/shared-app/bin
sudo chmod 2775 /opt/shared-app/bin
```

Append these lines to the current user's `~/.bashrc`:

```bash
export PATH="/opt/shared-app/bin:$PATH"
alias sharedapp='cd /opt/shared-app'
```

Reload and verify:

```bash
source ~/.bashrc
echo "$PATH"
alias sharedapp
sharedapp
pwd
```

Expected `pwd` output: `/opt/shared-app`.

This `.bashrc` configuration applies only to the current login user. Configure other users' startup files separately if they also need the PATH entry and alias.

## Acceptance checklist

- [ ] `setup.sh` runs successfully.
- [ ] Running `setup.sh` a second time completes without errors.
- [ ] `alice` belongs to `devs`.
- [ ] `bob` belongs to `devs`.
- [ ] `viewer` is not a member of `devs`.
- [ ] `/opt/shared-app` is owned by `root:devs` with mode `2775`.
- [ ] Alice creates `app.txt`.
- [ ] Bob successfully appends to `app.txt`.
- [ ] Viewer can read `app.txt`.
- [ ] Viewer cannot modify `app.txt`.
- [ ] `/opt/shared-app/bin` is added to the current user's `PATH`.
- [ ] The `sharedapp` alias works.

## Troubleshooting

**`set: Illegal option -o pipefail` or `: not found`**

The script may have Windows CRLF line endings. Convert it to Unix LF endings:

```bash
sed -i 's/\r$//' setup.sh
```

Then run it explicitly with Bash:

```bash
sudo bash setup.sh
```

**`id: 'alice': no such user`**

The script did not complete successfully. Read the first error printed by the script, correct it, and rerun:

```bash
sudo bash setup.sh
```

**Bob cannot edit Alice's file**

Check group membership and the file's effective ACL:

```bash
id bob
ls -l /opt/shared-app/app.txt
getfacl /opt/shared-app/app.txt
```

A group membership change may require a new login session. For this lab, `sudo -u bob` starts a command under Bob's account, but verify the actual file ACL and mode as well.

## What I learned

- How Linux users and supplementary groups control access.
- Why `usermod -aG` is safer than `usermod -G` when appending a group.
- How ownership and numeric permissions work.
- How setgid helps maintain shared group ownership.
- How default ACLs provide inherited access rules.
- How to write a repeatable Bash setup script.
- How to configure a user's `PATH` and Bash aliases.
- How to verify access by testing with different user accounts.

## Possible improvements

- Add explicit validation that Alice and Bob are not locked or otherwise unable to log in, if interactive login is required.
- Add automated assertions that fail if any acceptance test does not pass.
- Add logging and clearer error handling around package installation.
- Add a cleanup script for a disposable lab VM (use with care; it deletes lab users and files).
- Test ACL behavior on newly created files with different applications and umasks.

## Author

**Qaniya Naz**  
BS Cloud Application Development and Operations  
GitHub: https://github.com/Qaniya

This is a learning project for Linux administration and entry-level Cloud Support / Cloud Administrator preparation.
