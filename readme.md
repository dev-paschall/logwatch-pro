# logwatch-pro

A production-style **log analyser and endpoint health monitor** written in Bash. Parses structured log files, checks HTTP endpoint availability, and generates timestamped reports, all from the command line.

---

## Features

- Parses log files and summarises entries by severity level (INFO, WARN, ERROR)
- Displays the most recent errors on demand
- Checks HTTP endpoint health with timeout handling
- Generates timestamped reports combining log analysis and health check results
- `--dry-run` mode for safe testing
- Structured logging throughout (`[INFO]`, `[WARN]`, `[ERROR]`)
- **17 BATS unit tests** with full coverage across all library modules
- Containerised with Docker

---

## Installation

```bash
git clone https://github.com/dev-paschall/logwatch-pro.git
cd logwatch-pro
cp .env.example .env
```

Generate sample log data:

```bash
python3 scripts/generate_logs.py
```

---

## Usage

### Run locally

```bash
# Full report (log analysis + health checks)
./bin/logwatch.sh --report

# Log analysis only
./bin/logwatch.sh --parse-only

# Health checks only
./bin/logwatch.sh --health-only

# Dry run (shows what would execute, no side effects)
./bin/logwatch.sh --dry-run --report

# Help
./bin/logwatch.sh --help
```

### Run with Docker

```bash
docker build -t logwatch-pro .

docker run --rm \
  -v "$(pwd)/logs:/app/logs" \
  -v "$(pwd)/reports:/app/reports" \
  --env-file .env \
  logwatch-pro
```

### Run with Docker Compose

```bash
docker compose up
```

---

## Configuration

Copy `.env.example` to `.env` and adjust as needed:

```bash
APP_LOG_PATH=./logs/app.log
REPORT_DIR=./reports
ENDPOINTS_FILE=./config/endpoints.txt
ALERT_THRESHOLD=10
LOG_LEVEL=INFO
```

Add URLs to monitor in `config/endpoints.txt`, one per line:

```
https://google.com
https://github.com
https://yourservice.com/health
```

Lines starting with `#` are ignored.

---

## Testing

Requires [BATS](https://github.com/bats-core/bats-core).

```bash
# Run all tests
bats tests/

# Run a specific file
bats tests/test_log_parser.bats
```

Expected output:

```
17 tests, 0 failures
```

---

## Environment Variables

| Variable | Default | Description |
|---|---|---|
| `APP_LOG_PATH` | `./logs/app.log` | Path to the log file to analyse |
| `REPORT_DIR` | `./reports` | Directory where reports are saved |
| `ENDPOINTS_FILE` | `./config/endpoints.txt` | Path to the endpoints list |
| `ALERT_THRESHOLD` | `10` | Error count threshold for alerting |
| `LOG_LEVEL` | `INFO` | Logging verbosity |

---

## Author

**Paschal Arowolo**  
GitHub: dev-paschall (https://github.com/dev-paschall)
