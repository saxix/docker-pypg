POSTGRES_DB?=test
VERSIONS = $(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%))
TESTS=$(foreach df,$(wildcard */Dockerfile),$(df:%/Dockerfile=%)-test)

help:
	echo ${TESTS}
	@echo "build                   build"
	@echo "run                     run the container"
	@echo "clean                   remove the container"

build: $(VERSIONS)
test: $(TESTS)

define release
$1:
	@docker build --squash -t saxix/pypg:$(shell echo $1 | sed -e 's/-.*//g') $1
endef

define testme
$1:
	PG_MAJOR=$(shell echo $1 | sed -e 's/.*-\(.*\)-test/\1/g')
	rm -fr ~data
	docker run -it \
		-e POSTGRES_DB=${POSTGRES_DB} \
		-v ${PWD}/tests:/tests \
		-v ${PWD}/~data:/var/lib/postgresql/${PG_MAJOR}/main \
		saxix/pypg:$(shell echo $1 | sed -e 's/-.*//g') /bin/bash -c "cd /tests && /tests/runtests.sh"
endef

$(foreach version,$(VERSIONS),$(eval $(call release,$(version))))


$(foreach test,$(TESTS),$(eval $(call testme,$(test))))


.PHONY: all build update $(VERSIONS)


#build2:
#	docker build --squash --rm --compress -t ${NAME} --build-arg DISTRO=${DISTRO} -f Dockerfile .
#
#run:
#	docker run -it \
#		-v ${PWD}/~data:${PG_DATADIR} \
#		-v ${PWD}/scripts:/scripts \
#		${NAME} /bin/bash
#
#test:
#	docker run -it \
#		-e POSTGRES_DB=${POSTGRES_DB} \
#		-v ${PWD}/tests:/tests \
#		-v ${PWD}/~data:${PG_DATADIR} \
#		${NAME} /bin/bash -c "cd /tests && /tests/runtests.sh"
#
#
clean:
	rm -fr ~data
#
#fullclean: clean
#	docker rmi -f ${NAME}
