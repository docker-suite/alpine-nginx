# =================================================================================================
# MAIN SETTINGS
# =================================================================================================

# Defines user and group credentials used by worker processes.
# If group is omitted, a group whose name equals that of user is used.
user {{NGINX_USER}};

#
daemon off;

# Defines the number of worker processes.
worker_processes {{NGINX_WORKER_PROCESSES}};

# Configures logging.
error_log  /var/log/nginx/error.log warn;

# Defines a file that will store the process ID of the main process.
pid        /var/run/nginx.pid;

# Sets the maximum number of simultaneous connections that can be opened by a worker process.
events {
    worker_connections  {{NGINX_WORKER_CONNECTIONS}};
}


# =================================================================================================
# HTTP SETTINGS
# =================================================================================================

http {

    # -------------------------------------------------------------------------------
    # NGINX DEFAULTS
    # -------------------------------------------------------------------------------

    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    # Configures logging.
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;


    # -------------------------------------------------------------------------------
    # NGINX HEADER
    # -------------------------------------------------------------------------------

    # Set valid Via header: <PROTOCOL_VERSION> <HOSTNAME> (<SERVER>/<SERVER_VERSION>)
    #map $server_protocol $my_proto {
    #    "~^HTTP\/(?<version>[.0-9]+)$" $version;
    #    default                        $server_protocol;
    #}
    #add_header Via '$my_proto $hostname (nginx/$nginx_version)' always;


    # -------------------------------------------------------------------------------
    # NGINX PERFORMANCE
    # -------------------------------------------------------------------------------

    sendfile        on;
    #tcp_nopush     on;
    #aio            on;
    #gzip           on;


    # -------------------------------------------------------------------------------
    # BUFFER SIZES
    # -------------------------------------------------------------------------------

    # The maximum allowed size for a client request. If the maximum size is exceeded,
    # then Nginx will spit out a 413 error or Request Entity Too Large.
    # Setting size to 0 disables checking of client request body size.
    client_max_body_size 0;


    # -------------------------------------------------------------------------------
    # TIMEOUTS
    # -------------------------------------------------------------------------------

    keepalive_timeout  65;


    # -------------------------------------------------------------------------------
    # HIDE NGINX SERVER VERSION
    # -------------------------------------------------------------------------------

    server_tokens          off;


    # -------------------------------------------------------------------------------
    # INCLUDES
    # -------------------------------------------------------------------------------

    include /etc/nginx/conf.d/*.conf;
}
