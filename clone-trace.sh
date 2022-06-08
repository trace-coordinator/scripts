#!/bin/bash
set -euo pipefail

original="$(readlink -f "$1")"
if [[ $(( ${2-} )) == 0 ]];then
    limit=20
else
    limit=$2
fi

mkdir -p "$original"_clones
for (( i = 0; i < $limit; i++ )); do
    cp -R "$original" "$original"-clones/clone-$i
done

python3 UUID_changer.py "$original"_clones
