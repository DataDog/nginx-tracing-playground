#!/bin/sh

set -e

# Install the nginx-opentracing module to the appropriate location for use by
# nginx.  Then install the Datadog opentracing plugin.
# The module and plugin are fetched from the most recent release in their
# respective github projects.

# This script is agnostic with respect to Linux distribution: it assumes that
# all required command line tools are already installed.

# This is based off of the following documentation:
# <https://docs.datadoghq.com/tracing/setup_overview/proxy_setup/?tab=nginx>.

# Throughout this script, wget always has the "-4" flag, forcing IPv4 to be
# used.  I found that this was necessary in order to prevent DNS resolution
# from failing on Alpine Linux.

get_latest_release() {
  wget -4 --quiet -O - "https://api.github.com/repos/$1/releases/latest" | \
    jq --raw-output '.tag_name'
}

get_nginx_version() {
    nginx -v 2>&1 | sed 's,.*\snginx/\([0-9.]\+\).*,\1,'
}

get_nginx_modules_path() {
    nginx -V 2>&1 | sed --quiet 's/.*--modules-path=\(\S*\).*/\1/p'
}

NGINX_VERSION=$(get_nginx_version)
NGINX_MODULES_PATH=$(get_nginx_modules_path)
OPENTRACING_NGINX_VERSION=$(get_latest_release opentracing-contrib/nginx-opentracing)
DD_OPENTRACING_CPP_VERSION=$(get_latest_release DataDog/dd-opentracing-cpp)

# Install NGINX plugin for OpenTracing
wget -4 "https://github.com/opentracing-contrib/nginx-opentracing/releases/download/${OPENTRACING_NGINX_VERSION}/linux-amd64-nginx-${NGINX_VERSION}-ot16-ngx_http_module.so.tgz"
tar zxf "linux-amd64-nginx-${NGINX_VERSION}-ot16-ngx_http_module.so.tgz" -C "$NGINX_MODULES_PATH"

# Install Datadog Opentracing C++ Plugin
wget -4 "https://github.com/DataDog/dd-opentracing-cpp/releases/download/${DD_OPENTRACING_CPP_VERSION}/linux-amd64-libdd_opentracing_plugin.so.gz"
gunzip linux-amd64-libdd_opentracing_plugin.so.gz -c > /usr/local/lib/libdd_opentracing_plugin.so
