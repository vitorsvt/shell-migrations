#!/bin/bash

# Find a migration by name.
# $1 => MIGRATION NAME
findMigration() {
  find "$MIGRATIONS_DIR" -type f -name "$1"
}

# Create a new migration
# Does not allow migration overwrite
# $1 => MIGRATION NAME
createMigration() {
  local name="${1// /_}"
  # end => migrations.sh
  [[ $name =~ ^[a-zA-Z0-9_.\-]+$ ]] || end "Invalid characters in '$name'."
  # end => migrations.sh
  findMigration "*-$name.sql" | grep -q "$name" && end "Migration '$name' already exists."

  local filename="$MIGRATIONS_DIR/$(date +"%s")-$name.sql"
  migrationTemplate "$filename" "$name"

  # end => migrations.sh
  [[ "$?" -eq 0 ]]\
    && (echo -e "Migration file '$filename' created." && return 0)\
    || (end 'Error while creating migration...' && return 1)
}

# Get the pending migrations to be made
# Optional limit
# $1 => LIMIT
pendingMigrations() {
  local last=$(versionHistory 1)
  last="${last:-0}"
  history="$(findMigration "*" | sort -t- -k1n)"
  [[ "$last" = 0 ]]\
    && echo "$history"\
    ||echo "$history" | sed -e '0,/^.*'"$last"'.*\.sql$/d'
}

# Get the previous made migrations
previousMigrations() {
  versionHistory | while read -r version
  do
    local migration=$(findMigration "$version-*.sql")
    [[ -z $migration ]] && end "Migration '$version' could not be found."
    echo "$migration"
  done
}

# Migrate
# $1 => 'UP' or 'DOWN'
migrate() {
  if [ "$1" = "UP" ]
  then
    local action="UP"
    local message="Applying migration"
    local which=pendingMigrations
    local version=addVersion
  else
    local action="DOWN"
    local message="Reverting migration"
    local which=previousMigrations
    local version=removeVersion
  fi

  "$which" | while read -r migration
  do
    local epoch=$(getEpoch "$migration")
    local name=$(getName "$migration")
    local author=$(getAuthor "$migration")

    echo "$SCRIPT: $message $name ($epoch) by $author."
    psql "$(getTransaction "$migration" "$action") $("$version" "$epoch")"
  done
}

# Make migration UP
migrateUp() {
  migrate "UP"
}

migrateDown() {
  migrate "DOWN"
}

# Get file name / label
# $1 => FILE NAME
getName() {
  grep -- "-- Name:" "$1" | sed -e 's/-- Name: //g'
}

# Get file name / label
# $1 => FILE NAME
getAuthor() {
  grep -- "-- Author:" "$1" | sed -e 's/-- Author: //g'
}

# Get file Epoch
# $1 => FILE NAME
getEpoch() {
  basename "$1" | cut -d - -f 1
}

# Gets the UP and DOWN transactions
# from the migration
# $1 => FILE NAME
# $2 => 'UP' or 'DOWN'
getTransaction() {
  local file="$1"
  if [ "${2^^}" = "UP" ]
  then
    local begin="-- $UP_LABEL"
    local end="-- $DOWN_LABEL"
  else
    local begin="-- $DOWN_LABEL"
    local end="-- $UP_LABEL"
  fi

  sed -n -e '/'"$begin"'/,/'"$end"'/p' "$file" | grep -v -e '^--' -e '^$'
}

# Checks if can connect
# Checks if table needs to be created
initMigrations() {
  [[ -x "$EXEC" ]] || end "Could not find database executable."

  local sql="SELECT table_name FROM information_schema.tables WHERE table_schema='public';"
  # PSQL => ./database.sh
  psql "$sql" | grep -q "$MIGRATIONS_TABLE"

  if [ "$?" -eq 0 ]
  then
    return 0
  else
    initMigrationTable
    [ "$?" -eq 0 ] && return 0 || end 'Could not initialize migrations table.';
  fi
}

# Creates the migration table
initMigrationTable() {
  echo "Creating migrations table..." >&2
  local sql="CREATE TABLE \"$MIGRATIONS_TABLE\" (\
    version INT NOT NULL PRIMARY KEY,\
    date TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'utc')\
  );"
  # PSQL => ./database.sh
  psql "$sql"
}