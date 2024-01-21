#!/usr/bin/bash

calculate_sha256() {
    echo "Generated: $1:"
    sha256sum -b -t "$1" >> "$1".sha256
}

process_files() {
    local current_dir="$1"
    for file in "$current_dir"/*; do
        if [ -f "$file" ]; then
            calculate_sha256 "$file"
        elif [ -d "$file" ]; then
            process_files "$file"
        fi
    done
}

process_files "$(pwd)"
