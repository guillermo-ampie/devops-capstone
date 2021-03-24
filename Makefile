## The Makefile includes instructions on: 
# environment setup, install, lint and build

#Vars
CLUSTER_NAME=hello
REGION_NAME=us-west-2
KEYPAIR_NAME=key-pair-us-west-2
DEPLOYMENT_NAME=hello-app
NEW_IMAGE_NAME=registry.hub.docker.com/gampie/hello-app:latest
CONTAINER_PORT=80
HOST_PORT=8080
LOCAL_CONTEXT=minikube
CLOUD_CONTEXT=amp@hello.us-west-2.eksctl.io

setup:
	# Create a python virtualenv & activate it
	python3 -m venv ~/.devops-capstone
	# source ~/.devops-capstone/bin/activate 

install:
	# This should be run from inside a virtualenv
	echo "Installing: dependencies..."
	pip install --upgrade pip &&\
	pip install -r hello_app/requirements.txt &&\
	pip install "ansible-lint[community,yamllint]"
	echo
	pytest --version
	ansible --version
	ansible-lint --version
	echo
	echo "Installing: shellcheck"
	./bin/install_shellcheck.sh
	echo
	echo "Installing: hadolint"
	./bin/install_hadolint.sh
	echo
	echo "Installing: kubectl"
	./bin/install_kubectl.sh
	
test:
	# Additional, optional, tests could go here
	#python -m pytest -vv --cov=myrepolib tests/*.py
	#python -m pytest --nbval notebook.ipynb

lint:
	# https://github.com/koalaman/shellcheck: a linter for shell scripts
	./bin/shellcheck -Cauto -a ./bin/*.sh
	# https://github.com/hadolint/hadolint: a linter for Dockerfiles
	./bin/hadolint hello_app/Dockerfile
	# https://www.pylint.org/: a linter for Python source code 
	# This should be run from inside a virtualenv
	#pylint --disable=R,C,W1203 app.py
	pylint --output-format=colorized --disable=C hello_app/hello.py

run-app:
	python3 hello_app/hello.py

build-docker:
	./bin/build_docker.sh

run-docker: build-docker
	./bin/run_docker.sh

upload-docker: build-docker
	./bin/upload_docker.sh

ci-validate:
	# Required file: .circleci/config.yml
	circleci config validate

local-set-k8s-context: 
	kubectl config set-context "${LOCAL_CONTEXT}"

cloud-set-k8s-context:
	kubectl config set-context "${CLOUD_CONTEXT}"

local-run-k8s: local-set-k8s-context
	# Before, run: minikube start
	./bin/run_k8s.sh

cloud-run-k8s: cloud-set-k8s-context
	./bin/run_k8s.sh

local-port-forwarding: local-set-k8s-context
	# Needed for "minikube" only
	kubectl port-forward service/${DEPLOYMENT_NAME} ${HOST_PORT}:${CONTAINER_PORT}

local-rolling-update: local-set-k8s-context
	kubectl get deployments -o wide
	kubectl set image deployments/${DEPLOYMENT_NAME} \
		${DEPLOYMENT_NAME}=${NEW_IMAGE_NAME}
	echo
	kubectl get deployments -o wide
	kubectl describe pods | grep -i image
	kubectl get pods -o wide

cloud-rolling-update: cloud-set-k8s-context
	kubectl get deployments -o wide
	kubectl set image deployments/${DEPLOYMENT_NAME} \
		${DEPLOYMENT_NAME}=${NEW_IMAGE_NAME}
	echo
	kubectl get deployments -o wide
	kubectl describe pods | grep -i image
	kubectl get pods -o wide

local-rollout-status: local-set-k8s-context
	kubectl rollout status deployment ${DEPLOYMENT_NAME}
	echo
	kubectl get deployments -o wide
	kubectl get pods -o wide

cloud-rollout-status: cloud-set-k8s-context 
	kubectl rollout status deployment ${DEPLOYMENT_NAME}
	echo
	kubectl get deployments -o wide
	kubectl get pods -o wide

local-rollback: local-set-k8s-context
	kubectl get deployments -o wide
	kubectl rollout undo deployment ${DEPLOYMENT_NAME}
	kubectl describe pods | grep -i image
	echo
	kubectl get pods -o wide
	kubectl get deployments -o wide

cloud-rollback: cloud-set-k8s-context 
	kubectl get deployments -o wide
	kubectl rollout undo deployment ${DEPLOYMENT_NAME}
	kubectl describe pods | grep -i image
	echo
	kubectl get pods -o wide
	kubectl get deployments -o wide

local-clean-k8s-resources: local-set-k8s-context
	./bin/clean_up_k8s_resources.sh

cloud-clean-k8s-resources: cloud-set-k8s-context
	./bin/clean_up_k8s_resources.sh

eks-create-cluster:
	eksctl create cluster \
		--name "${CLUSTER_NAME}" \
		--region "${REGION_NAME}" \
		--with-oidc \
		--ssh-access \
		--ssh-public-key "${KEYPAIR_NAME}" \
		--managed

eks-delete-cluster:
	eksctl delete cluster --name "${CLUSTER_NAME}" \
		--region "${REGION_NAME}"
