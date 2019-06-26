ARG FROM=hogepodge/loci-base:centos
FROM ${FROM}

ARG DIST_PACKAGES
ARG PIP_PACKAGES
COPY install_packages.sh /usr/bin/install_packages.sh
RUN /usr/bin/install_packages.sh
