
#!/usr/bin/env bash
set -euo pipefail

GROUP="devs"
DIR="/opt/shared-app"
DEVS=("alice" "bob")
VIEWER="viewer"

# This script must run with root privileges.
if [[ "$EUID" -ne 0 ]]; then
    echo "Please run: sudo bash setup.sh"
    exit 1
fi

# 1. Create the developers group if missing.
if ! getent group "$GROUP" >/dev/null; then
    groupadd "$GROUP"
    echo "Created group: $GROUP"
else
    echo "Group already exists: $GROUP"
fi

# 2. Create developers and ensure group membership.
for user in "${DEVS[@]}"; do
    if ! id "$user" >/dev/null 2>&1; then
        useradd -m -s /bin/bash "$user"
        echo "Created user: $user"
    fi

    # -aG adds the group without replacing other groups.
    usermod -aG "$GROUP" "$user"
done

# 3. Create viewer if missing.
if ! id "$VIEWER" >/dev/null 2>&1; then
    useradd -m -s /bin/bash "$VIEWER"
    echo "Created user: $VIEWER"
fi

# Ensure viewer is not a member of devs.
if id -nG "$VIEWER" | tr ' ' '\n' | grep -Fxq "$GROUP"; then
    gpasswd -d "$VIEWER" "$GROUP"
fi

# 4. Create the shared directory and set ownership/permissions.
mkdir -p "$DIR"
chown root:"$GROUP" "$DIR"
chmod 2775 "$DIR"

# 5. Configure shared-file permissions using ACLs.
if ! command -v setfacl >/dev/null 2>&1; then
    echo "Installing ACL tools..."
    apt-get update
    apt-get install -y acl
fi

# Existing content: developers can write; others can read.
chgrp -R "$GROUP" "$DIR"
find "$DIR" -type d -exec chmod 2775 {} +
find "$DIR" -type f -exec chmod 664 {} +

# Default ACLs allow new shared files to be group-writable.
setfacl -m g:"$GROUP":rwx,o:rx "$DIR"
setfacl -d -m u::rwx,g::rwx,g:"$GROUP":rwx,m::rwx,o::rx "$DIR"

# 6. Display the configuration summary.
echo
echo "===== USER DETAILS ====="
id alice
id bob
id viewer

echo
echo "===== SHARED DIRECTORY ====="
ls -ld "$DIR"

echo
echo "===== DEFAULT ACL ====="
getfacl -p "$DIR"

echo
echo "Setup completed successfully."
