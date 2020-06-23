#!/usr/bin/env bash

# set -e : Exit the script if any statement returns a non-true return value.
# set -u : Exit the script when using uninitialised variable.
set -eu

# Generate /etc/nginx/nginx.conf
if [[ ! -f "/etc/nginx/nginx.conf" ]]; then
    DEBUG "Generating /etc/nginx/nginx.conf"
    (export > /tmp/env && set -a && . /tmp/env && templater /etc/entrypoint.d/template/nginx.conf.tpl > /etc/nginx/nginx.conf)
fi

# Generate /etc/nginx/conf.d/default.conf
if [[ -d "/etc/nginx/conf.d" ]] && files=$(ls -qAL -- "/etc/nginx/conf.d") && [[ -z "$files" ]]; then
    DEBUG "Generating /etc/nginx/conf.d/default.conf"
    (export > /tmp/env && set -a && . /tmp/env && templater /etc/entrypoint.d/template/default.conf.tpl > /etc/nginx/conf.d/default.conf)
    # Remove php upstream if php-fpm is not enable
    if [[ "$PHP_FPM_ENABLE" == "0" ]] || [[ "$PHP_FPM_ENABLE" == "false" ]]; then
        DEBUG "php-fpm is disable"
        sed -ri \
            -e '/##<php-fpm>##/,/##<\/php-fpm>##/d' \
            "/etc/nginx/conf.d/default.conf"
        sed -ri \
            -e '/##<php-fpm>##/d' \
            "/etc/nginx/conf.d/default.conf"
        sed -ri \
            -e '/##<\/php-fpm/d' \
            "/etc/nginx/conf.d/default.conf"
    else
        DEBUG "php-fpm is enable"
    fi
fi
