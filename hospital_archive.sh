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
    local archived_any=false

    for log_file in "$ACTIVE_DIR"/*.log; do
        if [ -f "$log_file" ]; then
            base_name=$(basename "$log_file" .log)
            base_name="${base_name%_log}"
            mv "$log_file" "$ARCHIVE_DIR/${base_name}_${timestamp}.log"
            echo "Archived: $(basename "$log_file") -> ${base_name}_${timestamp}.log"
            archived_any=true
        fi
    done

    if [ "$archived_any" = false ]; then
        echo "No active logs found to archive."
    fi

    echo "Recreating empty log files in $ACTIVE_DIR..."
    touch "$ACTIVE_DIR/heart_rate_log.log"
    touch "$ACTIVE_DIR/temperature_log.log"
    touch "$ACTIVE_DIR/water_usage_log.log"
    echo "Log rotation complete."
}

archive_logs
