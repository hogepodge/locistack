VPATH=images .phonytarget .build

OPENSTACK_RELEASE=master
#STABLE_PREFIX=stable/
DISTRO=centos

DOCKERHUB_NAMESPACE=hogepodge

keystone-DIST_PACKAGES="curl mariadb vim wget which"
glance-DIST_PACKAGES="curl mariadb vim wget which"
neutron-DIST_PACKAGES="bridge-utils conntrack-tools curl dnsmasq dnsmasq-utils ebtables haproxy iproute ipset keepalived mariadb openvswitch uuid vim wget which"
nova-DIST_PACKAGES="curl libvirt libxml2 mariadb openvswitch uuid vim wget which"
placement-DIST_PACKAGES="curl libxml2 mariadb uuid vim wget which"
cinder-DIST_PACKAGES="curl lvm2 mariadb targetcli device-mapper-persistent-data vim wget which"
ironic-DIST_PACKAGES="epel-release curl gdisk gettext graphviz ipmitool ipxe-bootimgs targetcli mariadb nginx parted psmisc qemu-img syslinux tftp-server wget which xinetd"
swift-DIST_PACKAGES="rsync liberasurecode memcached vim wget curl which"
#horizon-DIST_PACKAGES="httpd curl mariadb memcached mod_wsgi vim wget which"
PIP_PACKAGES="python-openstackclient python-swiftclient python-ironicclient keystonemiddleware"
EMPTY:=
DIST=$(subst :,$(EMPTY),$(DISTRO))

BUILD = docker build
PUSH = docker push

LOCI_PROJECTS = locistack-keystone \
		locistack-glance \
		locistack-neutron \
		locistack-nova \
		locistack-placement \
		locistack-cinder \
		locistack-ironic \
		locistack-swift

locistack: $(LOCI_PROJECTS)

.phonytarget:
	mkdir .phonytarget

.build:
	mkdir .build

$(LOCI_PROJECTS): | .phonytarget
	$(BUILD) . \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/$(subst locistack-,loci-,$@):$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

#locistack-ironic: locistack-epel locistack-requirements | .phonytarget
#	$(BUILD) .build/loci \
#		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
#		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
#		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-epel:$(DIST) \
#		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
#		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
#		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
#		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
#	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

#locistack-cinder: locistack-epel locistack-requirements | .phonytarget
#	$(BUILD) .build/loci \
#		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
#		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
#		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-epel:$(DIST) \
#		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
#		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
#		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
#		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
#	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@
