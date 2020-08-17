#!/bin/sh

# Script name for error messages
SCRIPT=$(basename "$0")
# Migrations directory
MIGRATIONS_DIR="./migrations"
# Label for UP transaction
UP_LABEL="====== UP ======"
# Label for DOWN transaction
DOWN_LABEL="===== DOWN ====="
# Migrations table name
MIGRATIONS_TABLE="migrations"
# Database executable
EXEC="$(command -v psql)"
# Database info
DATABASE="vitor"