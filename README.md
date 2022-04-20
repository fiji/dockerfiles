![Docker Hub pulls](https://img.shields.io/docker/pulls/fiji/fiji.svg)

# Fiji Dockerfile

This repository contains the Dockerfiles for [Fiji](https://fiji.sc), which are
used to deploy [fiji/fiji on DockerHub](https://hub.docker.com/r/fiji/fiji).

## Quick start

### Base Docker Image

* [openjdk](https://hub.docker.com/_/openjdk)

### Docker Tags

`fiji/fiji` provides multiple tagged images:

* `latest` (default): Fiji with OpenJDK 8
* `fiji-openjdk-8`: Fiji with OpenJDK 8
* `fiji-openjdk-11`: Fiji with OpenJDK 11

For example, you can run an `OpenJDK 8` container with the following command:

  docker run -it --run fiji/fiji:fiji-openjdk-8

## Details

[Docker](https://www.docker.com/resources/what-container/) provides a platform
for distribution of application state. This facilitates the highest level of
scientific
[reproducibility](https://imagej.net/develop/architecture#reproducible-builds):
a Docker image can bundle operating system, Java version, update site and
plugin state, and even sample data. These images can then be reused by remote
users and scientists worldwide, with no dependency concerns beyond Docker
itself.

### Pre-Requisites

You will need to [install Docker](https://docs.docker.com/get-docker/)
for your system.

Instructions for building images from Dockerfiles is available from the
[official documentation](https://docs.docker.com/engine/reference/builder/).

### How to use the Fiji Docker images

The base Fiji images are provided as
[fiji/fiji on Docker Hub](https://hub.docker.com/r/fiji/fiji).
These images call the Fiji executable by default. For example:

```shell
docker run -it --rm fiji/fiji
```

will call the default Fiji image, attempting to open the Fiji application
with OpenJDK 8.

Several [tags](https://hub.docker.com/r/fiji/fiji/tags) are provided to run
Fiji with different Java versions. For example, if you wanted to run with
OpenJDK 11, you would use:

```shell
docker run -it --rm fiji/fiji:fiji-openjdk-11
```

> :warning: **Without some extra setup, there is no display used by Docker.**
> So if you just tried one of the above commands, you likely got an error:
> ```
> No GUI detected.  Falling back to headless mode.
> ```
> The following sections cover [headless](#running-headless) and
> [graphical](#running-the-ui) uses.

### Running headless

Running Fiji headlessly in Docker is not much different than normal headless
operation&mdash;see the [headless guide](https://imagej.net/learn/headless) for
general information. To start a headless Fiji invocation from Docker, use:

```shell
docker run -it --rm fiji/fiji fiji-linux64 --headless
```

If you want to manually explore the Fiji Docker image, e.g. to install
additional plugins or utility software, you can start the command prompt via:

```shell
docker run -it --rm fiji/fiji bash
```

Just be sure to [commit any
changes](https://docs.docker.com/engine/reference/commandline/commit/)!

### Running the UI

This is, unfortunately, currently quite platform-specific. Docker has tight
Linux integration, so it is much easier to share displays with a Docker image
if you are using a Linux host. However, it is not impossible on other
architectures.

Note that this is highly experimental right now, and the steps to get Fiji
running can be fairly involved. Please
[report issues](https://github.com/fiji/dockerfiles/issues) and contribute
suggestions if you have ideas for improving interoperability between Fiji's UI
and Docker.

#### On Linux

We can adapt
[this blog post](http://fabiorehm.com/blog/2014/09/11/running-gui-apps-with-docker/) on
running GUI applications with Docker to share the X11 port.

Use this Dockerfile as a starting point:

```docker
# Modify this tag if a different java version is desired
FROM fiji/fiji:fiji-openjdk-7
# Replace 1000 with your user / group id
RUN export uid=1000 gid=1000 && \
    mkdir -p /home/developer && \
    echo "developer:x:${uid}:${gid}:Developer,,,:/home/developer:/bin/bash" >> /etc/passwd && \
    echo "developer:x:${uid}:" >> /etc/group && \
    echo "developer ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/developer && \
    chmod 0440 /etc/sudoers.d/developer && \
    chown ${uid}:${gid} -R /home/developer
USER developer
ENV HOME /home/developer
CMD fiji-linux64
```

Install the Dockerfile with:

```shell
docker build -t fiji .
```

Run Fiji with:

```shell
docker run -ti --rm \
     -e DISPLAY=$DISPLAY \
     -v /tmp/.X11-unix:/tmp/.X11-unix \
     fiji/fiji
```

Which should pop up a window with Fiji running.

#### On macOS

##### boot2docker

To get a GUI application running on macOS, we can adapt the techniques
discussed in [this docker issue](https://github.com/docker/docker/issues/8710)
to run an X11 session, and share it with Docker.

First, you will need to install the following:

1.  [Homebrew](https://brew.sh/)
2.  [Homebrew-cask](https://github.com/caskroom/homebrew-cask)

Then, from a terminal, use Homebrew to install
[socat](https://www.cyberciti.biz/faq/linux-unix-tcp-port-forwarding/) and
[XQuartz](https://www.xquartz.org/) via:
```shell
brew install socat
brew cask install xquartz
```

Now open a new terminal window and type
```shell
echo $DISPLAY
```
and ensure it is not empty (it should print something like
`/private/tmp/com.apple.launchd.GYg5TvcMIf/org.macosforge.xquartz:0`).

Then run:
```shell
ifconfig
```
which will print output that should end with something like:
```
vboxnet0: flags=0000<UP,BROADCAST,RUNNING,PROMISC,SIMPLEX,MULTICAST>
ether 00:00:00:00:00:00
inet 192.168.15.2 netmask 0xffffffff broadcast 192.168.0.0
```

And take note of the ip address on the last line (`192.168.15.2` in this case).

Since you are using macOS it is assumed you are using
[boot2docker](https://boot2docker.io/). Now, in the same terminal you started
boot2docker, you should have set up the environment variables e.g. with

```shell
$(boot2docker shellinit)
```

From this same terminal, open XQuartz with:
```shell
open -a XQuartz
```

This will start up a new X11 session. You will want two X11 terminals open here
(`Application > Terminal` to open a new X11 terminal).

In one X11 terminal, run:
```shell
socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\"
```

to start listening for X11 forwarding. In the second terminal, you can now use
Docker to launch a Fiji GUI. For example:

```shell
docker run -e DISPLAY=192.168.15.2:0 fiji/fiji
```

Where the IP address was what we found earlier with `ifconfig`.

Congratulations! You should now be running Fiji in a Docker image.

##### Docker Desktop

[Docker Desktop](https://www.docker.com/products/docker-desktop/) is a
UI-oriented way to start Docker containers. It makes it very easy to download
and run new images. However, we have not yet investigated how to run the Fiji
UI with Docker Desktop.

### Exposing your data

Once you have Fiji up and running, you will probably want to open some images.

The best way to share data with Docker is to use volumes. For example, if your
data is in `/Users/foo/data`, launching the Fiji image with:

```shell
docker run -v /Users/foo/data:/fiji/data -e DISPLAY=192.168.15.2:0 fiji/fiji
```

will create a `data` subdirectory in the Fiji installation, which you can then
open images from as normal.

For more information on using volumes, see the
[Docker user guide](https://docs.docker.com/storage/volumes/).

### Docker image structure

In these docker images, you will find Fiji installed in the `/fiji` directory,
which has been added to the `PATH` of the image (so that Fiji can be run as the
default command).

### Troubleshooting

If you run into any problems or have questions about Fiji + Docker, please use:

-   [GitHub](https://github.com/fiji/dockerfiles/issues)
-   [Image.sc](https://forum.image.sc/) - use the `fiji` and `docker` tags
