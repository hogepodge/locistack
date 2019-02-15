VPATH=tls /dev .phonytarget

all: docker packages kernel-modules certs loop0

post-boot: kernel-modules loop0 loop1

docker: get-docker.sh .phonytarget
	./scripts/get-docker.sh 2>&1 | tee .phonytarget/docker

get-docker.sh:
	curl -fsSL https://get.docker.com -o ./scripts/get-docker.sh
	chmod +x ./scripts/get-docker.sh

packages: .phonytarget
	sudo yum install -y device-mapper-persistent-data \
				lvm2 \
				diskimage-builder 2>&1 | \
		tee .phonytarget/packages

.phonytarget:
	mkdir .phonytarget

kernel-modules: packages
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
	sudo modprobe dm_thin_pool

certs: tls openstack.key openstack.csr openstack.crt

tls:
	mkdir tls

openstack.key: tls
	cd tls && openssl genrsa -out openstack.key 2048

openstack.csr: tls openstack.key
	cd tls && openssl req -new -key openstack.key -out openstack.csr

openstack.crt: tls openstack.key openstack.csr
	cd tls && openssl x509 -req -days 365 -in openstack.csr -signkey openstack.key -out openstack.crt

cinder-storage:
	sudo truncate --size=20G cinder-storage
	./scripts/setup-cinder.sh

loop0: cinder-storage
	sudo losetup /dev/loop0 cinder-storage
	yes | sudo pvcreate /dev/loop0
	sudo vgcreate cinder-volumes /dev/loop0

swift-storage:
	sudo truncate --size=20G swift-storage
	mkfs.xfs swift-storage

loop1: swift-storage
	sudo losetup /dev/loop1 swift-storage

clean:
	rm -f docker packages get-docker.sh

clean-cinder:
	sudo vgremove cinder-volumes
	sudo pvremove /dev/loop0
	sudo losetup -d /dev/loop0
	sudo rm -f cinder-storage

realclean: clean clean-cinder
	rm -rf tls
