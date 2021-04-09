# Udacity AWS DevOps Engineer Capstone Project

[![Guillermo Ampie](https://circleci.com/gh/guillermo-ampie/devops-capstone.svg?style=shield)](https://github.com/guillermo-ampie/devops-capstone)

## Project Overview

This capstone project showcases the use of several CI/CD tools and cloud services covered in the program [Udacity - AWS Cloud DevOps Engineer.](https://www.udacity.com/course/cloud-dev-ops-nanodegree--nd9991)

### Introduction

This project "operationalize" a sample python/[flask](https://flask.palletsprojects.com/)
demo app ["hello"](./hello_app/hello.py), using [CircleCI](https://www.circleci.com) and
 a [Kubernetes](https://kubernetes.io/)(K8S) cluster deployed in [AWS EKS](https://aws.amazon.com/eks/)(Amazon Elastic Kubernetes Services):

* In a [CircleCI](https://www.circleci.com) pipeline, we lint the project's code, build
 a [Docker](https://www.docker.com/resources/what-container) image and deploy it to a public
Docker Registry: [Docker Hub](https://hub.docker.com/repository/docker/gampie/hello-app)
* Then in an [AWS EKS](https://aws.amazon.com/eks/) cluster, we run the application
* Later, we promote to production a new app version using a rolling update strategy

All the project's tasks are included in a [Makefile](Makefile), which uses several shell scripts stored in the
[bin](bin) directory.

### Project Tasks

Using a CI/CD approach, we build a [Docker](https://www.docker.com/resources/what-container) image and then run it in a [Kubernetes](https://kubernetes.io/) cluster.

The project includes the following main tasks:

* Initialize the Python virtual environment:  `make setup`
* Install all necessary dependencies:  `make install`
* Test the project's code using linting:  `make lint`
  * Lints shell scripts, Dockerfile and python code
* Create a Dockerfile to "containerize" the [hello](/hello_app/hello.py) application: [Dockerfile](hello_app/Dockerfile)
* Deploy to a public Docker Registry:
 [Docker Hub](https://hub.docker.com/repository/docker/gampie/hello-app) the containerized application
* Deploy a Kubernetes cluster:  `make eks-create-cluster`
* Deploy the application:  `make k8s-deployment`
* Update the app in the cluster, using a rolling-update strategy:  `make rolling-update`
* Delete the cluster:  `make eks-delete-cluster`

The CirclCI pipeline([config.yml](.circleci/config.yml)) will execute the following steps automatically:

* `make setup`
* `make install`
* `make lint`
* Build and publish the container image

To verify that the app is working, write your deployment's IP into your browser using port 80, like
`http://localhost:80` or `http://LOAD_BALANCER_IP:80` (according to your environment).

Alternatively, you can use `curl`: `curl localhost:80` or `curl LOAD_BALANCER_IP:80`

### CI/CD Tools and Cloud Services

* [Circle CI](https://www.circleci.com) - Cloud-based CI/CD service
* [Amazon AWS](https://aws.amazon.com/) - Cloud services
* [AWS EKS](https://aws.amazon.com/eks/) - Amazon Elastic Kubernetes Services
* [AWS eksctl](https://eksctl.io) - The official CLI for Amazon EKS
* [AWS CLI](https://aws.amazon.com/cli/) - Command-line tool for AWS
* [CloudFormation](https://aws.amazon.com/cloudformation/) - Infrastructure as Code
* [kubectl](https://kubernetes.io/docs/reference/kubectl/) - a command-line tool to control Kubernetes clusters
* [Docker Hub](https://hub.docker.com/repository/docker/gampie/hello-app) - Container images repository service

#### CicleCI Variables

  The project uses [circleci/docker](https://circleci.com/developer/orbs/orb/circleci/docker) orb,
  so to be able to `build` and `publish` your images, you need to set up the following environment
  variables in your CircleCI project with your DockerHub account's values:

* DOCKER_LOGIN
* DOCKER_PASSWORD
  
### Main Files

* [Makefile](./Makefile): the main file to execute all the project steps, i.e., the project's command center!
* [config.yml](.circleci/config.yml): to test and integrate the app under CircleCI
* [hello.app](./hello_app/hello.py): the sample python/flask app
* [Dockerfile](./hello_app/Dockerfile): the Docker image's specification file
* [hello_cluster.yml](./hello_cluster.yml): EKS cluster definition file

The following shell scripts are invoked from the [Makefile](./Makefile)

* [eks_create_cluster.sh](./bin/eks_create_cluster.sh): creates the EKS cluster
* [install_eksctl.sh](./bin/install_eksctl.sh): installs the eksctl tool
* [install_hadolint.sh](./bin/install_hadolint.sh): installs the hadolint linter(for Dockerfiles) tool
* [install_kubectl.sh](./bin/install_kubectl.sh): installs the kubectl tool to control K8S clusters
* [install_shellcheck.sh](./bin/install_shellcheck.sh): installs the shellcheck(for shell scripts) linter tool
* [k8s_cleanup_resources.sh](./bin/k8s_cleanup_resources.sh): deletes services and deployments in a K8S cluster
* [k8s_deployment.sh](./bin/k8s_deployment.sh): deploys and exposes a service in the K8S cluster
