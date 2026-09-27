#!/bin/bash
# ============================================================
# Member 4 (The Archivist) - Log Rotation
# ============================================================

ACTIVE_DIR="active_logs"
ARCHIVE_DIR="archived_logs"

archive_logs() {
    echo "Starting log rotation..."
    local timestamp
    timestamp=$(date +"%Y%m%d_%H%M")

    local log_file base_name
    for log_file in "$ACTIVE_DIR"/*.log; do
        if [ -f "$log_file" ]; then
            base_name=$(basename "$log_file" .log)
            base_name="${base_name%_log}"
            mv "$log_file" "$ARCHIVE_DIR/${base_name}_${timestamp}.log"
            echo "Archived: $(basename "$log_file") -> ${base_name}_${timestamp}.log"
        fi
    done
}

archive_logs
