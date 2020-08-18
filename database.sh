#!/bin/bash

# Function for interactions with the DB
# $* => QUERY
# Can also be piped
psql() {
  local args="-q -X -A -t -w -d $DATABASE"
  if [[ $# -eq 0 ]]
  then
    # For piped commands
    "$EXEC" "$args"
  else
    # For normal commands
    "$EXEC" $args -c "$*"
  fi
}

# Add new migration to the tracking table
# $1 => EPOCH / VERSION
addVersion() {
  echo "INSERT INTO \"$MIGRATIONS_TABLE\" (version) values ($1);"
}

# Remove migration from the tracking table
# $1 => EPOCH / VERSION
removeVersion() {
  echo "DELETE FROM \"$MIGRATIONS_TABLE\" WHERE version=$1;"
}

# Get the migrations made, with a optional limit
# $1 => LIMIT
# $2 => COLUMNS
versionHistory() {
  local cols="${2:-version}"
  local sql="SELECT $cols FROM \"$MIGRATIONS_TABLE\" ORDER BY version DESC;"
  [[ -n "$1" ]] && sql="${sql%?} LIMIT $1;"
  # psql => ./database.sh
  psql "$sql" || exit 1
}