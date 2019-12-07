{{ROOT=/$NGINX_ROOT}}
server {
    listen       80;
    server_name  {{NGINX_SERVER_NAME}};

    location / {
        root   /var/www{{ROOT}};
        index  index.php index.html index.htm;
    }

    #error_page  404              /404.html;

    # redirect server error pages to the static page /50x.html
    #
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /var/www{{ROOT}};
    }

    ##<php-fpm>##
    # pass the PHP scripts to FastCGI server listening on 127.0.0.1:9000
    #
    location ~ \.php$ {
        root           /var/www{{ROOT}};
        try_files $uri =404;
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass   {{PHP_FPM_HOST}}:{{PHP_FPM_PORT}};
        fastcgi_index  index.php;
        include        fastcgi_params;
        fastcgi_param  PATH_INFO $fastcgi_path_info;
        fastcgi_param  SCRIPT_FILENAME $document_root$fastcgi_script_name;

    }
    ##</php-fpm>##

    # deny access to .htaccess files, if Apache's document root
    # concurs with nginx's one
    #
    #location ~ /\.ht {
    #    deny  all;
    #}
}

