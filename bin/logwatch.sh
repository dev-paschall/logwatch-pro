#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
PROJECT_DIR=$(cd "$(dirname "${SCRIPT_DIR}")" && pwd)
LIB_DIR="${PROJECT_DIR}/lib"

[[ -f "${PROJECT_DIR}/.env" ]] && source "${PROJECT_DIR}/.env"
source "${LIB_DIR}/utils.sh"
source "${LIB_DIR}/log_parser.sh"
source "${LIB_DIR}/health_check.sh" 
source "${LIB_DIR}/report.sh"

show_help(){
    cat <<EOF
Usage: logwatch.sh [OPTIONS]

Options:
  --report        Generate full report (log analysis + health checks)
  --parse-only    Run log analysis only (no health checks)
  --health-only   Run health checks only (no log analysis)
  --dry-run       Show what would run, without executing
  --help          Show this help message
EOF
}

main(){
    local action=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --report)       action="report";;
            --parse-only)   action="parse-only";;
            --health-only)  action="health-only";;
            --dry-run)      DRY_RUN=true;;
            --help)         show_help; exit 0;;
            *)              error "Unknown option: $1"; exit 1;;
        esac
        shift
    done

    if [[ "$DRY_RUN" == true ]]; then
        dry_run_log "Would run: ${action:-report}"
        exit 0
    fi

    case "$action" in
        report)         generate_report;;
        parse-only)     summarize_levels; get_recent_errors 5;;
        health-only)    check_all_endpoints;;
        "")             show_help; exit 0;;
        *)              error "Unknown action: $action"; exit 1;;
    esac
}

main "$@"