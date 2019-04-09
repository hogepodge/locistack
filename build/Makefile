VPATH=images .phonytarget .build

OPENSTACK_RELEASE=master
#STABLE_PREFIX=stable/
DISTRO=centos

DOCKERHUB_NAMESPACE=hogepodge

requirements-DIST_PACKAGES=""
keystone-DIST_PACKAGES="curl mariadb vim wget which"
glance-DIST_PACKAGES="curl mariadb vim wget which"
neutron-DIST_PACKAGES="bridge-utils conntrack-tools curl dnsmasq dnsmasq-utils ebtables haproxy iproute ipset keepalived mariadb openvswitch uuid vim wget which"
nova-DIST_PACKAGES="curl libvirt libxml2 mariadb openvswitch uuid vim wget which"
cinder-DIST_PACKAGES="curl lvm2 mariadb targetcli device-mapper-persistent-data vim wget which"
ironic-DIST_PACKAGES="curl gdisk gettext graphviz ipmitool ipxe-bootimgs iscsi-initiator-utils mariadb nginx parted psmisc qemu-img syslinux tftp-server wget which xinetd"
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
		locistack-cinder \
		locistack-ironic \
		locistack-swift

LOCISTACK_BUILDS = locistack-base \
		locistack-libvirt \
		locistack-requirements \
		locistack-dnsmasq \
		$(LOCI_PROJECTS) \
		locistack-openstack

locistack: $(LOCISTACK_BUILDS)

.phonytarget:
	mkdir .phonytarget

loci: .build
	git clone https://git.openstack.org/openstack/loci.git .build/loci

.build:
	mkdir .build

locistack-base: loci
	$(BUILD) -t $(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) .build/loci/dockerfiles/$(DISTRO)
	docker image inspect $(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) > .phonytarget/$@

locistack-epel: locistack-base
	$(BUILD) epel \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		-t $(DOCKERHUB_NAMESPACE)/locistack-epel:$(DIST) 
	docker image inspect $(DOCKERHUB_NAMESPACE)/locistack-epel:$(DIST)

locistack-requirements: locistack-base
	$(BUILD) .build/loci \
		--build-arg PROJECT=requirements \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	$(PUSH) $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

locistack-libvirt: locistack-base
	$(BUILD) libvirt \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

locistack-dnsmasq:
	$(BUILD) dnsmasq \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@


$(LOCI_PROJECTS): locistack-base locistack-requirements
	$(BUILD) .build/loci \
		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

locistack-ironic: locistack-epel locistack-requirements
	$(BUILD) .build/loci \
		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-epel:$(DIST) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@

locistack-openstack: locistack-base
	$(BUILD) openstack \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	docker image inspect $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .phonytarget/$@


centos7-k8s.qcow2:
	cd images && ./k8s.sh

clean:
	rm locistack*
