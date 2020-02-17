#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Log folder
log_dir="/var/log/nginx"
log_access="access.log"
log_error="error.log"

# Create log folder if necessary
if [ ! -d "${log_dir}" ]; then
    DEBUG "Creating log folder: $log_dir"
    mkdir -p $log_dir
fi

# Create access log file
if [ ! -f "${log_dir}/${log_access}" ]; then
    DEBUG "Creating access log file: ${log_dir}/${log_access}"
    touch ${log_dir}/${log_access}
fi

# Create error log file
if [ ! -f "${log_dir}/${log_error}" ]; then
    DEBUG "Creating error log file: ${log_dir}/${log_error}"
    touch ${log_dir}/${log_error}
fi

# Update permissions
chown -R ${NGINX_USER}:${NGINX_USER} ${log_dir}
chmod 0755 ${log_dir}
