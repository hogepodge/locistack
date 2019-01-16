FROM centos

MAINTAINER "Chris Hoge" <chris@openstack.org>

RUN yum update -y \
  && yum install -y \
         augeas \
         libvirt-client \
         libvirt-daemon \
         libvirt-client \
         libvirt-daemon-kvm \
         openvswitch \
         qemu-kvm \
  && yum clean all -y
COPY augconf /augconf
RUN augtool -f /augconf
COPY start-libvirt.sh /start-libvirt.sh
RUN chmod a+x /start-libvirt.sh
