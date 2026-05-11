#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/../lib/health_check.sh" || {
        echo "ERROR: Could not source health_check.sh" >&2
        exit 1
    }
    
    TEST_TEMP_DIR="$(mktemp -d)"
    tmp_test_file="${TEST_TEMP_DIR}/test_endpoint_file.txt"

    
    cat > "$tmp_test_file" <<EOF
https://fake-one.com
https://fake-two.com
https://fake-three.com
EOF

    export ENDPOINTS_FILE="$tmp_test_file"
}

teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "check_endpoint returns [UP] for a 200 status code" {
    curl(){
        echo "200"
    }
    
    export -f curl

    run check_endpoint "https://fake-url.com"
    [ "$status" -eq 0 ]
    
    [[ "$output" == *"[UP]"* ]]
}

@test "check_endpoint returns [DOWN] for a 404 status code" {
    curl(){
        echo "404"
    }
    
    export -f curl

    run check_endpoint "https://fake-url.com"
    [ "$status" -eq 0 ]
    
    [[ "$output" == *"[DOWN]"* ]]
}

@test "check_endpoint returns [TIMEOUT] for a 000 status code" {
    curl(){
        echo "000"
    }
    
    export -f curl

    run check_endpoint "https://fake-url.com"
    [ "$status" -eq 0 ]
    
    [[ "$output" == *"[TIMEOUT]"* ]]
}

@test "Output contains '=== Health Check Summary ==='" {
    check_endpoint() {
        echo "[UP] $1 (200)"
    }
    export -f check_endpoint

    run check_all_endpoints
    [[ "$output" == *"=== Health Check Summary ==="* ]]
}

@test "Total count in summary matches number of URLs in the file" {
    run check_all_endpoints
    [[ "$output" == *"Total : 3"* ]]
}

@test "check_all_endpoints exits non-zero if endpoints file missing" {
    export ENDPOINTS_FILE="/tmp/does_not_exist.txt"
    run check_all_endpoints
    [ "$status" -ne 0 ]
}