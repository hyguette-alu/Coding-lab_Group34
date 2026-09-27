#!/bin/bash
# Member 1 - Clinical Analyst  
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

# Run the function
process_heart_vitals
