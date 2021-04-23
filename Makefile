today = $(shell date +%Y%m%d)

latest = fiji-openjdk-8

images = \
$(latest) \
fiji-openjdk-7 \
fiji-openjdk-11

## Currently broken:
## - fiji-oracle-jdk6
## - fiji-openjdk-6
## - fiji-oracle-jdk7
## Propose removal

## Must be built on special hardware:
## - fiji-oracle-jdk8-arm32v7

all : update build

update :
	@for image in $(images); do (cd $${image}; grep FROM Dockerfile | cut -f2 -d" " | xargs docker pull); done

build: $(images)

$(images) : %:
	cd $@ && docker build -t fiji/fiji:$@ .

release :
	for f in $(images); do docker tag fiji/fiji:$${f} fiji/fiji:$${f}.$(today); done
	for f in $(images); do docker push fiji/fiji:$${f}.$(today); done
	for f in $(images); do docker push fiji/fiji:$${f}; done
	docker tag fiji/fiji:$(latest) fiji/fiji:latest;
	docker tag fiji/fiji:$(latest) fiji/fiji:$(today);
	docker push fiji/fiji:latest;
	docker push fiji/fiji:$(today);

clean :
	@for image in $(images); do echo docker rmi fiji/fiji:$${image}; done
	docker rmi fiji/fiji:latest

.PHONY: all update build release clean $(images)
