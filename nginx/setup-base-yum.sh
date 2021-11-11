#!/bin/sh

set -e
set -x

yum update -y
yum install -y yum-utils

>/etc/yum.repos.d/nginx.repo cat <<'END_CONFIG'
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
END_CONFIG

yum update -y

# These are different builds of nginx...
# yum module reset nginx
# yum module enable -y nginx:1.18
# yum install -y nginx

# CentOS 7 needs epel-release for jq
# yum install -y epel-release
# yum update -y

yum install -y nginx-1:1.18.0-2.el8.ngx

yum install -y wget jq tar gzip