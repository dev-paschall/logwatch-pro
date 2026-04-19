if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This file is a library. Source it,don't execute it." >&2
    exit 1
fi

DRY_RUN=false
LOG_LEVEL=INFO

log(){
    local level=$1
    local msg=$2
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] [$level] $msg" 
}

info(){
    log "INFO" "$1"
}

warn(){
    log "WARN" "$1"
}

error(){
    log "ERROR" "$1" >&2
}

dry_run_log(){
    log "DRY-RUN" "$1"
}

check_file(){
    local file_path=$1
    if [[ -f "$file_path" ]]; then
        return 0
    fi
    error "File '$file_path' does not exist."
    return 1
}

check_directory(){
    local file_dir=$1
    if [[ -d "$file_dir" ]]; then
        return 0
    fi
    error "directory '$file_dir' does not exist."
    return 1
}

cleanup(){
    local exit_code=$?

    if [[ $exit_code -ne 0 ]]; then
        error "script failed with exit code $exit_code"
    fi
    exit $exit_code
}

trap cleanup EXIT
trap 'error "Error in line $LINENO."' ERR
trap 'error "Terminated."; exit 1' SIGTERM
trap 'error "Interrupted."; exit 1' SIGINT
