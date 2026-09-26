#!/bin/bash
# Member 5 - Clinical Analyst
# Check if the critical alerts file does not exist
if [ ! -f reports/critical_alerts.txt ]; then

    # Create the critical alerts file
    touch reports/critical_alerts.txt
fi

process_heart_vitals() {

    # Find CRITICAL records in the heart rate and temperature logs
    grep -h "CRITICAL" active_logs/heart_rate_log.log active_logs/temperature_log.log |

    # Extract Timestamp, Device_ID, and Value, then save to the report file
    awk -F '|' '{print $1 " | " $2 " | " $3}' >> reports/critical_alerts.txt
}

# =========================================
# Member 6 - Davina Uwase
# water_audit()
# =========================================

water_audit() {

   echo "=================================="
    echo "Running ICU water reserve audit... $(date)"
    echo "=================================="

    awk -F'|' '
    /ICU_WATER_RESERVE/ {
        total += $3
        count++
    }
    END {
        if (count > 0)
            printf "Average ICU Water Usage: %.2f Liters/min\n", total/count
        else
            print "No ICU water reserve data found."
    }
    ' active_logs/water_usage_log.log

}

# Execute Functions
process_heart_vitals
water_audit
