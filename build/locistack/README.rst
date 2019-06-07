==================
Building LociStack
==================

A prerequisite for LociStack is to have a set of Loci images built. This
includes a base image, a requirements image, and a the service images. To
build all of the images, use ``make locistack``.

Configure the build for your environment by setting the variables in the
Makefile:

- ``DOCKERHUB_NAMESPACE=<your dockerhub ID>``
  - This is needed to push your requirements image to.
- ``OPENSTACK_RELEASE={master,stein,rocky,train}``
  - The release you want to build
- ``STABLE_PREFIX={,stable/}``
  - Only set this variable if you use a stable release
- ``DISTRO={centos,leap15,ubuntu}``
  - The distribution you want to build. Locistack only supports centos.
