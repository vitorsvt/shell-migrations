#!/bin/bash

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
