#
# Fiji + Java 8 Dockerfile
#

# Pull base JDK-8 image.
FROM openjdk:8

# Define maintainer.
LABEL maintainer="https://gitter.im/fiji/fiji"

# Create a user.
RUN useradd -u 1000 -ms /bin/bash fiji
USER fiji

# Define working directory.
WORKDIR /home/fiji

# Install Fiji.
RUN wget -q https://downloads.imagej.net/fiji/latest/fiji-nojre.zip \
 && unzip fiji-nojre.zip \
 && rm fiji-nojre.zip

# Add fiji to the PATH
ENV PATH $PATH:/home/fiji/Fiji.app

# Define entrypoint.
COPY entrypoint.sh /home/fiji
ENTRYPOINT ["./entrypoint.sh"]

# Run once to create Java preferences.
COPY demo.py /home/fiji/
RUN ./entrypoint.sh --headless --ij2 --console --run ./demo.py 'name="test"'
