#!/bin/sh

# Script name for error messages
SCRIPT=$(basename "$0")
# Migrations directory
MIGRATIONS_DIR="./migrations"
# Label for UP transaction
UP_LABEL="====== UP ======"
# Label for DOWN transaction
DOWN_LABEL="===== DOWN ====="