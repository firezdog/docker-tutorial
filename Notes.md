https://www.youtube.com/watch?v=VlSW-tztsvM

# Why Docker?
* Before docker: app with dependencies running in OS on host server.
* Problems: expensive and inefficient, slow deployment (physical setup), migration (e.g. IBM to Dell)
* Solution 1: hypervisor-based virtualization (think Vagrant)
  * Hypervisor let us install multiple VM's with different OS's on host OS.
    * VMWare, Virtual Box
    * Servers from AWS or Azure
  * Use what you need, scale
  * Limitation: kernel resource duplication -- overlap between what different OS's on different containers use
* Solution 2: container based
  * Container engine running on host OS provides a single kernel that different containers can share
  * What do we gain?  runtime isolation -- e.g. differnt JRE's -- seems like the OS has a pristine state that each container then adapts
  * cost efficient -- required components added to each container, less resource intensive, more containers, faster deployment
  * application bundles that can run across machines (as long as Docker is installed)
# Docker Client / Server Architecture
  * DOCKER_HOST and docker clients -- remotely, a docker registry
  * Docker daemon is used to manage different clients (build, pull, run)
  * containers and image
  * docker clients: command line or GUI (kitematic)
  * daemon builds, runs, and distributes (engine, server)
  * docker client and daemon typically run on the same OS (e.g. Linux) 
    * or else client runs on main OS and daemon runs on Linux kernel in a VM on Windows / Mac)
# Docker Concepts
* Containers and images
  * image: read-only template used to create a container (image precedes the container)
    * docker build
    * can be composed of images
    * stored in registry (DockerHub)
  * container: instance of an image (like instance of a class), represents an environment containing what is needed to run app
  * registry: stores images in repositories
    * repository is like a git repository -- tags are like branches or commits
    * docker hub: browse various repos of docker images, e.g. MySQL images, including official images (curated)
# Creating and Running a Simple Container
* We will use "busybox" image -- tiny, only 1mb
* run in tag "1.24"
* docker first searche for image locally, otherwise goes to registry
* to see images, run "docker images"
* to run container, use "docker run \<repository:tag> \<command>", e.g. "docker run busybox:1.24 echo 'hello world'"
* we can now see the image when running "docker images" with unique ID -- this will now be used to run in future (faster)
* we can run other commands, like "ls /" 
  * the container has its own local installs which are loaded into the common kernel
  * -i starts an interactive container, -t attaches stdin and stdout with pseudo-TTY (emulated terminal)
  * docker run -it busybox:1.24 will take us into the container
  * note that each time we do this, we get a new container, so files previously added will not persist
# Docker Containers: Deep Dive
* We want to be able to start a container and keep it running in the background
* use "-d" flag
* output: long id
* we can use "docker ps" to see all the containers running.
* "docker ps -a" shows all containers that have run
* "docker run --rm ..." will remove the container when it is done -- doesn't appear under "docker ps -a" either
* docker run --name: let's us give a name to the container being run (otherwise it is auto-generated)
* docker inspect \<id>: low-level info -- e.g. image-id and log path
## Detached Mode
## docker ps
## Set Docker Container Name
## Docker Inspect Command