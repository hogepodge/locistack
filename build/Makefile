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
horizon-DIST_PACKAGES="httpd curl mariadb memcached mod_wsgi vim wget which"
PIP_PACKAGES="python-openstackclient python-swiftclient"
EMPTY:=
DIST=$(subst :,$(EMPTY),$(DISTRO))

BUILD = docker build
PUSH = docker push $(DOCKERHUB_NAMESPACE)

##### Loci Containers
# Building the Loci packages and push them to Docker Hub.
#
# make locistack: build and push all of the Loci images
#####

LOCI_PROJECTS = locistack-keystone \
		locistack-glance \
		locistack-neutron \
		locistack-nova \
		locistack-cinder

LOCISTACK_BUILDS = locistack-base \
		locistack-libvirt \
		locistack-requirements \
		$(LOCI_PROJECTS) \
		locistack-openstack

loci:
	git clone https://git.openstack.org/openstack/loci.git loci

locistack-base: loci
	$(BUILD) -t $(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) loci/dockerfiles/$(DISTRO)
	touch $@

locistack-requirements: locistack-base
	$(BUILD) loci \
		--build-arg PROJECT=requirements \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	touch $@

locistack-libvirt: locistack-base
	$(BUILD) libvirt \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	touch $@

$(LOCI_PROJECTS): locistack-base locistack-requirements
	$(BUILD) loci \
		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	touch $@

locistack-openstack: locistack-base
	$(BUILD) openstack \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	touch $@

locistack: $(LOCISTACK_BUILDS)

clean:
	rm locistack*
