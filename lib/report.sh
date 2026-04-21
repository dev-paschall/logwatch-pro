if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This file is a library. Source it,don't execute it." >&2
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd )
source "${SCRIPT_DIR}/utils.sh"
source "${SCRIPT_DIR}/health_check.sh"
source "${SCRIPT_DIR}/log_parser.sh"

REPORT_DIR=${REPORT_DIR:-./reports}

[[ -d $REPORT_DIR ]] || mkdir -p "$REPORT_DIR"

compile_report(){
    local log_ts=$1
    printf "=============================================\n"
    printf "\tLOGWATCH-PRO REPORT\n"
    printf "\tGenerated: %s" "$log_ts"
    printf "\n=============================================\n"

    printf "\n--- Log summary ---\n"
    summarize_levels
    
    printf "\n--- Recent Errors (last 5) ---\n"
    get_recent_errors 5

    printf "\n--- Health Check ---\n"
    check_all_endpoints

    printf "============================================\n"
}

generate_report(){
    local report_file file_ts log_ts
    local now_ts
    now_ts=$(date +%s)
    file_ts=$(date -d "@$now_ts" +"%Y-%m-%d_%H-%M-%S")
    log_ts=$(date -d "@$now_ts" +"%Y-%m-%d %H:%M:%S")
    report_file="${REPORT_DIR}/report_${file_ts}.txt"

    compile_report "$log_ts" | tee "$report_file"
}