# Fiji & Oracle Java 8 Dockerfile for ARM32v7
#
# Derived from https://github.com/dockerfile/java/tree/master/oracle-java8
#

# Pull base ubuntu image
FROM arm32v7/ubuntu

# Define maintainer.
MAINTAINER Mark Hiner <hinerm@gmail.com>

# Install Oracle Java 8
RUN apt-get -y update \
&& apt-get -y install software-properties-common \
&& echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections \
&& add-apt-repository -y ppa:webupd8team/java \
&& apt-get -y update \
&& apt-get -y install oracle-java8-installer \
&& rm -rf /var/lib/apt/lists/* \
&& rm -rf /var/cache/oracle-jdk8-installer

# Define commonly used JAVA_HOME variable
ENV JAVA_HOME /usr/lib/jvm/java-8-oracle

# Define working directory.
WORKDIR /fiji

# Install Fiji.
RUN apt-get -y update \
&& apt-get install -y wget \
&& apt-get install -y unzip \
&& wget https://downloads.imagej.net/fiji/latest/fiji-nojre.zip \
&& unzip fiji-nojre.zip \
&& wget -P ./Fiji.app https://raw.githubusercontent.com/imagej/imagej/master/bin/ImageJ.sh \
&& chmod u+x ./Fiji.app/ImageJ.sh

# Add fiji to the PATH
ENV PATH $PATH:/fiji/Fiji.app

# Define default command.
CMD ImageJ.sh --headless
