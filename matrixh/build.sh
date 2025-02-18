#!/bin/bash
cd "$(dirname "$0")" || exit 1
main="matrixh.asm"
bin=${main%.asm}.com
nasm -w+error "${@:2}" -f bin -o "$bin" "$main" || exit 1
[ -f "$bin" ] && echo "$bin" : "$(stat -f%z "$bin")" bytes "$1"
