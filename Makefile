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

mount-cinder-storage: glance-storage
	sudo losetup /dev/loop1 cinder-storage


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
EMPTY:=

BUILD = docker build
RUN = docker run --rm -it
PUSH = docker push $(DOCKERHUB_NAMESPACE)


certs: tls tls/openstack.key tls/openstack.csr tls/openstack.crt

tls:
	mkdir tls

tls/openstack.key: tls
	cd tls && openssl genrsa -out openstack.key 2048

tls/openstack.csr: tls tls/openstack.key
	cd tls && openssl req -new -key openstack.key -out openstack.csr

tls/openstack.crt: tls tls/openstack.key tls/openstack.csr
	cd tls &&openssl x509 -req -days 365 -in openstack.csr -signkey openstack.key -out openstack.crt


openstack-client: locistack-openstack
	$(RUN) -v ${CURDIR}/scripts/common:/scripts/common \
		-v ${CURDIR}/scripts/client:/scripts/client \
		-v ${CURDIR}/scripts/post-install:/scripts/post-install \
		-v ${CURDIR}/images:/images \
		--env-file config \
		$(DOCKERHUB_NAMESPACE)/locistack-openstack:$(OPENSTACK_RELEASE)-$(DIST) bash

post-boot: mount-glance-storage mount-cinder-storage kernel-modules dm_thin_pool


up: mount-glance-storage kernel-modules
	docker-compose up -d

down:
	docker-compose down

down-v:
	docker-compose down -v

logs:
	docker-compose logs -f
