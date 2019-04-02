VPATH=.clusterstate

DOCKERHUB_NAMESPACE=hogepodge
OPENSTACK_RELEASE=master
DIST=centos

up: .clusterstate .env
	rm -f .clusterstate/down
	rm -f .clusterstate/down-v
	docker-compose up -d 2>&1 | tee .clusterstate/up

down: .clusterstate
	touch .clusterstate/up
	mv .clusterstate/up .clusterstate/down
	docker-compose down 2>&1 | tee -a .clusterstate/down
	
up-ironic: .clusterstate .env
	rm -rf .clusterstate/down
	rm -rf .clusterstate/down-v
	docker-compose -f docker-compose.yml -f docker-compose-ironic.yml up -d 2>&1 | tee .clusterstate/up

down-ironic: .clusterstate
	touch .clusterstate/up
	mv .clusterstate/up .clusterstate/down
	docker-compose -f docker-compose.yml -f docker-compose-ironic.yml down 2>&1 | tee .clusterstate/down

down-v: .clusterstate
	touch .clusterstate/up
	touch .clusterstate/down
	cat .clusterstate/up .clusterstate/down > .clusterstate/down-v
	rm .clusterstate/up .clusterstate/down
	docker-compose down -v 2>&1 | tee -a .clusterstate/down-v

logs:
	docker-compose logs -f

.clusterstate:
	mkdir .clusterstate

.env:
	cp ../config/config .env

client:
	docker run -it --rm \
		-v ${CURDIR}/scripts/common:/scripts/common \
		-v ${CURDIR}/scripts/post-install:/scripts/post-install \
		-v ${CURDIR}/../build/images:/images \
		--env-file ${CURDIR}/../config/config \
		$(DOCKERHUB_NAMESPACE)/locistack-openstack:$(OPENSTACK_RELEASE)-$(DIST) \
		bash
