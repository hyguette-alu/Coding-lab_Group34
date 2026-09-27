#!/usr/bin/env python3
import random
import time
import sys
import os
import signal
from datetime import datetime

# Configuration
LOG_DIR = "active_logs"
PID_FILE = "/tmp/hospital_system.pid"

# Device Configuration - Increased Scale
DEVICES = {
    "heart": [f"WARD_A_HR_{i:02d}" for i in range(1, 6)],  # 5 Heart Rate Monitors
    "temp": [f"WARD_B_TEMP_{i:02d}" for i in range(1, 6)],  # 5 Temperature Sensors
    "water": ["FACILITY_WATER_MAIN", "ICU_WATER_RESERVE"]  # 2 Water Meters
}

LOGS = {
    "heart": os.path.join(LOG_DIR, "heart_rate_log.log"),
    "temp": os.path.join(LOG_DIR, "temperature_log.log"),
    "water": os.path.join(LOG_DIR, "water_usage_log.log")
}


def ensure_environment():
    """Ensure log directory and headers exist."""
    if not os.path.exists(LOG_DIR):
        os.makedirs(LOG_DIR)

    # Define headers with units
    headers = {
        "heart": "Timestamp | Device_ID | Heart_Rate (BPM) | Status\n",
        "temp": "Timestamp | Device_ID | Temperature (Celsius) | Status\n",
        "water": "Timestamp | Device_ID | Usage (Liters/min) | Status\n"
    }

    for key, path in LOGS.items():
        if not os.path.exists(path) or os.stat(path).st_size == 0:
            with open(path, "w") as f:
                f.write(headers[key])


def handle_stop(signum, frame):
    """Handle the stop signal."""
    if os.path.exists(PID_FILE):
        os.remove(PID_FILE)
    print("Hospital Management System stopped.")
    sys.exit(0)


def generate_data():
    """Main simulation loop with realistic hospital data ranges."""
    ensure_environment()

    signal.signal(signal.SIGTERM, handle_stop)

    while True:
        timestamp = datetime.now().strftime("%Y-%m-%d %H:%M:%S")

        # 1. Heart Rate (Realistic Range: 45 - 150 BPM)
        for device in DEVICES["heart"]:
            hr = random.randint(45, 150)
            status = "NORMAL"

            if hr < 60 or hr > 100:
                status = "CRITICAL"
            elif 90 <= hr <= 100:
                status = "WARNING"

            with open(LOGS["heart"], "a") as f:
                f.write(
                    f"{timestamp} | {device} | {hr} | {status}\n"
                )

        # 2. Temperature (Realistic Range: 34.5 - 40.5 Celsius)
        for device in DEVICES["temp"]:
            temp = round(random.uniform(34.5, 40.5), 1)
            status = "NORMAL"

            if temp > 38.0:
                status = "CRITICAL"
            elif temp < 35.5:
                status = "CRITICAL"
            elif 37.5 <= temp <= 38.0:
                status = "WARNING"

            with open(LOGS["temp"], "a") as f:
                f.write(
                    f"{timestamp} | {device} | {temp} | {status}\n"
                )

        # 3. Water Usage (Realistic Range: 5 - 45 Liters/min)
        for device in DEVICES["water"]:
            usage = random.randint(5, 45)
            status = "NORMAL"

            if usage > 35:
                status = "HIGH_USAGE"

            with open(LOGS["water"], "a") as f:
                f.write(
                    f"{timestamp} | {device} | {usage} | {status}\n"
                )

        time.sleep(1)


def start():
    if os.path.exists(PID_FILE):
        try:
            with open(PID_FILE, "r") as f:
                old_pid = int(f.read().strip())

            os.kill(old_pid, 0)
            print("System is already running.")
            return

        except (ProcessLookupError, ValueError):
            os.remove(PID_FILE)

    pid = os.fork()

    if pid > 0:
        with open(PID_FILE, "w") as f:
            f.write(str(pid))

        print(f"Hospital Management System started (PID: {pid}).")

    else:
        generate_data()


def stop():
    if os.path.exists(PID_FILE):
        with open(PID_FILE, "r") as f:
            pid = int(f.read().strip())

        try:
            os.kill(pid, signal.SIGTERM)
        except ProcessLookupError:
            pass

        if os.path.exists(PID_FILE):
            os.remove(PID_FILE)

        print("Hospital Management System stopped.")

    else:
        print("No running system found.")


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: ./hospital_system.py [start|stop]")
        sys.exit(1)

    cmd = sys.argv[1].lower()

    if cmd == "start":
        start()
    elif cmd == "stop":
        stop()
    else:
        print("Usage: ./hospital_system.py [start|stop]")
        sys.exit(1)
