#!/bin/sh

# Check for the presence of known package management tools, and dispatch to a
# tool-specific installer that will install nginx, the opentracing nginx module, and the
# Datadog opentracing plugin.

command_exists() {
    >/dev/null 2>&1 command -v "$@"
}

script_dir=$(dirname "$0")

if command_exists apt; then
    exec "$script_dir/setup-base-apt.sh"
elif command_exists yum; then
    exec "$script_dir/setup-base-yum.sh"
elif command_exists zypper; then
    exec "$script_dir/setup-base-zypper.sh"
elif command_exists apk; then
    exec "$script_dir/setup-base-apk.sh"
else
    >&2 echo "I don't recognize the package manager on this system.  Unable to install nginx."
    exit 1
fi
