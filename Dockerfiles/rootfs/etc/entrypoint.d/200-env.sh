#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Add libraries
source /usr/local/lib/bash-logger.sh
source /usr/local/lib/persist-env.sh

[ -n "$(env_get "NGINX_DEBUG")" ]           && env_set "NGINX_DEBUG" "$(env_get "NGINX_DEBUG")" || true
