#!/bin/bash

ACTIVE_DIR="active_logs"
ARCHIVE_DIR="archived_logs"
REPORT_DIR="reports"

# ----The Architect ----
initialize_system() {
    echo "Initializing KNH system directories..."
    for dir in "$ACTIVE_DIR" "$ARCHIVE_DIR" "$REPORT_DIR"; do
        if [ -d "$dir" ]; then
            echo "$dir already exists, skipping."
        else
            echo "Creating $dir directory..."
            mkdir -p "$dir"
        fi
    done
    echo "Environment initialization complete."
}

secure_data() {
    echo "----- Securing Sensitive Medical Logs -----"

    # 700: owner read, write, and execute only. A directory needs the
    # execute bit so the owner can enter and list it. Group and others
    # receive no permissions.
    chmod 700 "$ACTIVE_DIR"

    # 600: owner read and write only on each log file. Logs do not need
    # execute permission. The loop no-ops when no .log files exist yet,
    # because an unmatched glob is not a real file.
    local log_file
    for log_file in "$ACTIVE_DIR"/*.log; do
        if [ -f "$log_file" ]; then
            chmod 600 "$log_file"
        fi
    done

    echo "Permissions applied. Current state of $ACTIVE_DIR:"
    ls -l "$ACTIVE_DIR"
    echo
}
