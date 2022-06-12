#!/bin/bash
set -euo pipefail

original="$(readlink -f "$1")"
if [[ -z "${2-}" ]]; then
    echo "ERROR: How many clone do you want ?"
    exit 1
else
    mkdir -p "$original"-clones
    for ((i = 0; i < "$2"; i++)); do
        cp -R "$original" "$original"-clones/clone-"$i"
    done
    python3 "$0"/UUID_changer.py "$original"-clones
fi
