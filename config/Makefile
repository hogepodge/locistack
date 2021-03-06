VPATH=/dev .phonytarget

enough: kernel-modules loop0 loop1

all: docker packages kernel-modules loop0 loop1

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

cinder-storage:
	sudo truncate --size=20G cinder-storage
	./scripts/setup-cinder.sh

loop0: cinder-storage
	sudo losetup /dev/loop0 cinder-storage
	yes | sudo pvcreate /dev/loop0
	sudo vgcreate cinder-volumes /dev/loop0

swift-storage:
	sudo truncate --size=20G swift-storage
	sudo mkfs.xfs swift-storage

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
