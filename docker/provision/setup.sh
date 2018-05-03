#!/bin/bash

prepare_config()
{
  MAKERNET_PATH=${1:-/apps/makernet}

  mkdir -p "$MAKERNET_PATH/example"

  # MakerNet environment variables
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/6baa20efd83c9745357e6dc99b8f7d6d82893329/env.example > "$MAKERNET_PATH/example/env.example"

  # nginx configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx_with_ssl.conf.example > "$MAKERNET_PATH/example/nginx_with_ssl.conf.example"
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx.conf.example > "$MAKERNET_PATH/example/nginx.conf.example"

  # let's encrypt configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/webroot.ini.example > "$MAKERNET_PATH/example/webroot.ini.example"

  # docker-compose
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/6baa20efd83c9745357e6dc99b8f7d6d82893329/docker-compose.yml > "$MAKERNET_PATH/docker-compose.yml"
}

prepare_config "$@"
