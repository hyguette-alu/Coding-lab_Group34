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

# ---- The Security Lead ----
# Patient logs in active_logs must stay private to the account that owns them.
secure_data() {
    # Print this before chmod so the operator can see lockdown has started.
    echo "----- Securing Sensitive Medical Logs -----"

    # 700 applies to the directory, not to the files inside it.
    #   owner  rwx  list the folder, add or remove logs, and enter it
    #   group  ---  no access
    #   others ---  no access
    # A directory needs the execute bit. Without it, even the owner cannot
    # open active_logs. Group and others are left with nothing, so another
    # account on this machine cannot list or enter the medical logs.
    chmod 700 "$ACTIVE_DIR"

    # Locking the directory is not enough. Each log keeps its own mode,
    # so a file created as 644 would still be readable by every account.
    # 600 means owner read/write only. A log is data, not a program, so
    # it does not get execute permission. Group and others get none.
    # Keep the directory name quoted and let *.log expand. If no logs
    # exist yet, the pattern is not a real path and the test below skips it.
    local log_file
    for log_file in "$ACTIVE_DIR"/*.log; do
        # Skip the unmatched glob. chmod must run only on a real log file.
        if [ -f "$log_file" ]; then
            chmod 600 "$log_file"
        fi
    done

    # Say the lockdown finished, then show the bits. ls -l prints modes
    # such as drwx------ for the folder and -rw------- for each log, so
    # the operator can confirm group and others have no access.
    echo "Permissions applied. Current state of $ACTIVE_DIR:"
    ls -l "$ACTIVE_DIR"
    # Separate this report from whatever the script prints next.
    echo
}
# ============================================================
# Member 3 (The Orchestrator) - Master Orchestration Logic
# ============================================================

main() {
    initialize_system
    secure_data

    local CURRENT_DATE
    CURRENT_DATE="$(date +"%Y-%m-%d %H:%M:%S")"

    echo "=============================================="
    echo "System Environment Secured - ${CURRENT_DATE}"
    echo "=============================================="
}

main "$@"

# ============================================================
# End of Member 3 (The Orchestrator) Block
# ============================================================
