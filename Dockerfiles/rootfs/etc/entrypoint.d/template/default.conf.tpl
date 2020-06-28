{{ROOT=/$NGINX_ROOT}}
server {
    listen 80;
    listen [::]:80;

    # define the set names
    server_name  {{NGINX_SERVER_NAME}};

    # define charset
    charset utf-8;

    # Add headers to serve security related headers
    # Before enabling Strict-Transport-Security headers please read into this
    # topic first.
    # add_header Strict-Transport-Security "max-age=15768000;
    # includeSubDomains; preload;";
    #
    # WARNING: Only add the preload option once you read about
    # the consequences in https://hstspreload.org/. This option
    # will add the domain to a hardcoded list that is shipped
    # in all major browsers and getting removed from this list
    # could take several months.
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";
    add_header X-Robots-Tag none;
    add_header X-Download-Options noopen;
    add_header X-Permitted-Cross-Domain-Policies none;
    add_header Content-Security-Policy "frame-ancestors 'self'";

    # Path to the root of your installation
    root   /var/www{{ROOT}};

    # Default indexed files
    index index.htm index.html index.php;

    # Default server location
    location / {
        try_files $uri $uri/ /index.htm /index.html /index.php?$query_string;
    }

    # error pages
    #error_page  404              /404.html;
    #error_page   500 502 503 504  /50x.html;

    ##<php-fpm>##
    # pass the PHP scripts to FastCGI server listening on {{PHP_FPM_HOST}}:{{PHP_FPM_PORT}}
    #
    location ~ \.php$ {
        try_files $uri $uri/ =404;

        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass   {{PHP_FPM_HOST}}:{{PHP_FPM_PORT}};
        fastcgi_index  index.php;
        include        fastcgi_params;
        fastcgi_param  PATH_INFO $fastcgi_path_info;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;

    }
    ##</php-fpm>##

    location = /favicon.ico { allow all; access_log off; log_not_found off; }
    location = /robots.txt  { allow all; access_log off; log_not_found off; }

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}

