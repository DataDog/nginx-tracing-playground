nginx
=====
This directory defines a docker image containing an nginx instance that's
instrumented for tracing using Datadog.

The [Dockerfile](Dockerfile) uses an `ARG BASE_IMAGE` to parameterize which
Linux distribution to use.  Then nginx and the datadog tracer are installed in
a distribution-specific fashion.

`BASE_IMAGE` is injected as a `docker build --build-arg`, e.g. to use the
base image `ubuntu:18.04`:
```console
$ docker build --build-arg BASE_IMAGE=ubuntu:18.04
```

Much of this code is copied from nginx's [open source installation instructions][1].

[1]: https://nginx.org/en/linux_packages.html
