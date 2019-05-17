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
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-nojre.zip \
 && unzip fiji-nojre.zip \
 && rm fiji-nojre.zip
RUN wget -O- https://raw.githubusercontent.com/imagej/imagej/master/bin/ImageJ.sh |grep -v PermSize > Fiji.app/ImageJ.sh \
 && chmod u+x ./Fiji.app/ImageJ.sh

# Add fiji to the PATH
ENV PATH $PATH:/fiji/Fiji.app

# Define default command.
ENTRYPOINT ["bash", "ImageJ.sh", "--headless"]
CMD ["--help"]
