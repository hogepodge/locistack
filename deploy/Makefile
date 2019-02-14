DOCKERHUB_NAMESPACE=hogepodge
OPENSTACK_RELEASE=master
DIST=centos

up:
	docker-compose up -d
	touch up

down:
	docker-compose down
	rm up

down-v:
	docker-compose down -v
	rm up

logs:
	docker-compose logs -f

client:
	docker run -it --rm \
		-v ${CURDIR}/scripts/common:/scripts/common \
		-v ${CURDIR}/scripts/client:/scripts/client \
		-v ${CURDIR}/scripts/post-install:/scripts/post-install \
		-v ${CURDIR}/../build/images:/images \
		--env-file ${CURDIR}/../config/config \
		$(DOCKERHUB_NAMESPACE)/locistack-openstack:$(OPENSTACK_RELEASE)-$(DIST) \
		bash
