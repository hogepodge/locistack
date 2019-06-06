# It's useful to have an empty variable
EMPTY:=

# Build parameters
DOCKERHUB_NAMESPACE=hogepodge
OPENSTACK_RELEASE=master
# uncomment if you want to build from a stable branch
# do not use if you want to build from master or a git hash
# STABLE_PREFIX=stable/
DISTRO=centos
DIST=$(subst :,$(EMPTY),$(DISTRO))

BUILD=docker build
PUSH=docker push
INSPECT=docker image inspect

VPATH=images .buildtarget .loci

# A fake build target diectory with information about the builds
.buildtarget:
	mkdir .buildtarget

.loci:
	mkdir .loci

loci: .loci
	git clone https://git.openstack.org/openstack/loci.git .loci/loci

## Build base loci images

loci-base: loci | .buildtarget
	$(BUILD) -t $(DOCKERHUB_NAMESPACE)/loci-base:$(DIST) .loci/loci/dockerfiles/$(DISTRO)
	docker image inspect $(DOCKERHUB_NAMESPACE)/loci-base:$(DIST) > .buildtarget/$@

# Build the stock service loci images
LOCI_PROJECTS = loci-keystone \
		loci-glance \
		loci-neutron \
		loci-nova \
		loci-placement \
		loci-cinder \
		loci-ironic \
		loci-swift

all: loci-base loci-requirements $(LOCI_PROJECTS)

loci-requirements: loci-base | .buildtarget
	$(BUILD) .loci/loci \
		--build-arg PROJECT=requirements \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/loci-base:$(DIST) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	$(PUSH) $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST)
	$(INSPECT) $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .buildtarget/$@

$(LOCI_PROJECTS): loci-base loci-requirements | .buildtarget
	$(BUILD) .loci/loci \
		--build-arg PROJECT=$(subst loci-,$(EMPTY),$@) \
		--build-arg PROJECT_REF=$(STABLE_PREFIX)$(OPENSTACK_RELEASE) \
		--build-arg FROM=$(DOCKERHUB_NAMESPACE)/loci-base:$(DIST) \
		--build-arg WHEELS=$(DOCKERHUB_NAMESPACE)/loci-requirements:$(OPENSTACK_RELEASE)-$(DIST) \
		--build-arg DIST_PACKAGES=$($(subst loci-,$(EMPTY),$@)-DIST_PACKAGES) \
		--build-arg PIP_PACKAGES=$(PIP_PACKAGES) \
		--tag $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) --no-cache
	$(INSPECT) $(DOCKERHUB_NAMESPACE)/$@:$(OPENSTACK_RELEASE)-$(DIST) > .buildtarget/$@

push: loci-base loci-requirements
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-base:$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-keystone:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-glance:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-neutron:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-nova:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-placement:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-cinder:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-ironic:$(OPENSTACK_RELEASE)-$(DIST)
	$(PUSH) $(DOCKERHUB_NAMESPACE)/loci-swift:$(OPENSTACK_RELEASE)-$(DIST)

clean:
	rm -rf .loci .buildtarget
