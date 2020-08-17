#!/bin/bash

. './config.sh'
. './utils.sh'
. './template.sh'

# Find a migration by name.
# $1 => Name of the migration
findMigration() {
  find "$MIGRATIONS_DIR" -type f -name "$1"
}

create() {
  local name="${1// /_}"
  [[ $name =~ ^[a-zA-Z0-9_.\-]+$ ]] || end "Invalid characters in '$name'."
  findMigration "*-$name.sql" | grep -q "$name" && end "Migration '$name' already exists."

  local filename="$MIGRATIONS_DIR/$(date +"%s")-$name.sql"
  migrationTemplate "$filename" "$name"

  [[ "$?" -eq 0 ]]\
    && (echo -e "Migration file '$filename' created." && return 0)\
    || (end 'Error while creating migration...' && return 1)
}

checkDirectory "$MIGRATIONS_DIR"

test="MyTestMigration"
create "$test"