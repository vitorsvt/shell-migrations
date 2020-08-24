#!/bin/bash

DIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )

. "$DIR/src/config.sh"
. "$DIR/src/utils.sh"
. "$DIR/src/template.sh"
. "$DIR/src/database.sh"
. "$DIR/src/migration.sh"

# setup migrations directory
MIGRATIONS_DIR="$DIR/$MIGRATIONS_DIR"

# checkDirectory => ./utils.sh
checkDirectory "$MIGRATIONS_DIR"

# end => ./utils.sh
[[ $# -eq 0 ]] && end "Please specify an action."
ACTION="$1"
shift 1

case "$ACTION" in
  "init")
    # initMigrations => ./migration.
    initMigrations;;
  "create")
    # end => ./utils.sh
    [[ $# -eq 0 ]] && end "Please specify a migration name."
    # createMigration => ./migration.sh
    createMigration "$@";;
  "migrate")
    migrateUp;;
  "rollback")
    migrateDown;;
  "pending")
    pendingMigrations;;
  "previous")
    previousMigrations;;
  *)
    # end => ./utils.sh
    end "Unknown action.";;
esac