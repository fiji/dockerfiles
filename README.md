## Fiji Dockerfile

This repository contains Dockerfile of [Fiji](fiji.sc) for [fiji/fiji on DockerHub](https://registry.hub.docker.com/u/fiji/fiji/).

### Base Docker Image

* [dockerfile/java](http://dockerfile.github.io/#/java)

### Docker Tags

`fiji/dockerfile` provides multiple tagged images:

* `latest` (default): Fiji with OpenJDK Java 7
* `fiji-openjdk-6`: Fiji with OpenJDK Java 6
* `fiji-openjdk-7`: Fiji with OpenJDK Java 7
* `fiji-oracle-jdk6`: Fiji with Oracle Java 6
* `fiji-oracle-jdk7`: Fiji with Oracle Java 7

For example, you can run an `Oracle Java 7` container with the following command:

  docker run -it --run fiji/fiji:fiji-oracle-7

### Pre-requisites

* Install [Docker](https://www.docker.com/).
