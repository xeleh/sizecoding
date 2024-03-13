#!/bin/bash
cd "$(dirname "$0")" || exit 1
main="vccc2023.s"
bin=${main%.s}
vasmm68k_mot -Fhunkexe -kick1hunks -nosym -showopt -o "$bin" "$main" || exit 1
[ -f "$bin" ] && echo "$bin" : "$(stat -f%z "$bin")" bytes
