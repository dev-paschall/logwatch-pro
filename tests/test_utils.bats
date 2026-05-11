#!/usr/bin/env bats

setup() {
    source "${BATS_TEST_DIRNAME}/../lib/utils.sh" || {
        echo "ERROR: Could not source utils.sh" >&2
        exit 1
    }
    
    TEST_TEMP_DIR="$(mktemp -d)"
    tmp_test_file="${TEST_TEMP_DIR}/test_file.txt"
    tmp_test_dir="${TEST_TEMP_DIR}/test_subdir"

    touch "$tmp_test_file"
    mkdir -p "$tmp_test_dir"
}

teardown() {
    rm -rf "$TEST_TEMP_DIR"
}

@test "return 0 if file exists" {
    run check_file "$tmp_test_file"
    [ "$status" -eq 0 ]
}

@test "return 1 if file does not exist" {
    run check_file "${TEST_TEMP_DIR}/non_existent_file"
    [ "$status" -eq 1 ]
}

@test "return 0 if directory exists" {
    run check_directory "$tmp_test_dir"
    [ "$status" -eq 0 ]
}

@test "return 1 if directory does not exist" {
    run check_directory "${TEST_TEMP_DIR}/non_existent_dir"
    [ "$status" -eq 1 ]
}

@test "dry_run_log outputs a line containing [DRY-RUN]" {
    run dry_run_log "This is a test"
    [ "$status" -eq 0 ] 
    [[ "$output" == *"[DRY-RUN]"* ]]
}