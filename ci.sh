#!/usr/bin/env bash
set -eu

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$script_dir/build"
cd "$script_dir/build"
cmake ..
cmake --build . --config Release
ctest -C Release --output-on-failure
