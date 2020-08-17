#!/bin/bash

MIGRATIONS_FOLDER="./migrations"

checkFolder() {
  [[ -d "$1" ]] && (echo "Loaded '$1'.") || (echo "Creating '$1'..." && mkdir "$1")
}

checkFolder "$MIGRATIONS_FOLDER"