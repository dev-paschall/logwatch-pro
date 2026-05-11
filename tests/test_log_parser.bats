    #!/usr/bin/env bats

    setup() {
        LOG_PATH="${BATS_TEST_DIRNAME}/../logs/app.log"
        export LOG_PATH

        source "${BATS_TEST_DIRNAME}/../lib/log_parser.sh" || {
        echo "ERROR: Could not source log_parser.sh" >&2
        exit 1
        }
    }

    @test "count_by_level returns a number greater than 0 for INFO" {
        run count_by_level "INFO"
        [ "$output" -gt 0 ]
    }

    @test "count_by_level returns 0 for a level that doesn't exist" {
        run count_by_level "FATAL"
        [ "$output" -eq 0 ]
    }

    @test "get_errors output contains only ERROR lines" {
        run get_errors
        [ "$status" -eq 0 ]

        [ "$(echo "$output" | grep -v "ERROR" | wc -l)" -eq 0 ]
    }

    @test "Output contains no INFO or WARN lines" {
        run get_errors
        [ "$status" -eq 0 ]

        ! [[ "$output" == *"INFOS"* ]]
        ! [[ "$output" == *"WARN"* ]]
    }

    @test "get_recent_errors returns exactly N lines when given N" {
        run get_recent_errors 5
        [ "${#lines[@]}" -eq 5 ]
    }

    @test "summarize_levels output contains INFO, WARN, and ERROR" {
        run summarize_levels 
        [ "$status" -eq 0 ]

        # check for INFO
        echo "$output" | grep -q "INFO"

        # check for ERROR
        echo "$output" | grep -q "ERROR"

        # check for WARN
        echo "$output" | grep -q "WARN"
    }
