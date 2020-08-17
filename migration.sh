#!/bin/bash

ME=$(basename "$0")
MIGRATIONS_FOLDER="./migrations"

UP_LABEL="====== UP ======"
DOWN_LABEL="===== DOWN ====="

# Template for the migration file
# $1 => FILE NAME
# $2 => MIGRATION NAME
migrationTemplate() {
  cat >> "$1" << EOF
-- Name: $2
-- Created: $(date +"%Y-%m-%d at %H:%M")
-- Author: $(whoami)
-- $UP_LABEL
BEGIN;
COMMIT;
-- $DOWN_LABEL
BEGIN;
COMMIT;
EOF
}

# Creates folder if it doesn't exist.
# $1 => DIRECTORY NAME
checkFolder() {
  [[ -d "$1" ]] && (echo "Loaded '$1'.") || (echo "Creating '$1'..." && mkdir "$1")
}

checkFolder "$MIGRATIONS_FOLDER"

migrationTemplate "$MIGRATIONS_FOLDER/EPOCH-MyMigrationFile" "MyMigrationFile"