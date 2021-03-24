# Udacity AWS DevOps Engineer Capstone Project

[![Guillermo Ampie](https://circleci.com/gh/guillermo-ampie/devops-capstone.svg?style=shield)](https://github.com/guillermo-ampie/devops-capstone)

## Project Overview

This capstone project showcases the use of several CI/CD tools and cloud services covered in the program [Udacity - AWS Cloud DevOps Engineer](https://www.udacity.com/course/cloud-dev-ops-nanodegree--nd9991)

### Introduction

### Project Tasks

Operationalize the sample python/flask demo application hello_app using CircleCI and [kubernetes](https://kubernetes.io/) deployed to AWS EKS - Amazon Elastic Kubernetes Services. This project include the following task:

* Test your project code using linting: `make lint`
* Complete a Dockerfile to containerize this application: [Dockerfile](Dockerfile)
* Deploy your containerized application using Docker and make a prediction
  * [run_docker.sh](run_docker.sh)
    * Sample output: [docker_out.txt](output_txt_files/docker_out.txt)
  * [make_prediction.sh](make_prediction.sh)
    * Sample output [prediction_out.txt](output_txt_files/prediction_out.txt)
* Improve the log statements in the source code for this application: [app.py](app.py)
* Configure Kubernetes and create a Kubernetes cluster

### CI/CD Tools and Cloud Services

### Main Files
