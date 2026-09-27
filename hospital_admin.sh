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
