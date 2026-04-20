import random
import os
from datetime import datetime, timedelta

# set log path 
SCRIPT_DIR = os.path.dirname(os.path.abspath(__file__))
PROJECT_ROOT = os.path.dirname(SCRIPT_DIR)
DIR_PATH = os.path.join(PROJECT_ROOT, "logs")
LOG_PATH = os.path.join(DIR_PATH, "app.log")

os.makedirs(DIR_PATH, exist_ok=True)

# number of lines to generate
NO_OF_LINES = 300

start = datetime(2025, 4, 5, 0, 0, 0)

messages = {
    "INFO": [
        "User authentication successful for UID: 8842", 
        "Background worker 'image-processor' started task #402", 
        "Database connection pool refreshed; 12 active connections", 
        "Successfully rotated SSL certificates (expires in 90 days)", 
        "Health check endpoint /health returned 200 OK",
    ],
    "WARN": [
        "Memory usage exceeded 80% threshold on node 'aws-us-east-1a'",
        "API request to 'payment-gateway' took longer than 2.5 seconds",
        "Disk space low: 15% remaining on /var/lib/docker",
        "Deprecated API version v1.2 called by client 'legacy-mobile-app'",
        "Retry attempt 2/5 for sending email to user@example.com",
    ],
    "ERROR": [
        "ConnectionTimeout: Failed to connect to Redis at 10.0.1.4:6379",
        "Database IntegrityError: Duplicate entry '10294' for key 'PRIMARY'",
        "Permission Denied: Service 'web-app' cannot write to /etc/config",
        "Failed to parse JSON payload from incoming webhook (Bad Request)",
        "InternalServer Error: Unhandled exception in 'order-processing' module",
        ],
}

levels = ["INFO", "WARN", "ERROR"]
weight = [70, 20, 10]

with open(LOG_PATH, "w") as f:
    current_time = start

    for i in range(NO_OF_LINES):
        level = random.choices(levels, weights=weight, k=1)[0]
        message = random.choice(messages[level])

        current_time += timedelta(seconds=random.randint(1, 30))

        timestamp = current_time.strftime("%Y-%m-%d %H:%M:%S")
        log_entry = f"{timestamp} {level} {message}\n"
        f.write(log_entry)
