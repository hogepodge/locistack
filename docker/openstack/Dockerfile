FROM hogepodge/locistack-base:centos

MAINTAINER "Chris Hoge" <chris@openstack.org>

RUN yum update -y \
  && yum install -y \
         python-openstackclient \
         which \
         vim \
  && yum clean all -y
