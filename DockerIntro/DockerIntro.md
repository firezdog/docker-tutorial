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
## Detached Mode
* We want to be able to start a container and keep it running in the background
* use "-d" flag
* output: long id
## docker ps
* we can use "docker ps" to see all the containers running.
* "docker ps -a" shows all containers that have run
* "docker run --rm ..." will remove the container when it is done -- doesn't appear under "docker ps -a" either
## Set Docker Container Name
* docker run --name: let's us give a name to the container being run (otherwise it is auto-generated)
## Docker Inspect Command
* docker inspect \<id>: low-level info -- e.g. image-id and log path
# Docker Port Mapping and Docker Logs
* use Tomcat image -- Tomcat executes java servlets
* -p host-port:container-port option specifies the port Tomcat server opens on.
* run command "docker run -it -p 8888:8080 tomcat:8.0 (note the order in which commands are typed does matter)
* running in detached mode won't put a bunch of junk in the console
* docker logs command + name gives us the logs of the running container
# Docker Image Layers
* docker image is composed of a stack of read-only layers
  * e.g. base image <= image <= image <= container
  * docker history \<image> gives the layers
* new containers created writeable layer on top of stack -- changes will be added to this layer.
* each layer is like a modification to the original image
* deleting a container also means deleting this writeable layer, leaving the image intact
* writeable layers allow multiple layers to be created from one image.
# Building Docker Images
* Two methods
  1. Commit changes in a container (commit the writeable layer to the image)
  2. Write a Dockerfile
* We will
  1. spin up container from base image (debian)
  2. install git package
  3. commit changes in container to build a new image
* What I did
  * docker run -it debian (gets the latest debian)
  * in debian, apt-update, apt-get install (-y) git
  * docker commit \<container_id> \<repo/image:tag>
* we can then spin up containers based on the committed image
# Writing Docker Files (51:45)
* text file containing instructions that assemble an image
* 1 instruction = 1 image layer
* Called "Dockerfile"
* Written line by line
* FROM -- base image (note, docker instructions even images have autocomplete!)
* RUN + /<command>
* to build docker image, we use "docker build -t /<image-tag> /<build-context>
  * arg to build context (copying source code to docker container) (but we find Dockerfile by default in context, otherwise -f)
* docker daemon runs each construction inside a different container, then removes it (layering on the image) -- each container is ephemeral and then committed to image as instructions are run
# Docker Images In Depth (59:30)
* Chaining RUNs
  * Each run command adds a new image layer -- chaining reduces layers
  * use && instead of RUN
  * sort multi-line args alphabetically (avoid duplication, easier update)
* Cleanup note: 
  * "docker rmi $(docker images -q) --force" 
  * "docker rm $(docker ps -a -q)"
* CMD Instructions
  * What does the container do when it starts?  Default command is for example "bash"
  * exec (preferred) or shell
    * ["echo", "hello world"]
  * we can over-write the default command
* Docker Cache
  * Docker build re-uses existing layers if instructions don't change ("using cache")
  * (If we have a new tag, we get a new container, but the existing layer is still used)
  * Aggressive caching
    * If we change "apt-get install ..." after "apt-get update", only the changed instruction executes -- but that means we may have an outdated apt-get registry
    * To avoid this, we chain
  * invalidate the cache --no-cache=true
  * COPY: copies files from build context into the container
  * ADD: lets you download and copy files from internet (as well as unpacking compressed files) -- but COPY is considered more transparent (stripped down ADD)
# Pushing Images to Docker Hub (1:07)
* Log in to dockerhub
* associate image with dockerhub account -- rename image to "/<dockerhubid>/reponame"
* docker tag -- rename a docker image.
  * avoid using the default "latest" tag -- "latest" is only a convention and there is no special behavior associated with it -- better to version tags every time.
  * docker tag /<image id> /<username>/riverrun:1.0
* docker login; docker push /<image name>