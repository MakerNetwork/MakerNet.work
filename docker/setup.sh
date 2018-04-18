#!/bin/bash

prepare_config()
{
  MAKERNET_PATH=${1:-/apps/makernet}

  mkdir -p "$MAKERNET_PATH/example"

  # MakerNet environment variables
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/env.example > "$MAKERNET_PATH/example/env.example"

  # nginx configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx_with_ssl.conf.example > "$MAKERNET_PATH/example/nginx_with_ssl.conf.example"
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/nginx.conf.example > "$MAKERNET_PATH/example/nginx.conf.example"

  # let's encrypt configuration
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/0d8809730eabe6f8ee4712efabd42ef02fc9848b/webroot.ini.example > "$MAKERNET_PATH/example/webroot.ini.example"

  # docker-compose
  \curl -sSL https://gist.githubusercontent.com/MakerNetwork/1393013db25bfe9bf1ccf3dfab49cead/raw/87378c73d8772a521c3663bb652145f7a2cabbdc/docker-compose.yml > "$MAKERNET_PATH/docker-compose.yml"
}

prepare_config "$@"
