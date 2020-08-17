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

# Checks if can connect
# Checks if table needs to be created
initMigrations() {
  [[ -x "$EXEC" ]] || end "Could not find database executable."

  echo "$1" >&2

  # PSQL => ./database.sh
  psql "SELECT table_name FROM information_schema.tables WHERE table_schema = 'public';" | grep -q "$MIGRATIONS_TABLE"

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
  psql "CREATE TABLE \"$MIGRATIONS_TABLE\" (\
    version INT NOT NULL PRIMARY KEY,\
    date TIMESTAMP NOT NULL DEFAULT (now() AT TIME ZONE 'utc')\
  );"
}