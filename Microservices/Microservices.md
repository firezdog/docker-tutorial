https://www.youtube.com/watch?v=1xo-0gCVhTU
# What Is A Microservice?
* vs. monolith
* discrete business logic functions (e.g. authentication, user management, logging) that communicate (via http with api's)
  * multiple DB's
## Advantages And Disadvantages
### Advantages
* language independent (because of API's)
* faster iterations w/ small teams
* fault isolation (if one MS crashes others keep running)
* containers
* scaleable (+ cloud computing -- use only what you need cf. DockerIntro)
### Disadvantages
* ++ complexity (relationships multiply -- combinatorial explosion, paths)
* more architectural knowledge is required to navigate
  * containerization and container orchestrators
  * infrastructure -- harder to spin up (dynamically spinning up, containerizing, deploying on fly)
    * our current problems arise because we have to deploy our whole site every 4 weeks -- rather than just the pieces that get changed
## Docker
* container platform 
  * -- eliminates "it worked on my computer"
* vs. VM (cf. DockerIntro.md) -- no guest OS, just the app and its dependencies
  * example -- I can use the same "Node" container for three different Node applications (because of container layering described in DockerIntro.md)
* Images are defined by Dockerfile's
  * e.g. install Node, run npm install, then "npm start" on run
    * Another metaphor for containers -- AppPackages?
* More orgs are using microservices and Docker
## Kubernetes And Container Orchestration
* allow you to declare a microservice configuration (in the cloud, on a network)
    * start instances in Cloud -- I no longer have to ssh into different instances and build (+ debug)
    * instead, set up Kubernetes on each instance, and it will orchestrate
        * the devil must be in the details
### Vocabulary (High Level)
* Node: instance running Kubernetes -- communicates with master (kubelet)
* Pod: runs on a Kubelet, runs 1+ container(s)
* Service: handles requests from inside or outside cluster, e.g. load balancer
* Deployment: definition of the desired state (how many copies of each container etc.)
* Master contains replication controller, which sets up pods, histories (like git repo, vs?)
* use Yaml or JSON to write a deployment file (see sample in this repo)
* some features -- automatic rebooting of pods, rolling updates (client can be unaware anything happened)
# In Action
* docker ps -- all currently running pods
* docker run -- run an image (says container @20:08 but I think he means image)
    * docker run helloworld
    * sudo docker run tutum/hello-world -d -p 80 -- spins up a web server on port 8080
        * sudo docker port /<id> gives us the allocated port for that image
        * we can also go into the container using
            * docker exec -it /<container-id> ash (a low memory version of bash)