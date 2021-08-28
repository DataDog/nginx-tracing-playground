#!/bin/sh

set -e

# Install nginx on Alpine, and then install the nginx-opentracing module and
# its datadog plugin.

# This is based on the "Alpine" section of:
# <https://nginx.org/en/linux_packages.html#instructions>.

apk add openssl curl ca-certificates

# If you want mainline instead of stable, packages/alpine/ -> packages/mainline/alpine/
printf "%s%s%s%s\n" \
    "@nginx " \
    "http://nginx.org/packages/alpine/v" \
    `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
    "/main" \
    | tee -a /etc/apk/repositories

curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub
# TODO: verify the key (see installation instructions)

mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/

apk add nginx@nginx

# The Datadog opentracing plugin for nginx is build for glibc, while Alpine uses musl.
#
# TODO: I haven't found a way to work around this issue.  Commented below are
# some things I've tried.
#
# Based on <https://wiki.alpinelinux.org/wiki/Running_glibc_programs>
# apk add gcompat
#
# Based on <https://dustri.org/b/error-loading-shared-library-ld-linux-x86-64so2-on-alpine-linux.html>
# apk add libc6-compat
# ln -s /lib/libc.musl-x86_64.so.1 /lib/ld-linux-x86-64.so.2

apk add wget jq tar gzip
