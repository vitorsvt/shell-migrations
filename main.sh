#!/bin/bash

. './config.sh'
. './utils.sh'
. './template.sh'
. './database.sh'
. './migration.sh'

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
  "up")
    getTransaction "$1" "$2";;
  *)
    # end => ./utils.sh
    end "Unknown action.";;
esac