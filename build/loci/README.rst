=============
Building Loci
=============

A prerequisite for Locistack is to have a set of Loci images built. This
includes a base image, a requirements image, and a the service images.
These images are stock without any additional profiles installed. It's
assumed that locistack will layer additional packages over the Loci
images.

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

You can build all of the images with ``make all``.
