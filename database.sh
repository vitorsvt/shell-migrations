#!/bin/bash

psql() {
  local args="-q -X -t -w -d $DATABASE"
  if [[ $# -eq 0 ]]
  then
    # For piped commands
    "$EXEC" "$args"
  else
    # For normal commands
    "$EXEC" $args -c "$*"
  fi
}