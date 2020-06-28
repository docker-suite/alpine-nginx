# ![](https://github.com/docker-suite/artwork/raw/master/logo/png/logo_32.png) alpine-nginx
[![Build Status](http://jenkins.hexocube.fr/job/docker-suite/job/alpine-nginx/badge/icon?color=green&style=flat-square)](http://jenkins.hexocube.fr/job/docker-suite/job/alpine-nginx/)
![Docker Pulls](https://img.shields.io/docker/pulls/dsuite/alpine-nginx.svg?style=flat-square)
![Docker Stars](https://img.shields.io/docker/stars/dsuite/alpine-nginx.svg?style=flat-square)
![MicroBadger Layers (tag)](https://img.shields.io/microbadger/layers/dsuite/alpine-nginx/latest.svg?style=flat-square)
![MicroBadger Size (tag)](https://img.shields.io/microbadger/image-size/dsuite/alpine-nginx/latest.svg?style=flat-square)
[![License: MIT](https://img.shields.io/badge/License-MIT-brightgreen.svg?style=flat-square)](https://opensource.org/licenses/MIT)
[![dockeri.co](https://dockeri.co/image/dsuite/alpine-nginx)](https://hub.docker.com/r/dsuite/alpine-nginx)

A nginx official docker image built on top of [docker-suite (dsuite)][docker-suite] [dsuite/alpine-runit][alpine-runit] container with [runit][runit] process supervisor.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Environment variables

A full list of [dsuite/alpine-base environment variables][alpine-base-readme-variables] are described in the [alpine-base Readme][alpine-base-readme].

<table>
 <thead>
  <tr>
   <th>Variable</th>
   <th>Default</th>
   <th>Description</th>
  </tr>
 </thead>
 <tbody>
  <tr>
   <td><code>NGINX_USER</code></td>
   <td><code>nginx</code></td>
   <td>nginx.conf user</td>
  </tr>
  <tr>
   <td><code>NGINX_WORKER_PROCESSES</code></td>
   <td><code>auto</code></td>
   <td>nginx.conf worker_processes</td>
  </tr>
  <tr>
   <td><code>NGINX_WORKER_CONNECTIONS</code></td>
   <td><code>1024</code></td>
   <td>nginx.conf worker_connections</td>
  </tr>
  </tr>
  <tr>
   <td><code>NGINX_SERVER_NAME</code></td>
   <td><code>localhost</code></td>
   <td>server name defined in conf.d/default.conf</td>
  </tr>
  <tr>
   <td><code>NGINX_ROOT</code></td>
   <td><code>empty</code></td>
   <td>server name defined in conf.d/default.conf</td>
  </tr>
  <tr>
   <td><code>PHP_FPM_ENABLE</code></td>
   <td><code>false</code></td>
   <td>Enable PHP-FPM</td>
  </tr>
  <tr>
   <td><code>PHP_FPM_HOST</code></td>
   <td><code>localhost</code></td>
   <td>IP address or hostname of remote PHP-FPM server.</td>
  </tr>
  <tr>
   <td><code>PHP_FPM_PORT</code></td>
   <td><code>9000</code></td>
   <td>Port of remote PHP-FPM server</td>
  </tr>
 </tbody>
</table>

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Ports

<table>
 <tbody>
  <tr>
   <td><code>80</code></td>
  </tr>
  <tr>
   <td><code>443</code></td>
  </tr>
 </tbody>
</table>


# How to use this image

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Hosting simple static content

```bash
docker run --name some-nginx -v /some/content:/var/www:ro -d dsuite/alpine-nginx
```

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Exposing external port

```bash
docker run --name some-nginx -p 8080:80 -d dsuite/alpine-nginx
```
Then you can hit `http://localhost:8080` or `http://host-ip:8080` in your browser.

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Using your own conf files

```bash
docker run --name some-nginx -v ./nginx.conf:/etc/nginx/nginx.conf:ro -d dsuite/alpine-nginx
```
```bash
docker run --name some-nginx -v ./site.conf:/etc/nginx/conf.d/site.conf:ro -d dsuite/alpine-nginx
```

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Local logs

```bash
docker run --name some-nginx -v ./log:/var/log -d dsuite/alpine-nginx
```

## ![](https://github.com/docker-suite/artwork/raw/master/various/pin/png/pin_16.png) Examples

For more example, look at the [.example](.example) folder.


[runit]: http://smarden.org/runit/
[docker-suite]: https://github.com/docker-suite/
[alpine-base]: https://github.com/docker-suite/alpine-base/
[alpine-runit]: https://github.com/docker-suite/alpine-runit/
[alpine-base-readme]: https://github.com/docker-suite/alpine-base/blob/master/Readme.md/
[alpine-base-readme-variables]: https://github.com/docker-suite/alpine-base/blob/master/Readme.md#-environment-variables
