#!/bin/bash
# Member 5 - Clinical Analyst

mkdir -p reports

process_vitals() {

    # Rewrite the report on every run. Appending repeated every old alert
    : > reports/critical_alerts.txt

    # Find CRITICAL records in the heart rate and temperature logs.
    grep -h "CRITICAL" active_logs/heart_rate_log.log active_logs/temperature_log.log |

    awk -F '|' '{
        for (i = 1; i <= 3; i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", $i)
        }
        print $1 " | " $2 " | " $3
    }' > reports/critical_alerts.txt
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
process_vitals
water_audit
