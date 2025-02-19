#!/bin/bash
# coverage/run_coverage.sh

cd "$(dirname "$0")/.." || exit

# Run flutter test with coverage
flutter test --coverage

# Filter only viewmodel files
lcov --extract coverage/lcov.info "lib/**/*_viewmodel.dart" -o coverage/filtered_lcov.info

# Generate HTML report
genhtml coverage/filtered_lcov.info -o coverage/html
