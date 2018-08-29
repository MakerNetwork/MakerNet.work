#!/usr/bin/env bash

sudo cp example/nginx_with_ssl.conf.example config/nginx/makernet.conf
sudo mkdir -p /apps/makernet/config/nginx/ssl

sudo mkdir -p letsencrypt/config/
sudo mkdir -p letsencrypt/etc/webrootauth
sudo cp example/webroot.ini.example /apps/makernet/letsencrypt/config/webroot.ini

