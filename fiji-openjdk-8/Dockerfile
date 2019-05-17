#
# Fiji + Java 8 Dockerfile
#

# Pull base JDK-8 image.
FROM openjdk:8

# Define maintainer.
MAINTAINER Mark Hiner <hinerm@gmail.com>

# Define working directory.
WORKDIR /fiji

# Install Fiji.
# see https://github.com/fiji/fiji-builds/blob/master/.travis/build.sh#L84-L119
# for details on the double-run
RUN \
      curl -O https://downloads.imagej.net/bootstrapJ8.js && \ 
      jrunscript bootstrap8.js update-force-pristine && \
      jrunscript bootstrap8.js update-force-pristine

# Add fiji to the PATH
ENV PATH $PATH:/fiji

# Define default command.
CMD ["fiji-linux64"]
