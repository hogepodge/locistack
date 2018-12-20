#### Required environment variables
# DOCKERHUB_NAMESPACE: the name of the dockerhub repository to push images to
#
####

OPENSTACK_RELEASE=rocky
DOCKERHUB_NAMESPACE=hogepodge
DISTRO=leap15
DIST_PACKAGES="which mariadb curl"
#PIP_PACKAGES="python-openstackclient python-swiftclient"
EMPTY:=

BUILD = docker build
PUSH = docker push $(DOCKERHUB_NAMESPACE)

DOCSTRING="build: builds all Loci containers\
kernel-modules: installs required kernel modules\
swift-storage: creates storage for swift"

docs:
	echo $(DOCSTRING)

build: loci openstack-client

certs: tls tls/openstack.key tls/openstack.csr tls/openstack.crt

tls:
	mkdir tls

tls/openstack.key: tls
	cd tls && openssl genrsa -out openstack.key 2048

tls/openstack.csr: tls tls/openstack.key
	cd tls && openssl req -new -key openstack.key -out openstack.csr

tls/openstack.crt: tls tls/openstack.key tls/openstack.csr
	cd tls &&openssl x509 -req -days 365 -in openstack.csr -signkey openstack.key -out openstack.crt

##### Kernel Modules
# Load kernel modules necessary for Cinder and Neutron
#
# make kernel-modules
#####

kernel-modules:
	sudo modprobe iscsi_tcp
	sudo modprobe ip6_tables
	sudo modprobe ebtables
	sudo modprobe ip_conntrack
	sudo modprobe ip_conntrack_ftp
	sudo modprobe ip_nat_ftp

##### Swift Storage Directory
# Make the loopback device to hold swift storage data
#
# Assumption is that loop0 is the device this lands on
#
# make swift-storage 
####

swift-storage:
	truncate -s 50G swift-storage
	mkfs.xfs swift-storage
	sudo losetup --show -f swift-storage

##### Loci Containers
# Building the Loci packages and push them to Docker Hub.
#
# make loci: build and push all of the Loci images
#####

LOCI_PROJECTS = loci-requirements \
				loci-cinder \
				loci-glance \
				loci-heat \
				loci-horizon \
				loci-ironic \
				loci-keystone \
				loci-neutron \
				loci-nova \
				loci-swift \

loci-build-base:
	rm -rf /tmp/loci
	git clone https://git.openstack.org/openstack/loci.git /tmp/loci
	$(BUILD) -t $(DOCKERHUB_NAMESPACE)/base:$(DISTRO) /tmp/loci/dockerfiles/$(DISTRO)
#	$(PUSH)/base:$(DISTRO)

$(LOCI_PROJECTS):
	$(BUILD) /tmp/loci \
		--build-arg PROJECT=$(subst loci-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=stable/$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/base:$(DISTRO) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/loci-requirements:$(OPENSTACK_RELEASE)-$(DISTRO) \
		--build-arg DIST_PACKAGES=$(DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES)
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DISTRO) --no-cache
#	$(PUSH)/$@:$(OPENSTACK_RELEASE)-$(DISTRO)

loci: loci-build-base $(LOCI_PROJECTS)

#### OpenStack Client
# Build the OpenStack Client
#
# make openstack-client
####

openstack-client:
	$(BUILD) service-containers/openstack-client/. \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DISTRO)
#	$(PUSH)/$@:$(OPENSTACK_RELEASE)-$(DISTRO)
