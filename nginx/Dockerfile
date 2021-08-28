# An nginx container that includes the module and plugin required for Datadog tracing.

ARG BASE_IMAGE
FROM ${BASE_IMAGE}

# directory for "build" scripts
RUN mkdir -p /opt/build

# setup-base.sh detects which package manager is being used, and then calls
# the appropriate package-manager-specific script to install nginx, and other
# tools needed below.
COPY ./setup-base.sh ./setup-base-yum.sh ./setup-base-apt.sh ./setup-base-zypper.sh ./setup-base-apk.sh /opt/build/
RUN /opt/build/setup-base.sh

# install-datadog.sh installs the nginx-opentracing module into the nginx
# installed above, and then installs the Datadog opentracing plugin.
COPY ./install-datadog.sh /opt/build/
RUN /opt/build/install-datadog.sh

CMD ["nginx", "-g", "daemon off;"]
