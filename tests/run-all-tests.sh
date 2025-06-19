#!/bin/bash

echo "Running all tests..."

# Run individual test scripts
for test in tests/test-*.sh; do
    if [ -f "$test" ] && [ "$test" != "tests/run-all-tests.sh" ]; then
        echo "Running $test..."
        bash "$test"
    fi
done

echo "All tests completed!"
