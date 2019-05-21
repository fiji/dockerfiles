#
# Fiji + Java 8 Dockerfile
#

# Pull base JDK-8 image.
FROM openjdk:8

# Define maintainer.
LABEL maintainer="https://gitter.im/fiji/fiji"

# Define working directory.
WORKDIR /opt/fiji

# Install Fiji.
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-nojre.zip \
 && unzip fiji-nojre.zip \
 && rm fiji-nojre.zip

# Add fiji to the PATH
ENV PATH $PATH:/home/fiji/Fiji.app

# Define entrypoint.
COPY entrypoint.sh /opt/fiji
ENTRYPOINT ["./entrypoint.sh"]
