FROM hogepodge/loci-base:centos

MAINTAINER "Chris Hoge" <chris@openstack.org>

RUN yum update -y \
  && yum install -y \
         python-openstackclient \
         python-ironicclient \
         which \
         vim \
  && yum clean all -y
