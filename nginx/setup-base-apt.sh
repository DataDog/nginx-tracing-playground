#!/bin/sh

set -e

# Install nginx on either debian or ubuntu, and then install the
# nginx-opentracing module and its datadog plugin.

# On newer ubuntus, `apt` has a habit of asking for the user's time zone.
# Setting the "frontend" to "noninteractive" prevents blocking prompts. 
export DEBIAN_FRONTEND=noninteractive

apt-get update
apt-get install --yes lsb-release sed coreutils

distribution_flavor() {
    # e.g. "ubuntu" or "debian"
    lsb_release --id | sed 's/^[^:]\+:\s*\(\S*\)$/\1/' | tr [A-Z] [a-z]
}

flavor=$(distribution_flavor)

# The nginx installation instructions are specific to debian and ubuntu.
# The only differences are which keyring package is installed, and which
# of "ubuntu" or "debian" is mentioned in the nginx package source locations.
case "$flavor" in
    debian) apt-get install --yes debian-archive-keyring ;;
    ubuntu) apt-get install --yes ubuntu-keyring ;;
    *) >&2 echo "warning: nginx doesn't have installation instructions for $flavor"
esac

# What follows is based on a combination of the "Debian" and "Ubuntu" sections
# of <https://nginx.org/en/linux_packages.html#instructions>.

apt-get install --yes curl gnupg2 ca-certificates

curl https://nginx.org/keys/nginx_signing.key | gpg --dearmor \
    | tee /usr/share/keyrings/nginx-archive-keyring.gpg >/dev/null
# TODO: verify the key (see installation instructions)

# Stable, as opposed to mainline.  See the instructions referenced above for
# more information.
echo "deb [signed-by=/usr/share/keyrings/nginx-archive-keyring.gpg] \
http://nginx.org/packages/$flavor `lsb_release -cs` nginx" \
    | tee /etc/apt/sources.list.d/nginx.list

printf "Package: *\nPin: origin nginx.org\nPin: release o=nginx\nPin-Priority: 900\n" \
    | tee /etc/apt/preferences.d/99nginx

apt-get update
apt-get install --yes nginx

apt-get install --yes wget jq tar gzip
