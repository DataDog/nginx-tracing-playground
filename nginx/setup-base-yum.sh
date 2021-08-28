#!/bin/sh

set -e

# Install nginx on either RHEL or CentOS, and then install the
# nginx-opentracing module and its datadog plugin.

# This is based on the "RHEL/CentOS" section of:
# <https://nginx.org/en/linux_packages.html#instructions>.

yum install -y yum-utils

>/etc/yum.repos.d/nginx.repo cat <<'END_SOURCES'
[nginx-stable]
name=nginx stable repo
baseurl=http://nginx.org/packages/centos/$releasever/$basearch/
gpgcheck=1
enabled=1
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true

[nginx-mainline]
name=nginx mainline repo
baseurl=http://nginx.org/packages/mainline/centos/$releasever/$basearch/
gpgcheck=1
enabled=0
gpgkey=https://nginx.org/keys/nginx_signing.key
module_hotfixes=true
END_SOURCES

# If using mainline instead of stable, uncomment the following line:
# yum-config-manager --enable nginx-mainline

yum install -y nginx

# CentOS 7 needs epel-release for jq
yum install -y epel-release
yum update -y

yum install -y wget jq tar gzip