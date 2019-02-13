#### Required environment variables
# DOCKERHUB_NAMESPACE: the name of the dockerhub repository to push images to
#
###

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
	sudo modprobe br_netfilter
	sudo sysctl net.bridge.bridge-nf-call-iptables=1
	sudo sysctl net.bridge.bridge-nf-call-ip6tables=1
	sudo setenforce Permissive

##### Glance Storage Directory
# Make the loopback device to hold glance storage data
#
# Assumption is that loop0 is the device this lands on
#
# make glance-storage 
####

glance-storage:
	truncate -s 50G glance-storage
	mkfs.xfs glance-storage

mount-glance-storage: glance-storage
	sudo losetup /dev/loop0 glance-storage


##### Cinder Storage
lvm2:
	sudo yum install -y lvm2

thin-provisioning-tools:
	sudo yum install -y device-mapper-persistent-data

dm_thin_pool:
	sudo modprobe dm_thin_pool

cinder-requirements: thin-provisioning-tools lvm2 dm_thin_pool

cinder-storage:
	${CURDIR}/scripts/host/setup-cinder.sh

# Get next available loop device
# LD=$(sudo losetup -f)
# sudo losetup $LD cinder-volumes.img
# sudo sfdisk $LD &lt;&lt; EOF
# ,,8e,,
# EOF
# sudo pvcreate $LD
# sudo vgcreate cinder-volumes $LD

OPENSTACK_RELEASE=master
#STABLE=stable/
DOCKERHUB_NAMESPACE=hogepodge
DISTRO=centos
requirements-DIST_PACKAGES=""
keystone-DIST_PACKAGES="curl mariadb vim wget which"
glance-DIST_PACKAGES="curl mariadb vim wget which"
neutron-DIST_PACKAGES="bridge-utils conntrack-tools curl dnsmasq dnsmasq-utils ebtables haproxy iproute ipset keepalived mariadb openvswitch uuid vim wget which"
nova-DIST_PACKAGES="curl libvirt libxml2 mariadb openvswitch uuid vim wget which"
cinder-DIST_PACKAGES="curl lvm2 mariadb targetcli device-mapper-persistent-data vim wget which"
horizon-DIST_PACKAGES="httpd curl mariadb memcached mod_wsgi vim wget which"
DIST_PACKAGES="bridge-utils conntrack-tools curl dnsmasq dnsmasq-utils ebtables haproxy iproute ipset keepalived liberasurecode libvirt libxml2 mariadb memcached openvswitch rsync supervisor uuid vim wget which"
PIP_PACKAGES="python-openstackclient python-swiftclient"
EMPTY:=
DIST=$(subst :,$(EMPTY),$(DISTRO))

BUILD = docker build
RUN = docker run --rm -it
PUSH = docker push $(DOCKERHUB_NAMESPACE)

DOCSTRING="build: builds all Loci containers\
kernel-modules: installs required kernel modules\
swift-storage: creates storage for swift"

docs:
	echo $(DOCSTRING)

build: locistack openstack-client

certs: tls tls/openstack.key tls/openstack.csr tls/openstack.crt

tls:
	mkdir tls

tls/openstack.key: tls
	cd tls && openssl genrsa -out openstack.key 2048

tls/openstack.csr: tls tls/openstack.key
	cd tls && openssl req -new -key openstack.key -out openstack.csr

tls/openstack.crt: tls tls/openstack.key tls/openstack.csr
	cd tls &&openssl x509 -req -days 365 -in openstack.csr -signkey openstack.key -out openstack.crt

##### Loci Containers
# Building the Loci packages and push them to Docker Hub.
#
# make locistack: build and push all of the Loci images
#####

LOCI_PROJECTS = locistack-requirements \
				locistack-keystone \
				locistack-glance \
				locistack-neutron \
				locistack-nova \
				locistack-cinder
#				locistack-horizon \
#				locistack-heat \
#				locistack-ironic \
#				locistack-swift \

locistack-build-base:
#	rm -rf /tmp/loci
#	git clone https://git.openstack.org/openstack/loci.git /tmp/loci
	$(BUILD) -t $(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) /tmp/loci/dockerfiles/$(DISTRO)
#	$(PUSH)/locistack-base:$(DISTRO)

$(LOCI_PROJECTS):
	$(BUILD) /tmp/loci \
		--build-arg PROJECT=$(subst locistack-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=$(STABLE)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/locistack-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst locistack-,$(EMPTY),$@)-DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
#	$(PUSH)/$@:$(OPENSTACK_RELEASE)-$(DIST)

locistack-requirements:
	$(BUILD) /tmp/loci \
		--build-arg PROJECT=requirements \
		--build-arg PROJECT_REF=$(STABLE)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/locistack-base:$(DIST) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
#	$(PUSH)/$@:$(OPENSTACK_RELEASE)-$(DIST)

locistack-libvirt:
	$(BUILD) docker/libvirt \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)

locistack-openstack:
	$(BUILD) docker/openstack \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
#	$(PUSH)/$@:$(OPENSTACK_RELEASE)-$(DIST)

locistack: locistack-build-base $(LOCI_PROJECTS)

openstack-client: locistack-openstack
	$(RUN) -v ${CURDIR}/scripts/common:/scripts/common \
		-v ${CURDIR}/scripts/client:/scripts/client \
		-v ${CURDIR}/scripts/post-install:/scripts/post-install \
		-v ${CURDIR}/images:/images \
		--env-file config \
		$(DOCKERHUB_NAMESPACE)/locistack-openstack:$(OPENSTACK_RELEASE)-$(DIST) bash


up: mount-glance-storage kernel-modules
	docker-compose up -d

down:
	docker-compose down

down-v:
	docker-compose down -v

logs:
	docker-compose logs -f
