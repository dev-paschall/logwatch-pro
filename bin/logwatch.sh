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
  --report|-r         Generate full report (log analysis + health checks)
  --parse-only|-p     Run log analysis only (no health checks)
  --health-only|-h    Run health checks only (no log analysis)
  --dry-run|-d        Show what would run, without executing
  --help              Show this help message
EOF
}


main(){
    local action=""

    while [[ $# -gt 0 ]]; do
        case "$1" in
            --report|-r)       action="report";;
            --parse-only|-p)   action="parse-only";;
            --health-only|-h)  action="health-only";;
            --dry-run|-d)      DRY_RUN=true;;
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
        parse-only)     summarize_levels; get_recent_errors;;
        health-only)    check_all_endpoints;;
        "")             show_help; exit 0;;
        *)              error "Unknown action: $action"; exit 1;;
    esac
}

main "$@"