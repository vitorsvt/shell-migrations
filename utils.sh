#!/bin/bash

# End script to stderr
# $1 => ERROR MESSAGE
end() {
  cat >&2 << EOF
Usage: $SCRIPT <action>

EOF
  [[ $# -gt 0 ]] && echo "$SCRIPT: $1" >&2
  exit 1
}

# Creates directory if it doesn't exist.
# $1 => DIRECTORY NAME
checkDirectory() {
  [[ -d "$1" ]] && (echo "Loaded '$1'.") || (echo "Creating '$1'..." && mkdir "$1")
}