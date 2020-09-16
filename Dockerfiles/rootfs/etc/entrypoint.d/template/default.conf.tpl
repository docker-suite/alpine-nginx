{{ROOT=/$NGINX_ROOT}}
server {
    listen 80 default;
    listen [::]:80 default;

    # define the server names
    server_name  {{NGINX_SERVER_NAME}};

    # define charset
    charset utf-8;

    # Path to the root of your installation
    root   /var/www{{ROOT}};

    # Default indexed files
    index index.htm index.html index.php;

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

    # error pages
    #error_page  404              /404.html;
    #error_page   500 502 503 504  /50x.html;

    # Default server location
    location / {
        try_files $uri $uri/ /index.htm /index.html /index.php?$query_string;
    }

    location = /favicon.ico { allow all; access_log off; log_not_found off; }
    location = /robots.txt  { allow all; access_log off; log_not_found off; }

  	# allow larger file uploads and longer script runtimes
 	client_max_body_size 100m;
  	client_body_timeout 120s;
    sendfile off;

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
        fastcgi_param PHP_VALUE "upload_max_filesize = 100M \n post_max_size=100M";
        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }
    ##</php-fpm>##

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    location ~ /\.ht {
        deny  all;
    }
}

