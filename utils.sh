#!/bin/bash

# Creates directory if it doesn't exist.
# $1 => DIRECTORY NAME
checkDirectory() {
  [[ -d "$1" ]] && (echo "Loaded '$1'.") || (echo "Creating '$1'..." && mkdir "$1")
}