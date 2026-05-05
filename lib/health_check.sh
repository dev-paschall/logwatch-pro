if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    echo "This file is a library. Source it,don't execute it." >&2
    exit 1
fi

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
source "${SCRIPT_DIR}/utils.sh"

ENDPOINTS_FILE=${ENDPOINTS_FILE:-./config/endpoints.txt}

check_endpoint(){
    local url="$1"

    local status_code
    status_code=$(curl -L -s -o /dev/null -w "%{http_code}" --connect-timeout 5 --max-time 10 "$url" || true)

    if [[ "$status_code" == 2[0-9][0-9] ]]; then
        info "Endpoint up: $url ($status_code)"
        echo "[UP] $url ($status_code)"

    elif [[ "$status_code" ==  000 ]]; then
        error "Endpoint timeout: $url ($status_code)"
        echo "[TIMEOUT] $url ($status_code)"

    else
        warn "Endpoint down: $url ($status_code)"
        echo "[DOWN] $url ($status_code)"
    fi
}

check_all_endpoints(){
    local up=0 down=0 total=0
    local result url

    if [[ -f "$ENDPOINTS_FILE" ]]; then
        while IFS= read -r url || [[ -n "$url" ]]; do
            [[ -z "$url" ]] || [[ "$url" =~ ^# ]] && continue
            result=$(check_endpoint "$url")
            echo "$result"

            if [[ "$result" == \[UP\]* ]]; then
                (( up++ )) || true
            else
                (( down++ )) || true
            fi

            (( total++ )) || true
        done < "$ENDPOINTS_FILE"

    else
        error "Endpoints file $ENDPOINTS_FILE not found."
        exit 1
    fi

    printf "\n=== Health Check Summary ===\nTotal : %d\nUp    : %d\nDown  : %d\n" "$total" "$up" "$down"
}