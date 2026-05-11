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
        lambda: f"User authentication successful for UID: {random.randint(1000, 9999)}",
        lambda: f"Background worker 'image-processor' started task #{random.randint(100, 999)}",
        lambda: f"Database connection pool refreshed; {random.randint(5, 20)} active connections",
        lambda: f"Successfully rotated SSL certificates (expires in {random.randint(30, 120)} days)",
        lambda: "Health check endpoint /health returned 200 OK",
    ],
    "WARN": [
        lambda: f"Memory usage exceeded {random.randint(80, 95)}% threshold on node 'aws-us-east-{random.choice(['1a','1b','2a'])}'",
        lambda: f"API request to 'payment-gateway' took longer than {round(random.uniform(2.5, 10.0), 1)} seconds",
        lambda: f"Disk space low: {random.randint(5, 20)}% remaining on /var/lib/docker",
        lambda: f"Deprecated API version v{random.choice(['1.1', '1.2', '1.3'])} called by client 'legacy-mobile-app'",
        lambda: f"Retry attempt {random.randint(1, 4)}/5 for sending email to user{random.randint(1,99)}@example.com",
    ],
    "ERROR": [
        lambda: f"ConnectionTimeout: Failed to connect to Redis at 10.0.{random.randint(0,5)}.{random.randint(1,10)}:6379",
        lambda: f"Database IntegrityError: Duplicate entry '{random.randint(10000, 99999)}' for key 'PRIMARY'",
        lambda: f"Permission Denied: Service '{random.choice(['web-app', 'api-server', 'worker'])}' cannot write to /etc/config",
        lambda: "Failed to parse JSON payload from incoming webhook (Bad Request)",
        lambda: f"InternalServer Error: Unhandled exception in '{random.choice(['order-processing', 'auth', 'payment'])}' module",
    ],
}

levels = ["INFO", "WARN", "ERROR"]
weights = [70, 20, 10]

last_entry = None

with open(LOG_PATH, "w") as f:
    current_time = start

    for _ in range(NO_OF_LINES):
        current_time += timedelta(seconds=random.randint(1, 30))

        # Avoid two identical consecutive lines
        for _ in range(10):
            level = random.choices(levels, weights=weights, k=1)[0]
            message = random.choice(messages[level])()
            entry = f"{level} {message}"
            if entry != last_entry:
                break

        last_entry = entry
        timestamp = current_time.strftime("%Y-%m-%d %H:%M:%S")
        f.write(f"{timestamp} {level} {message}\n")