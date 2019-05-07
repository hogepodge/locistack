IMAGES=linux \
       k8s

VPATH=$(IMAGES)

all: $(addsuffix .qcow2,$(IMAGES)) $(addsuffix .qcow2.md5sum,$(IMAGES))

$(IMAGES):
	mkdir $@

linux.qcow2: | linux
	DIB_DEV_USER_USERNAME=hoge \
	DIB_DEV_USER_PWDLESS_SUDO=true \
	DIB_DEV_USER_AUTHORIZED_KEYS=~/.ssh/id_rsa.pub \
	sudo -E disk-image-create \
		bootloader \
		centos7 \
		cloud-init-nocloud \
		devuser \
		dhcp-all-interfaces \
		epel \
		vm \
		yum \
		-o linux/linux.qcow2 \
		-p vim

k8s.qcow2: | k8s
	DIB_DEV_USER_USERNAME=hoge \
	DIB_DEV_USER_PWDLESS_SUDO=true \
	DIB_DEV_USER_AUTHORIZED_KEYS=~/.ssh/id_rsa.pub \
	ELEMENTS_PATH=$(HOME)/locistack/build/images/elements \
	sudo -E disk-image-create \
		bootloader \
		centos7 \
		cloud-init-nocloud \
		devuser \
		dhcp-all-interfaces \
		epel \
		kubernetes \
		vm \
		yum \
		-o k8s/k8s.qcow2 \
		-p vim

%.qcow2.md5sum:
	md5sum $(*)/$(*).qcow2 | cut -f 1 -d " " > $(*)/$@

