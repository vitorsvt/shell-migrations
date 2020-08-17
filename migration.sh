#!/bin/bash

. './config.sh'
. './utils.sh'
. './template.sh'

checkDirectory "$MIGRATIONS_DIR"

test_file="MyMigrationFile"
migrationTemplate "$MIGRATIONS_DIR/$(date +"%s")-$test_file" "$test_file"