if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This file is a library. Source it,don't execute it." >&2
    exit 1
fi 

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SCRIPT_DIR}/utils.sh"

LOG_PATH=${APP_LOG_PATH:-./logs/app.log}

count_by_level(){
    local log_level="$1"
    awk -v lvl="$log_level" '$3 == lvl {count++} END {print count+0}' "$LOG_PATH"
}

get_errors(){
    awk '$3 == "ERROR" {print $0}' "$LOG_PATH"
}

get_recent_errors(){
    local default_N=5
    local N="${1:-$default_N}"

    if [[ ! "$N" =~ ^[0-9]+$ ]]; then
        error "Error: Argument must be a positive integer." >&2
        exit 1
    fi

    get_errors | tail -n "$N"
}

summarize_levels(){
    levels=("INFO" "WARN" "ERROR")
    for level in "${levels[@]}"; do
        count=$(count_by_level "$level")
        echo "$level: $count"
    done
}
