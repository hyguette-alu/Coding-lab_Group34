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
