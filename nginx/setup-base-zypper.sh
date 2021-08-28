#!/bin/sh

set -e

# Install nginx on SLES/OpenSUSE, and then install the nginx-opentracing module
# and its datadog plugin.

# This is based on the "SLES" section of:
# <https://nginx.org/en/linux_packages.html#instructions>.

install() {
    zypper --non-interactive install --auto-agree-with-licenses "$@"
}

install curl ca-certificates gpg2

# If you want mainline instead of stable, sles/ -> mainline/sles/
zypper addrepo --gpgcheck --type yum --refresh --check \
    'http://nginx.org/packages/sles/$releasever_major' nginx-stable

curl -o /tmp/nginx_signing.key https://nginx.org/keys/nginx_signing.key
# TODO: verify the key (see installation instructions)

rpmkeys --import /tmp/nginx_signing.key
install nginx

install wget jq tar gzip
