#!/bin/bash
# create_users.sh - Automates Linux user account creation
# Fulfills SysOps Challenge Requirements

INPUT_FILE="${1:-user-man}"   # Default input file = user-man
PASSWORD_DIR="/var/secure"
PASSWORD_FILE="$PASSWORD_DIR/user_passwords.txt"
LOG_FILE="/var/log/user_management.log"

# Script must run as root
if [ "$EUID" -ne 0 ]; then
    echo "Run this script with sudo: sudo ./create_users.sh"
    exit 1
fi

# Prepare secure directories
mkdir -p "$PASSWORD_DIR"
touch "$PASSWORD_FILE" "$LOG_FILE"
chmod 600 "$PASSWORD_FILE" "$LOG_FILE"
chown root:root "$PASSWORD_FILE" "$LOG_FILE"

log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" >> "$LOG_FILE"
}

# Verify input file
if [ ! -f "$INPUT_FILE" ]; then
    echo "Input file not found: $INPUT_FILE"
    exit 1
fi

while IFS= read -r line || [ -n "$line" ]; do

    # Skip blank lines and comments
    [[ -z "$line" || "$line" =~ ^# ]] && continue

    # Remove whitespace
    clean=$(echo "$line" | tr -d '[:space:]')

    # Split user and groups
    username="${clean%%;*}"
    groups="${clean#*;}"

    echo "[INFO] Processing user: $username"
    log "Processing user: $username"

    # Create user if missing
    if id "$username" &>/dev/null; then
        echo "[INFO] User exists: $username"
        log "User exists: $username"
    else
        useradd -m -s /bin/bash "$username"
        echo "[INFO] Created user: $username"
        log "Created user: $username"
    fi

    # Ensure home directory exists & permissions
    mkdir -p /home/"$username"
    chown "$username:$username" /home/"$username"
    chmod 700 /home/"$username"
    log "Home directory set for $username"

    # Process groups
    IFS=',' read -ra group_list <<< "$groups"
    for g in "${group_list[@]}"; do
        if [ -z "$g" ]; then continue; fi

        if ! getent group "$g" &>/dev/null; then
            groupadd "$g"
            log "Created group: $g"
        fi

        usermod -aG "$g" "$username"
        log "Added $username to group $g"
    done

    # Generate password
    pass=$(tr -dc A-Za-z0-9 </dev/urandom | head -c 12)
    echo "$username:$pass" | chpasswd
    echo "$username:$pass" >> "$PASSWORD_FILE"
    log "Password set for $username"

done < "$INPUT_FILE"

echo "User creation complete."
echo "Logs: $LOG_FILE"
echo "Passwords: $PASSWORD_FILE"
