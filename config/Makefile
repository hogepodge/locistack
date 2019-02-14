VPATH=tls,/dev

all: docker packages kernel-modules certs loop0

post-boot: kernel-modules loop0

docker: get-docker.sh
	./get-docker.sh
	touch docker

get-docker.sh:
	curl -fsSL https://get.docker.com -o get-docker.sh
	chmod +x get-docker.sh

packages:
	sudo yum install -y device-mapper-persistent-data \
				lvm2 \
				diskimage-builder

	touch packages

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

certs: tls tls/openstack.key tls/openstack.csr tls/openstack.crt

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

loop0: cinder-storage
	./setup-cinder.sh

clean:
	rm -f docker packages get-docker.sh

clean-cinder:
	sudo vgremove cinder-volumes
	sudo pvremove /dev/loop0
	sudo losetup -d /dev/loop0
	sudo rm -f cinder-storage

realclean: clean clean-cinder
	rm -rf tls
